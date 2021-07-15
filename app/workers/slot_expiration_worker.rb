class SlotExpirationWorker
  include Sidekiq::Worker

  def perform(*args)
    ProfileGroupSlots.where(archived: false).where.not(character_id: nil).each do |slot|
      # check character attendance ratio
      # TODO: Figure out math for this

      # if under attendance level give first warning via email and push
      # then second warning via email and push
      # then boot via email and push
    end
  end
end
