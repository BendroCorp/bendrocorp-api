class OauthToken < ApplicationRecord
  belongs_to :user
  belongs_to :oauth_client

  before_create :create_token

  def create_token
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    self.access_token = Digest::SHA256.hexdigest (0...50).map { o[rand(o.length)] }.join
  end

  def client_title
    self.oauth_client.title
  end
end
