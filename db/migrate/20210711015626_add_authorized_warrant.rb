class AddAuthorizedWarrant < ActiveRecord::Migration[6.1]
  def change
    #
    FieldDescriptor.create({id: '40fd968d-2a47-4b99-99e8-e100007cd440', field_id: '042e341b-7043-4d03-8c87-ecd76a0530ee', title: 'Authorized Warrant', ordinal: 99})
  end
end
