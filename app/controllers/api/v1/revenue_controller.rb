class Api::V1::RevenueController < ApplicationController

  def date_range_revenue
    if params[:start] && params[:end]
      revenue = InvoiceItem.revenue_by_date_range(params[:start], params[:end])
      render json: RevenueSerializer.revenue_range(revenue)
    else
      render json: ErrorSerializer.new(:bad_request), status: :bad_request
    end
  end

  def weekly_revenue
  end
end