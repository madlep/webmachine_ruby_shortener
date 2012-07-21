$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'webmachine'
require 'webmachine/adapters/rack'
require 'link_resource'

ShortenerApp = Webmachine::Application.new do |app|
  app.routes do
    # POST /link
    # GET  /link/<id>
    add ['trace', '*'], Webmachine::Trace::TraceResource
    add [], LinkResource
    add [:short_link], LinkResource
  end
end

ShortenerApp.configure do |config|
  config.adapter = :Rack
end

ShortenerApp.run
