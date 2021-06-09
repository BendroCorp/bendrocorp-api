include Error::WorkerErrorHandler

Sidekiq.default_worker_options = { 'backtrace' => true }
Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new {|ex,ctx_hash| Error::WorkerErrorHandler.handle(ex, ctx_hash) }
  config.redis = { url: (Rails.application.credentials[Rails.env.to_sym][:redis_url] || 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: (Rails.application.credentials[Rails.env.to_sym][:redis_url] || 'redis://localhost:6379/1') }
end
