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
        raise 'You must provide an array' unless @value_sets.kind_of?(Array)

        # Makes sure that all of the updates/changes happen
        FieldValue.transaction do
          @value_sets.each do |val|
            # updates will just contain an id, field_id and value
            # shortest path

            # update
            if !val[:id].nil?
              # TODO: Do we care...or do we just create the value instead?? (if everything else is right)
              update_value = FieldValue.find_by_id(field_id: val[:id])
              # raise 'Value not found. Cannot update' if val[:value].nil?
              raise 'Could not find field_value not found even though ID was present!' if update_value.nil?

              # security check
              if !update_value.master.update_role_id.nil? || !current_user.is_in_role(update_value.master.update_role_id)
                raise "Current user is not allowed to edit master id #{update_value.master.id}"
              end

              update_value.value = val[:value]
              update_value.save!
            else # create or multival
              # make sure the master id exists
              master = MasterId.find_by_id(val[:master_id])
              raise "Master id #{val[:master_id]} does not exist!" if master.nil?

              # security check
              raise "Current user is not allowed to edit master id #{master.id}" if !current_user.is_in_role(update_value.master.update_role_id)

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
        render status: 500, json: { message: e.message.to_s, debug: e.backtrace.join("\n") }
        return
      end

      render json: { message: 'Field values patched!' }
      return
    else # checking the basic request is populated properly
      render status: 400, json: { message: 'Request not properly formed' }
      return
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
