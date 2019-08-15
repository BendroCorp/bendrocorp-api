module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    # https://guides.rubyonrails.org/action_cable_overview.html#connection-setup
    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        decoded_token = JWT.decode request.params[:token], secret, true, { algorithm: 'HS256' }
        verified_user = TokenUser.new(decoded_token[0])
        if verified_user
          puts "Registered #{verified_user.user.username}"
          verified_user.db_user
          # TODO: Need to do more here. We should identify by session not user
        else
          # If we don't know who you are you cannot log on
          reject_unauthorized_connection
        end
      end
  end
end
