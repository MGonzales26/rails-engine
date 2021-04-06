class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all.paginate(per_page: params[:per_page], page: params[:page]))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end