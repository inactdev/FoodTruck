class VendorsController < ApplicationController
  def create
    @vendor = ::Vendor.new(vendor_params)

    if @vendor.save
      flash[:success] = "New vendor created successfully"
      redirect_to vendor_path(@vendor)
    else
      flash[:error] = "New vendor couldn't be created"
      redirect_to :back
    end
  end

  def edit
    @vendor = ::Vendor.find(params[:id])

    render :json => @vendor
  end

  def destroy
    @vendor = ::Vendor.find(params[:id])

    if @vendor.destroy
      flash[:success] = "Vendor deleted successfully"
      redirect_to vendors_path
    else
      flash[:error] = "Vendor couldn't be deleted"
      redirect_to :back
    end
  end

  def index
    @vendors = ::Vendor.all

    render :json => @vendors, :adapter => :json
  end

  def new
    @vendor = ::Vendor.new

    render :json => @vendor
  end

  def show
    @vendor = ::Vendor.find(params[:id])

    render :json => @vendor
  end

  def update
    @vendor = ::Vendor.find(params[:id])

    if @vendor.update_attributes(vendor_params)
      flash[:success] = "Vendor updated successfully"
      redirect_to vendor_path(@vendor)
    else
      flash[:error] = "Vendor couldn't be updated"
      redirect_to :back
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :type, :description)
  end
end
