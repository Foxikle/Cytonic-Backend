class SafeUserSerializer

  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: @user.id,
      name: @user.name,
      role: @user.role,
      avatar_url: @user.avatar_url
    }
  end
end
