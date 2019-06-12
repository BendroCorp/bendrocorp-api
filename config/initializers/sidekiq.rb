include Error::WorkerErrorHandler

Sidekiq.default_worker_options = { 'backtrace' => true }
Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new {|ex,ctx_hash| Error::WorkerErrorHandler.handle(ex, ctx_hash) }
end
