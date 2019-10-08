class Bot < ApplicationRecord
  validates :bot_name, presence: true
end
