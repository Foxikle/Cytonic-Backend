class UserSerializer

  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: @user.id,
      email: @user.email,
      name: @user.name,
      role: @user.role,
      avatar_url: @user.avatar_url,
      muted: @user.muted,
      muted_at: @user.muted_at,
      muted_until: @user.muted_until,
    }
  end
end
