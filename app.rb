require 'dotenv/load'
require 'roda'
require "json"
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require 'erubi'
require "sinatra/activerecord"
require "active_support/core_ext/time"
require "geocoder"
require "pry"

require "./controllers/complaints_controller"
require "./jobs/mail_job"
require "./models/complaint"

class Roda
  def set_time_zone(request)
    session[:time_zone] ||= (
      request.try(:location).try(:data).try(:fetch, "timezone", nil) ||
      "America/Phoenix"
    )
  end
end

class App < Roda # :nodoc:
  plugin :render, escape: true
  plugin :sessions, secret: ENV["SESSION_SECRET"]
  plugin :route_csrf
  plugin :public

  route do |r|
    r.public
    r.root do
      view('complaints/new')
    end

    r.on 'feed' do
      view('complaints/index')
    end

    r.on 'complaints' do
      r.run ComplaintsController
    end
  end
end
