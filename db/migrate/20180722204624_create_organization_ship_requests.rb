class CreateOrganizationShipRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_ship_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :owned_ship
      t.belongs_to :approval #required field/fk

      t.belongs_to :division, index: true

      t.text :procedures_document_web_link
      t.timestamps
    end
  end
end
