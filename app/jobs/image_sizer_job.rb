class ImageSizerJob < ApplicationJob
  queue_as :default

  def perform(object, attached_field_name, options)
    # Derived from:
    # https://stackoverflow.com/questions/51032815/activestorage-thumbnail-persistence
    # and
    # https://tech.kartenmacherei.de/scaling-activestorage-21e962f708d7
    # and
    # http://www.carlosramireziii.com/what-options-can-be-passed-to-the-active-storage-variant-method.html

    # Options example:
    # {
    #   resize: '800X800^', # thumbnail
    #   extent: '800x800',  # sets the image to a fixed size
    #   gravity: 'center',  # works from the center of the image
    #   auto_orient: true,
    #   quality: '100%'
    # }

    return unless object.send(attached_field_name).attached?

    variant = object.send(attached_field_name).variant(options)

    # This is what triggers the actual transform/cache process
    was_processed = variant.processed unless variant.nil?

    # save the base object
    if was_processed
      if object.save
        # logging message
        Rails.logger.info "Processed variant for #{object.id}"
      else
        Rails.logger.error 'Uh oh couldn\'t save...'
      end
    end
  end
end
