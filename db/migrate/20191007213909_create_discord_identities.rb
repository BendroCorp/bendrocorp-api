class CreateDiscordIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :discord_identities, id: :uuid do |t|
      t.text :discord_username
      t.text :discord_id
      t.text :refresh_token
      t.boolean :joined, default: false
      t.belongs_to :user
      t.timestamps
    end
  end
end
