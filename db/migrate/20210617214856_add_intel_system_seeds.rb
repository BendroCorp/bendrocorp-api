class AddIntelSystemSeeds < ActiveRecord::Migration[6.1]
  def change
    Role.create([{ id: 53, name: 'BenSec System Reader', description: 'Allow read access to the intel system' },
                { id: 54, name: 'BenSec System Writer', description: 'Allow read access to the intel system. The role also includes the reader role as a nested role' },
                { id: 55, name: 'BenSec System Admin', description: 'Admins can archive reports' }])

    MenuItem.where(id: 10).destroy_all # get rid of the old offender reports link

    MenuItem.create({ id: 25, title: 'BendroSAFE', ordinal: 10, link: '/bendro-safe', icon: 'search'})
    MenuItem.create({ id: 26, title: 'BenSEC', ordinal: 11, link: '/ben-sec', icon: 'journal'})

    MenuItemRole.create({ menu_item_id: 26, role_id: 53 })

    NestedRole.create([{ role_id: 54, role_nested_id: 53 }, { role_id: 55, role_nested_id: 54 }]) # the reader role gives you access to the system

    # NOTE: This line will not be run properly locally, seeds runs *after* this does
    # NestedRole.create([{ role_id: 2, role_nested_id: 55 }, { role_id: 3, role_nested_id: 54 }, { role_id: 5, role_nested_id: 54 }])
    NestedRole.create([{ role_id: 2, role_nested_id: 55 }, # execs
                       { role_id: 3, role_nested_id: 54 }, # directors
                       { role_id: 5, role_nested_id: 54 }]) # security

    field1 = Field.create({ id: '30d7b3b6-4c61-4b9b-b659-632a220e6558', name: 'Offender Rating' })

    FieldDescriptor.create([{ id: 'cfa4b341-dc8d-498d-b68f-3db2482ce66c', field: field1, title: 'No Threat', description: 'No threat', ordinal: 1 },
                            { id: '48d96ad1-8380-4dc9-89a0-559f31ad798c', field: field1, title: 'Nuisance', description: 'Through recklessness created dangerous situations around and/or through such actions damaged BendroCorp property.', ordinal: 2 },
                            { id: '3b6db308-b6fb-48fe-8a27-1e822fb20420', field: field1, title: 'Dangerous', description: 'Fired directly on a ship and/or person but did not attempt to destroy/kill. Should be approached with caution.', ordinal: 3 },
                            { id: '2fb45779-4486-4fdd-a35a-cf142b54b754', field: field1, title: 'Lethal Threat', description: 'Intended to destroy/disable/kill a ship and/or person(s) or has attempted to seize mercantile cargo or corporate equipment by force. Should be approached with extreme caution.', ordinal: 4 }])

    field2 = Field.create({ id: '8b9a2eeb-bcf3-4113-9e47-1e1868319917', name: 'BenSec Filter Types' })

    FieldDescriptor.create([{ id: '5fe96a97-f186-45ed-8c68-d859e26e0741', field: field2, title: 'Incidents', description: 'A report in which an offender attempted harm against en employee or affiliate.', ordinal: 1 },
                            { id: '47ecc588-cf98-49e6-995a-491e5629421f', field: field2, title: 'Cases', description: 'An investigatory case.', ordinal: 2 }])

    field3 = Field.create({ id: '042e341b-7043-4d03-8c87-ecd76a0530ee', name: 'Incident Report Citables'})

    FieldDescriptor.create([{ field: field3, id: '795dc77f-6733-4f62-8139-c3c71502391c', title: 'Theft', ordinal: 1 },
                            { field: field3, id: '6de626ef-be69-48cf-813d-a53e749985c5', title: 'Piracy', ordinal: 2 },
                            { field: field3, id: '32ee4306-59e9-4ed9-9087-bf738c01d444', title: 'Trespass', ordinal: 3 },
                            { field: field3, id: 'e61ccd43-e53a-44b1-9a71-2cd055114135', title: 'Nuisance', ordinal: 4 },
                            { field: field3, id: '48df5fbe-796b-4e34-b53b-d02028eb6181', title: 'Endangermeant', ordinal: 5 },
                            { field: field3, id: 'cf3f584d-14aa-4bb6-993b-101af3b15584', title: 'Destruction', ordinal: 6 },
                            { field: field3, id: '78bf7511-671e-4c9c-8f06-98e9198cd802', title: 'Manslaughter', ordinal: 7 },
                            { field: field3, id: 'fe9e729d-3352-4372-90e1-f8b5893eb2f7', title: 'Attempted Murder', ordinal: 8 },
                            { field: field3, id: '637a1599-d94c-4298-b128-ccea853bb3bf', title: 'Murder', ordinal: 9 }])

    fdc1 = FieldDescriptorClass.create({id: '74b24b2c-4cd5-42e4-8380-a49e1f75aca5', title: 'Classification Levels', class_name: 'ClassificationLevel', class_field: 'title'})
    Field.create({id: '6ff87667-f29f-4480-a279-0a4b5e849ed2', name: 'Classification Levels', field_descriptor_class: fdc1 })

    fdc2 = FieldDescriptorClass.create({id: '42593bc4-768a-4b0a-b2d9-5645bee10231', title: 'Ships', class_name: 'Ship', class_field: 'full_title'})
    Field.create({id: '0b7f5349-dafa-47aa-837b-8a8ba248d9a5', name: 'Ships', field_descriptor_class: fdc2 })

    field4 = Field.create({ id: 'b2326f45-0701-4b85-806c-91408bfcd5d5', name: 'Approval Status'})
    FieldDescriptor.create([{ id: 'a067e0d6-018e-4afc-87c9-6c486c512a76', field: field4, title: 'Not Submitted', description: 'An approvable which is not submitted.', ordinal: -2 },
      { id: 'd593a55f-86fd-4cfa-88ce-1b8e38737c8c', field: field4, title: 'Pending Review', description: 'An approval which is still pending review by a Security Officer.', ordinal: -1 },
      { id: 'f4619ce3-2d7e-41cd-9286-7f889e8f17b6', field: field4, title: 'Approved', description: 'Approved', ordinal: 1 },
      { id: 'd9bbda83-e290-4b0c-88ff-1e15ab674640', field: field4, title: 'Declined', description: 'Declined', ordinal: 2 }])
  end
end
