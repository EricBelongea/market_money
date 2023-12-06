class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def show 
    render json: VendorSerializer.new(Vendor.find(params[:id]))
    # require 'pry'; binding.pry
  end

  def create
    # render json: VendorSerializer.new(vendor_params)
    # require 'pry'; binding.pry
    vendor = Vendor.new(vendor_params)
    require 'pry'; binding.pry
    if vendor.save
      render json: VendorSerializer.new(vendor), message: "Vendor created successfully", status: :created
      # render json: { message: "Vendor created successfully", vendor: VendorSerializer.new(vendor) }, status: :created
      # require 'pry'; binding.pry
    else
      render json: { errors: your_resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end