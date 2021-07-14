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

      PushWorker.perform_async(
        user.id,
        push_message,
        'ALERT_NOTICE',
        { alert: alert_item.id }
      )

      alert_item.published = true
      alert_item.save
    end
  end
end
