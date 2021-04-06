class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all.paginate(per_page: params[:per_page], page: params[:page]))
  end
end