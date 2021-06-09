class MigratePaperclipToActiveStorage < ActiveRecord::Migration[6.1]
  def change
    puts 'Attempting to migrate old images'
    puts "Current env is #{ENV["RAILS_ENV"]}"
    # Migrate profiles
    icount = 0
    Character.all.each do |character|
      uri = character.paperclip_original_uri
      # uri = 'https://decider.com/wp-content/uploads/2020/12/the-mandalorian-14-boba-fett-headshot.jpg?quality=80&strip=all&w=1200'
      puts uri
      # not the right URI: /system/characters/avatars/000/000/001/original/rindzer.png >://
      next if uri.nil? && !uri.include?("missing") || character.avatar.attached?
      # https://github.com/janko/image_processing/blob/master/doc/minimagick.md#resize_to_fill
      # actually make the move
      icount += 1

      pipeline = ImageProcessing::MiniMagick.source(uri)
      resized_image = pipeline.convert('png').resize_to_fill!(200, 200)

      image_blob = ActiveStorage::Blob.create_after_upload!(
        io: File.open(resized_image.path), # resized_image.path
        filename: "#{character.id}.png",
        content_type: 'image/png'
      )

      character.avatar.attach(image_blob)
      character.save

      # queue image sizer jobs as required
      # ImageSizerJob.perform_later(character, 'avatar', { resize: '100x100^', quality: '100%' })
    end

    puts "Migrated #{icount} character avatars"

    # Migrate system map images
    icount = 0
    SystemMapImage.all.each do |image|
      uri = image.paperclip_original_uri

      next if uri.nil? && !uri.include?("missing") || image.image.attached?

      # create and perform a base resize on the image
      icount += 1

      pipeline = ImageProcessing::MiniMagick.source(uri)
      resized_image = pipeline.convert('png').resize_to_fit!(1920, 1080)

      # transform the data into the ActiveStorage blob
      image_blob = ActiveStorage::Blob.create_after_upload!(
        io: File.open(resized_image.path), #resized_image.path
        filename: "#{image.id}.png",
        content_type: 'image/png'
      )

      image.image.attach(image_blob)
      image.save
    end

    puts "Migrated #{icount} system images"

    # migrate image uploads
    icount = 0
    ImageUpload.all.each do |image|
      uri = image.paperclip_original_uri

      next if uri.nil? || uri.include?("missing") || image.image.attached?

      # create and perform a base resize on the image
      icount += 1
      pipeline = ImageProcessing::MiniMagick.source(uri)
      resized_image = pipeline.convert('png').resize_to_fit!(1920, 1080)

      # transform the data into the ActiveStorage blob
      image_blob = ActiveStorage::Blob.create_after_upload!(
        io: File.open(resized_image.path), #resized_image.path
        filename: "#{image.id}.png",
        content_type: 'image/png'
      )

      image.image.attach(image_blob)
      image.save
    end

    puts "Migrated #{icount} image uploads"
  end
end
