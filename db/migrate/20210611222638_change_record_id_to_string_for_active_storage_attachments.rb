class ChangeRecordIdToStringForActiveStorageAttachments < ActiveRecord::Migration[6.1]
  def change
    change_column :active_storage_attachments, :record_id, :string
  end
end
