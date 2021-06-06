class StoreItem < ApplicationRecord
  belongs_to :currency_type, :class_name => 'StoreCurrencyType', :foreign_key => 'currency_type_id'
  belongs_to :category, :class_name => 'StoreItemCategory', :foreign_key => 'category_id'

  validates :creator_id, presence: true
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id', optional: true
  belongs_to :last_updated_by, :class_name => 'User', :foreign_key => 'last_updated_by_id'

  # has_attached_file :image, :styles => { :small => "50x50#", :thumbnail => "150x150#", :big => "300x300#", :original => "500x500#" },
  #                   #content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] },
  #                   #:url  => "/assets/avatars/:id/:style/:basename.:extension",
  #                   #:url  => "/bendrocorp/#{Rails.env}/character/:id/:style/:basename.:extension",
  #                   #:path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension",
  #                   :path => "/bendrocorp/#{Rails.env}/store_items/:id/:style/:basename.:extension",
  #                   :default_url => "https://my.bendrocorp.com/img/avatars/missing_store_image_:style.png"
  #                   # my.bendrocorp.com

	# validates_attachment 	:image,
	# 			:content_type => { :content_type => /\Aimage\/.*\Z/ },
	# 			:size => { :less_than => 5.megabyte }

  has_one_attached :image

  def quantity_sold
    total_quantity_sold = 0
    @orders = StoreOrder.where('status_id NOT IN (?) ', [5]) #Open, Processing, Shipped|Fulfilled
    @orders.each do |order|
      if order.cart.items.count > 0
        order.cart.items.where('item_id = ?', self.id).each do |item_in_order|
          total_quantity_sold += item_in_order.quantity
        end
      end
    end
    total_quantity_sold
  end

  def quantity_available
    self.base_stock - self.quantity_sold
  end

  def original_image
    # self.image.url(:original)
    # rails_blob_path(image, only_path: true) if image.attached?
    image.processed.url.sub(/\?.*/, '') if image.attached?
  end

  def thumbnail_image
    # self.image.url(:thumbnail)
    # rails_blob_path(image.sized(:thumbnail), only_path: true) if image.attached?
    image.variant({ resize: '100x100^', quality: '100%' }).processed.url.sub(/\?.*/, '') if image.attached?
  end
end
