class Api::V1::RevenueController < ApplicationController

  def date_range_revenue
    revenue = InvoiceItem.revenue_by_date_range(params[:start], params[:end])
    # require 'pry'; binding.pry
    render json: RevenueSerializer.revenue_range(revenue)
  end
end