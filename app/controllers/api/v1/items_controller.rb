class Api::V1::ItemsController < ApplicationController

  def index
    items = if params[:merchant_id]
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
    items = Item.items_within_price_range(params[:min_price])
    render json: ItemSerializer.new(items)
    # require 'pry'; binding.pry
  end
end