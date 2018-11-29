include SendGrid

module Error
  module ErrorHandler

    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |e|
          begin
            # if on prod send me an email if not then do nothing but raising the exception
            if ENV["RAILS_ENV"] != nil && ENV["RAILS_ENV"] == 'production'
              # the piece that goes on the end of all of the emails
              outro = "<p><b><strong>Please do not reply to this email.</strong></b><p/><p>Sincerely,</p><p>Kaden Aayhan<br />Assistant to the CEO<br />BendroCorp, Inc.</p><p>Corp Plaza 11, Platform R3Q<br />Crusader, Stanton</p>"

              # message
              message_in = "<p>The following error occured on the BendroCorp site:</p> <p>#{e.message.to_s}</p><p>#{e.backtrace.join("\n <br />")}</p>"

              # the actual email itself
              from = Email.new(email: 'no-reply@bendrocorp.com')
              to = Email.new(email: ENV['ADMIN_EMAIL'])
              subject = "BendroCorp - Error Message - #{e.message.to_s}"
              content = Content.new(type: 'text/html', value: message_in + outro)
              mail = SendGrid::Mail.new(from, subject, to, content) # https://github.com/sendgrid/sendgrid-ruby/issues/67
              mail_json = mail.to_json
              puts 'Send email:'
              puts mail_json
              puts
              if ENV['SENDGRID_API_KEY'] != nil
                sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])#
                response = sg.client.mail._("send").post(request_body: mail_json)

                puts "SendGrid response code:"
                puts "#{response.status_code}"
                puts

                if !(response.status_code == 200 || response.status_code == 202)
                  puts response.body
                end
              end

              # Log the error
              SiteLog.create(module: 'Error Handler', submodule: 'Error', message: "#{e.message} \n #{e.backtrace.join("\n")}", site_log_type_id: 3)

            end
          rescue SocketError => e
            puts e.message
          end

          # now that we have reported it just raise the original exception
          raise e
        end

      end
    end
  end
end
