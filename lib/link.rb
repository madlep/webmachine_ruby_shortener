require 'redis'
require 'digest'

class Link
  LINK_CHARACTERS = (("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a)
  LINK_LENGTH = 5

  SHORT_KEY = "SL"

  attr_accessor :short_link, :url, :errors

  def self.connected?
    begin
      Redis.current.ping
      true
    rescue Redis::CannotConnectError
      false
    end
  end

  def self.generate_short_link
    link = nil
    until !link.nil? && !Redis.current.exists(short_key(link))
      link = LINK_LENGTH.times.inject(""){|link| 
        link + LINK_CHARACTERS[rand(LINK_CHARACTERS.length)] 
      }
    end
    link
  end

  def self.find(short_link)
    return nil unless short_link
    url = Redis.current.get(short_key(short_link))
    if url
      Link.new(:url => url, :short_link => short_link)
    else
      nil
    end
  end

  def initialize(options={})
    @short_link = options[:short_link]
    @url        = options[:url]
    @errors     = []
  end

  def save
    return false unless valid?
    short_key     = Link.short_key(@short_link)
    Redis.current.set(short_key, @url)
    true
  end
  
  def valid?
    @errors = []
    # TODO add URL format validation
    @errors << "short_link is missing" unless @short_link
    @errors << "url is missing" unless @url && !@url.strip.empty?
    @errors.empty?
  end

  private
  def self.short_key(short_link)
    "#{SHORT_KEY}_#{short_link}"
  end

end
