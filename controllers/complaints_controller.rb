require "./config/initializers/roda_ext"

class ComplaintsController < Roda
  render_plugins
  
  route do |r|
    r.is do
      r.post do
        complaint = Complaint.new(
          title: r.params['title'],
          target: r.params['target'],
          body: r.params['body']
        )

        if complaint.save
          MailWorker.perform_async(
            "complaint" => complaint.as_json,
            "emails" => r.params['bcc']
          ) if r.params['bcc']&.any?

          session[:message] = "Your complaint has been posted!"
          view('complaints/index')
        else
          session[:message] = "Something went wrong. Please try again."
          r.redirect "/complaints/new"
        end
      end

      r.get do
        r.redirect "/feed" unless r.env["HTTP_ACCEPT"] == "application/json"
        response.headers['Content-Type'] = 'application/json'

        if r.params['days_ago']&.empty?
          r.params['days_ago'] = nil
        end

        response.write Complaint.in_json(r.params['days_ago'], set_time_zone(r))
      end
    end

    r.get "new" do
      view('complaints/new')
    end
  end
end
