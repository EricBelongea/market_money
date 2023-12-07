class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  def create
    if params[:market_id].blank? || params[:vendor_id].blank?
      render json: { errors: [{ status: '400', title: 'Market ID or Vendor ID cannot be blank' }] }, status: :bad_request
      return
    end
    market = Market.find(params[:market_id])
    vendor = Vendor.find(params[:vendor_id])
    market_vendor = MarketVendor.create!(market_vendor_params)
    render json: MarketVendorSerializer.new(market_vendor), status: 201
  end

  def destroy
    market_vendor = MarketVendor.find(params[:id])
    market_vendor.destroy!
    render json: MarketVendorSerializer.new(market_vendor), status: 204
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end
