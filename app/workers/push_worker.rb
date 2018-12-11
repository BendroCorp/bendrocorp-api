class PushWorker
  include Sidekiq::Worker

  def perform(user_id, message)
    user = User.find_by_id(user_id.to_i)
    if user
      user.user_push_tokens.each do |push_token|
        # iOS
        if push_token.user_device_type_id == 1
          n = Rpush::Apns::Notification.new
          n.app = Rpush::Apnsp8::App.find_by_name(push_token.user_device_type.title)
          n.device_token = push_token.token # 64-character hex string
          n.alert = message
          puts n
          # n.data = { foo: :bar }
          n.save!
        end
      end
    end
  end
end
