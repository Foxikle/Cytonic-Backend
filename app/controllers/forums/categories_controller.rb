class Forums::CategoriesController < ApplicationController

  # GET /forums/categories
  def index
    categories = Forums::Category.all
    render json: CategorySerializer.new(categories).serializable_hash, status: :ok
  end

end
