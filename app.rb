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
require "./config/initializers/roda_ext"

class App < Roda # :nodoc:
  render_plugins

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
