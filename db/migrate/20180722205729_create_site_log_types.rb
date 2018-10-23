class CreateSiteLogTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :site_log_types do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
