class AddHackingInfraction < ActiveRecord::Migration[6.1]
  def change
    FieldDescriptor.create({id: '81fed920-99f4-44c6-8228-fb12d63c2f71', field_id: '042e341b-7043-4d03-8c87-ecd76a0530ee', title: 'Network Intrusion (Hacking)', ordinal: 99})
  end
end
