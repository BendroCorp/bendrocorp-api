class CreateDiscordIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :discord_identities, id: :uuid do |t|
      t.text :discord_id
      t.text :discord_snowflake_id
      t.text :refresh_token
      t.belongs_to :user
      t.timestamps
    end
  end
end
