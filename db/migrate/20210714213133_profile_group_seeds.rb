class ProfileGroupSeeds < ActiveRecord::Migration[6.1]
  def change
    field1 = Field.create({id: '46c547a0-e616-4c8e-b4c9-359981ae10d2', title: 'Profile Slot Status'})

    FieldDescriptor.create([{ field: field1, id: 'c68e5642-79cf-435f-964d-8460d9c4a895', title: 'Draft', ordinal: 1 },
                            { field: field1, id: '63d4797d-85b4-41b9-b20c-75cad3b0ecfa', title: 'Open', ordinal: 2 },
                            { field: field1, id: 'f66ddac3-fd43-4ed8-b54f-fc5048575754', title: 'Closed', ordinal: 3 },
                            { field: field1, id: '5386404a-484b-4793-ac8c-5a4fadac172c', title: 'Filled', ordinal: -1 },
                            { field: field1, id: '9c84e621-470c-4a1c-9fbf-70c82f4ce5e2', title: 'Pending', ordinal: -2 }]) # a

    Role.create([{ id: 56, name: 'Profile Group Editor', description: 'Can preform basic changes to profile groups' },
                { id: 57, name: 'Profile Group Admin', description: 'Can preform advanced changes to profile groups including archiving groups and removing members from slots' }])

    # nest editor under admin
    NestedRole.create([{ role_id: 57, role_nested_id: 56 }])

    # tie to user roles
    # this line will not run properly locally since seeds runs after - run this after running typical mig and seed
    # execs as editors, CEO as admin
    NestedRole.create([{ role_id: 2, role_nested_id: 56 }, { role_id: 9, role_nested_id: 57 }])
  end
end
