class PushWorker
  include Sidekiq::Worker

  def perform(user_id, message)
    user = User.find_by_id(user_id.to_i)
    if user
      user.user_push_tokens.each do |push_token|
        # iOS
        # if push_token.user_device_type_id == 1
        #   n = Rpush::Apns::Notification.new
        #   n.app = Rpush::Apnsp8::App.find_by_name(push_token.user_device_type.title)
        #   n.device_token = push_token.token # 64-character hex string
        #   n.alert = message
        #   puts n
        #   # n.data = { foo: :bar }
        #   n.save!
        # end

        if push_token.user_device_type_id == 2 # ios prod
          find_app = Rpush::Apnsp8::App.find_by_name(push_token.user_device_type.title)
          if find_app
            n = Rpush::Apns::Notification.new
            n.app = find_app
            n.device_token = push_token.token # 64-character hex string
            n.alert = message
            puts n
            # n.data = { foo: :bar }
            n.save!
          else
            # error email
            ceo = Role.find_by_id(9).role_full_users[0]
            error_message = "#{push_token.id} for #{user.user_id} tried to push to an app with the id of #{push_token.user_device_type_id}"
            EmailWorker.perform_async ceo.email, 'Attempted to send push to invalid app', error_message
          end
        elsif push_token.user_device_type_id == 3 # android
          n = Rpush::Gcm::Notification.new
          n.app = Rpush::Gcm::App.find_by_name(push_token.user_device_type.title)
          n.registration_ids = [push_token.token]
          n.data = { message: message }
          # n.priority = 'high'        # Optional, can be either 'normal' or 'high'
          # n.content_available = true # Optional
          # Optional notification payload. See the reference below for more keys you can use!
          # n.notification = { body: 'great match!',
          #                   title: 'Portugal vs. Denmark',
          #                   icon: 'myicon'
          #                 }
          n.save!
        else
          # error email
          ceo = Role.find_by_id(9).role_full_users[0]
          error_message = "#{push_token.id} for user id #{user_id.to_i} tried to push to an app with the id of #{push_token.user_device_type_id}"
          EmailWorker.perform_async ceo.email, 'Attempted to send push to invalid app', error_message
        end
      end
    end
  end
end
