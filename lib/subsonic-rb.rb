$:.unshift(File.dirname(__FILE__) + '/subsonic')

%w[
  httparty
  json
  client
].each do |file|
  require file
end

module Subsonic
  autoload :Client, "./subsonic-rb/client"
end
