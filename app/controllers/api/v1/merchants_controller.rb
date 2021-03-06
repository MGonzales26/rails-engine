class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.paginate(per_page: params[:per_page], page: params[:page])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = if params[:item_id]
                 Item.find(params[:item_id]).merchant
               else
                 Merchant.find(params[:id])
               end
    render json: MerchantSerializer.new(merchant)
  end

  def find
    merchant = Merchant.find_merchant_by_name(params[:name])
    if merchant.nil?
      render json: { data: {} }
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end