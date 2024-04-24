module Role
  OWNER = 'owner'
  ADMIN = 'admin'
  MODERATOR = 'moderator'
  HELPER = 'helper'
  USER = 'user'

  def self.all
    [OWNER, ADMIN, MODERATOR, HELPER, USER]
  end

  def self.value_of(str)
    case str
    when OWNER
      OWNER
    when ADMIN
      ADMIN
    when MODERATOR
      MODERATOR
    when HELPER
      HELPER
    when USER
      USER
    else
      USER
    end
  end

  def self.power_over(str)
    case str
    when OWNER
      [ADMIN, MODERATOR, HELPER, USER]
    when ADMIN
      [MODERATOR, HELPER, USER]
    when MODERATOR
      [HELPER, USER]
    when HELPER
      [USER]
    when USER
      []
    else
      []
    end
  end


end
