class CreateOauthTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :oauth_tokens do |t|
      t.belongs_to :user
      t.belongs_to :oauth_client
      t.text :access_token
      t.text :refresh_token
      t.datetime :expires
      t.text :type # implicit, code
      t.timestamps
    end
  end
end
