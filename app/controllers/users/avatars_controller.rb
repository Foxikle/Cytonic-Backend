class Users::AvatarsController < ApplicationController
  def set_avatar
    unless current_user
      render json: { message: 'You must be logged in!' }, status: :unauthorized
      return
    end
    user = User.find(current_user.id)

    # if user.avatar.attached?
    #   user.avatar.purge
    # end

    user.avatar.attach(params[:avatar])

    if user.avatar.attached?
      puts 'Success!'
    else
      render json: {message: "An error occourred whilst saving your new profile picture"}, status: :unprocessable_entity
    end

    url = rails_blob_path(user.avatar, disposition: "attachment")
    user.update(avatar_url: 'https://api.cytonic.net' + url)
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