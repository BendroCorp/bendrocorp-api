class EnableExtensions < ActiveRecord::Migration[5.1]
  def change
    env = ENV["RAILS_ENV"]
    if !env || env == 'development' || env == 'production'
      enable_extension 'uuid-ossp'
      enable_extension 'pgcrypto'
    end
  end
end