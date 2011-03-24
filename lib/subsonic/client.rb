module Subsonic
  class Client
    include ::HTTParty

    API_VERSION = {
      '3.8'   => '1.0.0',
      '3.9'   => '1.1.1',
      '4.0'   => '1.2.0',
      '4.1'   => '1.3.0',
      '4.2'   => '1.4.0',
      '4.3.1' => '1.5.0'
    }

    attr_accessor :url, :version, :api_version, :user

    def initialize(url, username, password, options={})
      pass_prefix = options[:enc] ? "enc:" : ""
      version = @version = options[:version] || API_VERSION.values.last
      @api_version = API_VERSION[@version] || version
      format = options[:format] || "json"

      Struct.new("User", :username, :password)
      @user = Struct::User.new(username, "#{pass_prefix}#{password}")
      username, password = @user.username, @user.password

      self.class.class_eval do
        base_uri url
        default_params :u => username, :p => password,
                       :v => version,   :f => format, :c => "subsonic-rb.gem"
      end
    end

    def now_playing
      response = self.class.get('/getNowPlaying.view')
      if response.code == 200
        now_playing = response.parsed_response['subsonic-response']['nowPlaying']['entry']
        if now_playing.is_a? Array
          now_playing.map {|entry| "#{entry['artist']} - #{entry['title']}"}
        else
          "#{now_playing['artist']} - #{now_playing['title']}"
        end
      end
    end

    def say(message)
      response = self.class.post('/addChatMessage.view', :query => {:message => message})
      response.code == 200 ? message : false
    end

    def messages
      response = self.class.get('/getChatMessages.view')
      if response.code == 200
        chat_messages = response.parsed_response['subsonic-response']['chatMessages']['chatMessage']
        chat_messages.map do |msg|
          time = Time.at(msg['time'] / 1000)
          "[#{time.strftime("%b-%e")}] #{msg['username']}: #{msg['message']}"
        end
      end
    end

    def random_songs
      response = self.class.get('/getRandomSongs')
      if response.code == 200
        songs = response['subsonic-response']['randomSongs']['song']
        songs.map do |song|
          {:song => "#{song['artist']} - #{song['title']}",
           :id => song['id']}
        end
      end
    end

    def add_song(*ids)
      count = ids.length
      ids = ids.join(',').gsub(/\s/, '')
      response = self.class.post('/jukeboxControl.view', :query => {:action => 'add', :id => ids})
      response.code == 200 ? "#{count} songs added" : false
    end

  end
end
