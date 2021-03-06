class User < ActiveRecord::Base
  # Two Factor Information - https://moocode.com/posts/3-using-the-google-authenticator-app-with-rails
  before_save { self.email = email.downcase }
  before_create { self.user_setting = UserSetting.new }
  before_create { self.user_information = UserInformation.new }
  # validates :username, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_.-]*\z/i
  validates :username, presence: true, length: { minimum:5, maximum: 30 },
                    format: { with: VALID_USERNAME_REGEX }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password # cause we like secure things. :)
  has_many :user_tokens
  has_many :user_push_tokens, -> { where active: true }
  has_many :user_sessions

  has_one :user_setting
  belongs_to :user_account_type
  has_one :user_information
  accepts_nested_attributes_for :user_information

  has_one :discord_identity
  accepts_nested_attributes_for :discord_identity

  has_many :characters
  has_many :in_roles
  has_many :roles, through: :in_roles
  # has_many :in_conversations
  # has_many :conversations, through: :in_conversations
  # has_many :messages
  # has_many :chats
  #http://millarian.com/rails/precision-and-scale-for-ruby-on-rails-migrations/
  has_many :point_transactions

  has_many :approval_approvers

  # requests
  has_many :role_requests
  has_many :role_removal_requests
  has_many :organization_ship_requests
  has_many :owned_ship_crew_requests
  has_many :award_requests

  has_many :carts, :class_name => 'StoreCart', :foreign_key => 'user_id'

  # Make sure everyone has an auth secret
  before_validation :assign_auth_secret, :on => :create

  #
  has_many :member_badges
  has_many :badges, through: :member_badges

  accepts_nested_attributes_for :characters
  accepts_nested_attributes_for :point_transactions
  accepts_nested_attributes_for :carts

  def appear
    self.is_online = true
    self.save!
  end

  def disappear
    self.is_online = false
    self.save!
  end

  def get_token
    if self.auth_token != nil
      return self.auth_token
    else
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      self.auth_token = Digest::SHA256.hexdigest (0...50).map { o[rand(o.length)] }.join
      self.save
      return self.auth_token
    end
  end

  def two_factor_valid code
    return true if code.to_s == ROTP::TOTP.new(self.auth_secret).now.to_s
  end

  def assign_auth_secret
    self.auth_secret = ROTP::Base32.random_base32
  end

  # Deprecated do not call directly. Call is_in_role instead
  def isinrole (roleid)
    is_in_role roleid
  end

  def is_in_role roleid
    if roleid != nil
      self.get_all_roles.each do |role|
        return true if role[:id].to_i == roleid.to_i
      end
      return false
    else
      raise 'Provided role id is null' # This should never be null
    end
  end

  def is_in_one_role (role_array)
    if role_array.count > 0
      role_array.each do |role|
        return true if self.isinrole(role)
      end
      return false
    else
      return false
    end
  end

  def get_all_roles
    # this needs to look all the way and be as performant
    # fetch the base roll and nested roles four deep.. this needs to eventually go deeper
    roles = []
    self.roles.each do |role|
      roles << { id:role.id, name: role.name, discord_role_id: role.discord_role_id }
      role.nested_roles.each do |n_one|
        roles << { id: n_one.role_nested.id, name: "#{n_one.role_nested.name} (Nested in #{role.name})", discord_role_id: role.discord_role_id }
        n_one.role_nested.nested_roles.each do |n_two|
          roles << { id: n_two.role_nested.id, name: "#{n_two.role_nested.name} (Nested in #{n_one.role_nested.name})", discord_role_id: role.discord_role_id }
          n_two.role_nested.nested_roles.each do |n_three|
            roles << { id: n_three.role_nested.id, name: "#{n_three.role_nested.name} (Nested in #{n_two.role_nested.name})", discord_role_id: role.discord_role_id }
            n_three.role_nested.nested_roles.each do |n_four|
              roles << { id: n_four.role_nested.id, name: "#{n_four.role_nested.name} (Nested in #{n_three.role_nested.name})", discord_role_id: role.discord_role_id }
            end
          end
        end
      end
    end

    # make sure all roles are unique
    roles.uniq! { |r| r[:id] }

    # return roles list
    roles
  end

  def is_subscriber
    !self.subscriber_subscription_id.nil?
  end

  # Alternate method to get all roles
  def claims
    get_all_roles
  end

  def admin?
    self.is_admin
  end

  def member?
    # self.is_member
    self.isinrole(0)
  end

  def main_character
    if self.characters.count > 0
      return self.characters.find_by is_main_character: true
    end
  end

  def main_character_full_name
    if self.main_character != nil
      self.main_character.full_name
    end
  end

  def main_character_avatar_url
    if self.main_character != nil
      self.main_character.avatar_thumbnail_url
    end
  end

  def main_character_job_title
    if self.main_character != nil
      self.main_character.current_job_title
    end
  end

  def approval_summary
    approvalsArr = []
    my_approvals = ApprovalApprover.where('user_id = ? AND approval_type_id < 4', self.id)
    approvalsCount = my_approvals.count

    my_approvals.each do |my_approval|
      on_behalf_of = ""

      my_approval.approval.approval_kind.title
      my_approval.approval.approval_source_requested_item

      if defined?(my_approval.approval.approval_source.on_behalf_of)
        on_behalf_of = my_approval.approval.approval_source.on_behalf_of.full_name
      else
        on_behalf_of = nil
      end

      approvalsArr << { approval_id: my_approval.approval.id, title: my_approval.approval.approval_kind.title, requested_item: my_approval.approval.approval_source_requested_item, requested_by: my_approval.approval.approval_source.user.main_character.full_name, on_behalf_of: on_behalf_of }
    end

    { approvals_count: approvalsCount, outstanding_approvals: approvalsArr }
  end

  def unresponded_events
    count = 0
    events = Event.where('end_date > ?', Time.now)
    events.each do |event|
      if event.attendences.where('user_id = ?', self.id).count == 0
        count += 1
      end
    end
    count
  end

  def unresponded_event_ids
    idArray = []
    events = Event.where('end_date > ?', Time.now)
    events.each do |event|
      if event.attendences.where('user_id = ?', self.id).count == 0
        idArray << event.id
      end
    end
    idArray
  end

  def classification_check classification_id
    # if the id is nil then just return true
    return true if classification_id.nil? || classification_id == 1

    # roles
    # get_all_roles.each do |role|
    #   return true if role.classification_levels.map(&[:id]).include?(classification_id)
    # end
    puts 'test'
    mapped_role_ids = get_all_roles.map do |item|
      item[:id]
    end
    puts mapped_role_ids
    levels_count = ClassificationLevelRole.where(role_id: mapped_role_ids).count

    return true if levels_count > 0

    # if we get to this point, return false
    false
  end

  def points_count
    # c = 0
    # self.point_transactions.each do |trans|
    #  c += trans.amount
    # end
    # return c
    self.point_transactions.sum(:amount)
  end

  def lifetime_points
    positive_sum = 0
    self.point_transactions.each do |trans|
      if trans.amount >= 0 # if the sum is a positive number
        positive_sum += trans.amount
      end
    end
    positive_sum
  end

  def current_cart
    carts_check = self.carts.where('order_id IS NULL')
    if carts_check.count == 1
      carts_check.first
    elsif carts_check.count == 0
      new_cart = StoreCart.create
      self.carts << new_cart
      new_cart
    else
      raise 'Current user has more than one active cart. This should not be the case.'
    end
  end

  def stripe_customer
    # return the subscriber id if its set
    return subscriber_account_id if subscriber_account_id

    # otherwise create a new one
    customer = Stripe::Customer.create({ email: self.email, name: username, metadata: { user_id: id } })
    self.subscriber_account_id = customer.id
    self.save!

    # return the value
    subscriber_account_id
    # Note: The general principle here is not to share an identifier with a third party service unless we really need to
    # but once you start we leave this in for proper referencing
  end

  # End of model
end
