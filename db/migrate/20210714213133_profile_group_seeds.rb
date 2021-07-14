class ProfileGroupSeeds < ActiveRecord::Migration[6.1]
  def change
    field1 = Field.create({id: '', title: 'Profile Slot Status'})

    FieldDescriptor.create([{ field: field1, id: '', title: 'Draft' },
                            { field: field1, id: '', title: 'Open' },
                            { field: field1, id: '', title: 'Filled' },
                            { field: field1, id: '', title: 'Pending' }])
  end
end
