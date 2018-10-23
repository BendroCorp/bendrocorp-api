class CreateOauthClients < ActiveRecord::Migration[5.1]
  def change
    create_table :oauth_clients do |t|
      t.text :title
      t.text :client_id
      t.text :logo
      t.timestamps
    end
  end
end
