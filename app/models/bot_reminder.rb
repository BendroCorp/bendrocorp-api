class BotReminder < ApplicationRecord
    belongs_to :bot
    belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

    def is_expired
        t.expires < Time.now
    end
end
