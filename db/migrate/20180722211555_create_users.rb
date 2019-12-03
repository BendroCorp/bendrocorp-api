class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text :username
      t.text :email
      t.text :password_digest
      t.text :auth_secret #for two factor
      t.boolean :use_two_factor, default:false
      t.integer :login_attempts, default:0
      t.boolean :locked, default: false #because of password retries
      t.boolean :login_allowed, default: true #administrative lockout
      t.text :verification_string
      t.boolean :email_verified, default: false
      t.text :password_reset_token
      t.boolean :password_reset_requested, default: false
      t.references :user_account_type, default: 1 #membership, diplomatic, customer (TBA)
      t.text :rsi_handle
      t.text :state
      t.text :country

      t.text :auth_token

      t.boolean :is_member, default: false
      t.boolean :is_admin, default: false
      t.boolean :is_subscriber, default: false
      t.text :subscriber_account_id
      t.text :subscriber_subscription_id
      t.boolean :is_online, default: false
      t.boolean :removal_warned, default: false
      t.boolean :discord_link_required, default: true
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
