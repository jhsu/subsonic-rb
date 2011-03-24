# Subsonic

    client = Subsonic::Client.new(url, username, password)
    

## Now Playing

    client.now_playing

returns a string in "artist - track" or an array if more people are streaming
