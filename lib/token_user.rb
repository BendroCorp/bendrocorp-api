class TokenUser

  def initialize user_hash
    @id = user_hash['sub']
    @email = user_hash['email']
    @roles = user_hash['roles']
    @username = user_hash['name']
  end

  def id
    @id
  end

  def username
    @username
  end

  def email
    @email
  end

  def roles
    @roles
  end

  def isinrole role_id
    is_in_role role_id
  end

  def is_in_role role_id
    if role_id != nil
      # check the token
      roles.each do |role|
        return true if role == role_id.to_i || role == -1
      end

      # check the database users roll - in case roles are added after a token is rolled
      return true if !db_user.nil? && db_user.isinrole(role_id)

      # we have not found the role - :(
      return false
    else
      raise 'Provided role_id is null' # This should never be null
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

  def db_user
    u = User.find_by_id @id
    if u
      u
    else
      # TODO: Bots won't have DB users...need to come up with a better method for this
      # raise 'Database user not found for token!'
    end
  end

  def main_character
    db_user.main_character
  end

  def main_character_full_name
    if main_character != nil
      main_character.full_name
    end
  end

  def main_character_avatar_url
    if main_character != nil
      main_character.avatar.url(:original)
    end
  end

  def main_character_job_title
    if main_character != nil
      main_character.current_job_title
    end
  end
end
