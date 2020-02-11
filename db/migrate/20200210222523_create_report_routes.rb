class CreateReportRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :report_routes, id: :uuid do |t|
      t.text :title
      t.belongs_to :for_role
      t.belongs_to :for_user
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
