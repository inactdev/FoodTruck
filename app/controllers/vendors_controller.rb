class VendorsController < ApplicationController
  def create
    @vendor = ::Vendor.create(vendor_params)

    redirect_to vendor_path(@vendor) if @vendor.save
  end

  def index
    @vendors = ::Vendor.all
  end

  def show
    @vendor = ::Vendor.find(params[:id])
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name)
  end
end
