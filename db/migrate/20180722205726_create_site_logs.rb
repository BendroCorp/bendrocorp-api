class CreateSiteLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :site_logs do |t|
      t.text :module
      t.text :submodule
      t.text :message
      t.references :site_log_type
      t.timestamps
    end
  end
end
