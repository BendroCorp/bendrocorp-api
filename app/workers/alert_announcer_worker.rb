class AlertAnnouncerWorker
  include Sidekiq::Worker

  def perform()
    Alert.where(published: false, approved: true, archived: false).each do |alert_item|
      # set push message
      push_message =
        if alert_item.alert_type_id == 'b750318c-57ae-4801-bbef-9848c6e02880' && !alert_item.user.nil? # is CSAR
          "CSAR: #{alert_item.user.main_character.full_name} is requesting rescue from #{alert_item.star_object.title}!"
        else
          "A new #{alert_item.alert_type} has been posted!"
        end

      # for now it goes to all users
      Role.find_by_id(0).role_full_users.each do |user|
        PushWorker.perform_async(
          user.id,
          push_message,
          'ALERT_NOTICE',
          { alert: alert_item.id }
        )
      end

      # mark the item as published and save
      alert_item.published = true
      alert_item.save
    end
  end
end
