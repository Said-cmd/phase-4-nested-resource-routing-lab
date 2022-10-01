class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
    items = Item.all
    end
    render json: items, include: :user, status: :ok
  end

  def show
    item = Item.find(params[:id])
    render json: item, status: :ok
  end

  def create 
    item = Item.create(item_params)
    render json: item, status: :created
  end

  private 

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found
    render json: { error: "Item not found"}, status: :not_found
  end

  def render_unprocessable_entity(invalid)
    render json: { error: invalid.record.errors }, status: :unprocessable_entity
  end

end
