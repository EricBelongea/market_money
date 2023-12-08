class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  before_action :find_market, only: %w[index create]

  def index
    # market = Market.find(params[:market_id])
    vendors = @market.vendors
    render json: VendorSerializer.new(vendors)
  end

  def create
    # market = Market.find(params[:market_id])
    vendor = Vendor.find(params[:vendor_id])
    if MarketVendor.exists?(market_id: @market.id, vendor_id: vendor.id)
      render json: { errors: [{ status: '422', title: 'Market and Vendor pairing already exists' }] }, status: :unprocessable_entity
    else
      market_vendor = MarketVendor.create!(market_vendor_params)
      render json: MarketVendorSerializer.new(market_vendor), status: 201
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if MarketVendor.exists?(market_id: params[:market_id], vendor_id: params[:vendor_id]) # if calling market_vendor.id NoMethodError possible refactor to a rescue_from
      market_vendor.destroy!
      render json: { message: "MarketVendor deleted" }, status: 204
    else
      render json: { message: "MarketVendor does not exist"}, status: 404
    end
  end

  private

  def find_market
    @market = Market.find(params[:market_id])
  end

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end
