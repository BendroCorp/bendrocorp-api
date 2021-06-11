class ChangeRecordIdToStringForActiveStorageAttachments < ActiveRecord::Migration[6.1]
  def change
    # The why? https://discuss.rubyonrails.org/t/uuid-primary-keys-still-byte/75060/9
    change_column :active_storage_attachments, :record_id, :text
  end
end
