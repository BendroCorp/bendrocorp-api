class FieldValueController < ApplicationController
  before_action :require_user
  before_action :require_member # there could be exceptions to this

  # TODO: We need to find a way to get owner security and object level security

  # patch api/field-value
  # { master_id: uuid, field_id: uuid, value: any }[]
  def patch
    @value_sets = params[:value_sets]

    # if the value set param is filled
    if @value_sets
      begin
        raise 'You must provide an array' unless value_set.kind_of?(Array)

        # Makes sure that all of the updates/changes happen
        FieldValue.transaction do 
          value_set.each do |val|
            # updates will just contain an id, field_id and value
            # shortest path

            # update
            if val[:id]
              update_value = FieldValue.find_by_id(field_id: val[:id])
              raise 'Value not found. Cannot update' if val[:value].nil?
              update_value.value = val[:value]
              update_value.save!
            else # create or multival
              # multi_value_allowed
              # fetch the field
              create_field = Field.find(id: val[:field_id])
              raise "Field not found! #{val[:field_id]}. Cannot create field." if create_field.nil?

              # to if multivalue allowed
              if !create_field.multi_value_allowed && field_values.where(field_id: val[:field_id]).count > 0
                raise 'Multi value not allowed for this field'
              end

              if val[:field_id].nil? || val[:master_id].nil? || val[:value].nil?
                raise 'Invalid create object for field value'
              end

              # create the new value
              create_value = FieldValue.new(master_id: val[:master_id], field_id: val[:field_id], value: val[:value])
              create_value.save!
            end
          end # end value set loop
        end # end transaction
      rescue => e
        render status: 500, json: { message: e.message.to_s }
      end

      render json: { message: 'Field values patched!' }
    else # checking the basic request is populated properly
      render status: 400, json: { message: 'Request not properly formed' }
    end
  end

  # delete api/field-value/:id
  def delete
    delete_value = FieldValue.find_by_id(field_id: params[:id])

    if delete_value
      delete_value.destroy
      render json: { message: 'Value entry deleted!' }
    else
      render status: :not_found, json: { message: 'Field value not found!' }
    end
  end
end
