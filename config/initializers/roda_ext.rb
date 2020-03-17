class Roda
  def set_time_zone(request)
    session[:time_zone] ||= (
      request.try(:location).try(:data).try(:fetch, "timezone", nil) ||
      "America/Phoenix"
    )
  end

  class << self
    def render_plugins
      plugin :render, escape: true
      plugin :sessions, secret: ENV["SESSION_SECRET"]
      plugin :route_csrf
      plugin :public
    end
  end
end