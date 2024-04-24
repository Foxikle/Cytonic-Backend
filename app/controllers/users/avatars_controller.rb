class Users::AvatarsController < ApplicationController
  def set_avatar
    user = User.find(current_user.id)

    # if user.avatar.attached?
    #   user.avatar.purge
    # end

    user.avatar.attach(params[:avatar])

    url = rails_blob_path(user.avatar, disposition: "attachment")
    puts url
    user.update(avatar_url: 'http://localhost:3000' + url)
    render json: {
      message: 'Successfully set ' + user.name + '\'s avatar.',
      data: rails_blob_path(user.avatar, disposition: "attachment")
    }, status: :ok
  end

  def remove_avatar
    user = User.find(current_user.id)
    if user.avatar.attached?
      user.avatar.purge
      render json: { message: 'Successfully removed ' + user.name + '\'s avatar.' }, status: :ok
    else
      render json: { message: user.name + 'does not have an avatar to remove.' }, status: :unprocessable_entity
    end

  end

end