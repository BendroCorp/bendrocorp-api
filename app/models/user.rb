class User < ActiveRecord::Base
  # Two Factor Information - https://moocode.com/posts/3-using-the-google-authenticator-app-with-rails
  before_save { self.email = email.downcase }
  before_create { self.user_setting = UserSetting.new }
  before_create { self.user_information = UserInformation.new }
  #validates :username, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true, length: { minimum:5, maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password # cause we like secure things. :)
  has_many :user_tokens
  has_many :user_push_tokens, -> { where active: true }

  has_one :user_setting
  belongs_to :user_account_type
  has_one :user_information
  accepts_nested_attributes_for :user_information

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

  #requests
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

  def isinrole (roleid)
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

  # TODO: Current this only goes a few layers deep. This needs to walk the entire depth
  def get_all_roles
    # orig - one layer deep
    # all_roles = []
    # non_nested_roles = []
    # nested_roles = []
    # self.roles.each do |role|
    #   non_nested_roles << { :id => role.id, :name => role.name }
    #   role.nested_roles.each do |nested|
    #     nested_roles << { :id => nested.role_nested.id, :name => nested.role_nested.name + " (Nested in #{role.name})"} #role_nested
    #   end
    # end
    #
    # all_roles.push(*non_nested_roles)
    # all_roles.push(*nested_roles)
    #
    # all_roles

    #fetch the base roll and nested roles four deep
    roles = []
    self.roles.each do |role|
      roles << { :id => role.id, :name => role.name }
      role.nested_roles.each do |n_one|
        roles << { :id => n_one.role_nested.id, :name => "#{n_one.role_nested.name} (Nested in #{role.name})" }
        n_one.role_nested.nested_roles.each do |n_two|
          roles << { :id => n_two.role_nested.id, :name => "#{n_two.role_nested.name} (Nested in #{n_one.role_nested.name})" }
          n_two.role_nested.nested_roles.each do |n_three|
            roles << { :id => n_three.role_nested.id, :name => "#{n_three.role_nested.name} (Nested in #{n_two.role_nested.name})" }
            n_three.role_nested.nested_roles.each do |n_four|
              roles << { :id => n_four.role_nested.id, :name => "#{n_four.role_nested.name} (Nested in #{n_three.role_nested.name})" }
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
      self.main_character.avatar.url(:original)
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

  def points_count
    #c = 0
    #self.point_transactions.each do |trans|
    #  c += trans.amount
    #end
    #return c
    self.point_transactions.sum(:amount)
  end

  def lifetime_points
    positiveSum = 0
    self.point_transactions.each do |trans|
      if trans.amount >= 0 # if the sum is a positive number
        positiveSum += trans.amount
      end
    end
    positiveSum
  end

  def current_cart
    cartsCheck = self.carts.where('order_id IS NULL')
    if cartsCheck.count == 1
      cartsCheck.first
    elsif cartsCheck.count == 0
      newCart = StoreCart.create
      self.carts << newCart
      newCart
    else
      raise 'Current user has more than one active cart. This should not be the case.'
    end
  end

  # End of model
end
