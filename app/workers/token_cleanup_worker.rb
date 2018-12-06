class TokenCleanupWorker
  include Sidekiq::Worker

  def perform(*args)
    @tokens = UserToken.where('expires < ?', Time.now)
    puts "#{UserToken.all.count} total user token(s). #{@tokens.count} expired tokens - cleaning up #{@tokens.count}"
    @tokens.destroy_all
    puts "#{UserToken.all.count} token(s) after cleanup"
  end
end
