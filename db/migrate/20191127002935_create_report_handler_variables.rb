class CreateReportHandlerVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :report_handler_variables, id: :uuid do |t|
      t.belongs_to :handler
      t.text :name
      t.text :object_name
      t.timestamps
    end
  end
end
