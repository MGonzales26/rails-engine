class Api::V1::ItemsController < ApplicationController

  def index
    @items = Item.all.paginate(per_page: params[:per_page], page: params[:page])
    render json: ItemSerializer.new(@items)
  end

  def show
    @item = Item.find(params[:id])
    render json: ItemSerializer.new(@item)
  end
end