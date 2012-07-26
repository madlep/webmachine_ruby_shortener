require 'link'
require 'json'

class LinkResource < Webmachine::Resource
  def trace?
    true
  end

  def service_available?
    Link.connected?
  end

  def allowed_methods
    %w{GET POST HEAD}
  end

  def content_types_provided
    [["application/json", :ignore]]
  end

  def resource_exists?
    short_link = request.path_info[:short_link]
    @link = Link.find(short_link)
    false
  end

  def previously_existed?
    !@link.nil?
  end

  def moved_permanently?
    @link ? @link.url : false
  end

  def allow_missing_post?
    true
  end

  def post_is_create?
    true
  end

  def create_path
    short_link = Link.generate_short_link
    @link = Link.new(:short_link => short_link)
    request.disp_path + "/" + short_link
  end

  def content_types_accepted
    [["application/json", :save_link]]
  end

  def save_link
    parsed_body = JSON.parse(request.body.to_s)
    @link.url = parsed_body["url"]
    if @link.save
      :ok
    else
      response.body = JSON.generate(@link.errors)
      422
    end
  end

end
