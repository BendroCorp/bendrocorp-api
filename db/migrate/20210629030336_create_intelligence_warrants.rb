class CreateIntelligenceWarrants < ActiveRecord::Migration[6.1]
  def change
    create_table :intelligence_warrants, id: :uuid do |t|
      t.belongs_to :intelligence_case, null: false, foreign_key: true, type: :uuid
      t.text :description
      # 'cfb24004-142d-4762-bcc1-6a2ebef2f1ea'
      t.belongs_to :warrant_status,
      null: false,
      foreign_key: { to_table: :field_descriptors },
      type: :uuid,
      default: 'efccc05a-c28d-455a-b4a4-f73334bb5d0a'

      # approval stuff
      t.belongs_to :user, foreign_key: true
      t.belongs_to :approval, foreign_key: true

      t.boolean :closed, default: false
      t.boolean :archived, default: false

      t.timestamps
    end

    # add relevant fields data
    field1 = Field.create({ id: 'cfb24004-142d-4762-bcc1-6a2ebef2f1ea', name: 'Warrant Status' })
    FieldDescriptor.create([{ field: field1, id: 'efccc05a-c28d-455a-b4a4-f73334bb5d0a', title: 'Pending Approval', ordinal: 1 },
      { field: field1, id: 'e0ea84e0-4a8f-4a57-9d76-18ea97b284e9', title: 'Approved', ordinal: 2 },
      { field: field1, id: '5d3837b1-8137-4400-99cb-ac9ca0c8dc2d', title: 'Completed', ordinal: 3 },
      { field: field1, id: '513d9c85-d92d-49c0-804f-47cb091eeb95', title: 'Declined', ordinal: 4 }])
  end
end
