class SiteLog < ApplicationRecord
  after_create { ActionCable.server.broadcast("log", self.id) }
  belongs_to :site_log_type
end
