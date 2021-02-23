class AlertAnnouncerWorker
  include Sidekiq::Worker

  def perform()
    Alert.where(published: false, approved: true, archived: false).each do |alert|
      # set push message
      push_message =
        if alert.alert_type_id == 'b750318c-57ae-4801-bbef-9848c6e02880' # is CSAR
          "CSAR: #{alert.user.main_character.full_name} is requesting rescue from #{alert.star_object.title}!"
        else
          "A new #{alert.alert_type} has been posted!"
        end

      PushWorker.perform_async(
        user.id,
        push_message,
        'ALERT_NOTICE',
        { alert: alert.id }
      )

      alert.published = true
      alert.save!
    end
  end
end
