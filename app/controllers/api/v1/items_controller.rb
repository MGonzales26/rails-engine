class Api::V1::ItemsController < ApplicationController

  def index
    items = if params[:merchant_id]
      # require 'pry'; binding.pry
              Merchant.find(params[:merchant_id]).items
             else
              Item.paginate(per_page: params[:per_page], page: params[:page])
             end
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def find_all
    items = Item.items_within_price_range(params[:min_price], params[:max_price])
    render json: ItemSerializer.new(items)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end
  
  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item)
  end
  
  def destroy
    Item.destroy(params[:id])
  end
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end