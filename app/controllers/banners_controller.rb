class BannersController < ApplicationController

  # POST /banners
  def create
    if current_user == nil
      render json: { error: 'Unauthorized.'}, status: :unauthorized
      return
    end
    if is_allowed_admin? current_user.role
      banner = Banner.new(
        style: params[:banner][:style],
        title: params[:banner][:title],
        body: params[:banner][:body]
      )

      if banner.save
        render json: { message: 'Successfully created new banner.' }, status: :created
      else
        render json: { error: 'Failed to create banner', errors: banner.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized.'}, status: :unauthorized
    end

  end

  # GET /banners
  def get_banner
    banner = Banner.last
    if banner == nil
      render json: { message: 'There are no banners!', data: {} }, status: :ok
      return
    end
    if banner.style == 'NONE'
      render json: { message: 'No active banner'}, status: :ok
      return
    end
    render json: { message: 'Successfully fetched banner.', data: { banner: { style: banner.style, title: banner.title, body: banner.body } } }, status: :ok
  end

  # DELETE /banners
  def remove_banner
    if current_user == nil
      render json: { error: 'Unauthorized.'}, status: :unauthorized
      return
    end
    if is_allowed_admin? current_user.role
      banner = Banner.new(
        style: 'NONE',
        title: '',
        body: ''
      )

      if banner.save
        render json: { message: 'Successfully deleted banner.' }, status: :ok
      else
        render json: { error: 'Failed to delete banner', errors: banner.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized.'}, status: :unauthorized
    end

  end

  def is_allowed_admin?(role)
    valid_roles = [Role::OWNER, Role::ADMIN]
    valid_roles.include?(Role.value_of role)
  end

end
