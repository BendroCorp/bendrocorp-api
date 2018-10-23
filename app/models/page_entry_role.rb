class PageEntryRole < ApplicationRecord
  belongs_to :role
  belongs_to :page
end
