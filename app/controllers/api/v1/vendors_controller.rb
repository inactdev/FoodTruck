module Api
  module V1
    class VendorsController < ApplicationController
      skip_before_filter :verify_authenticity_token

      def create
        @vendor = ::Vendor.new(vendor_params)

        if @vendor.save
          redirect_to vendor_path(@vendor)
        else
          redirect_to :back
        end
      end

      def edit
        @vendor = ::Vendor.find(params[:id])

        render :json => @vendor, :adapter => :json
      end

      def destroy
        @vendor = ::Vendor.find(params[:id])

        if @vendor.destroy
          redirect_to vendors_path
        else
          redirect_to :back
        end
      end

      def index
        @vendors = ::Vendor.all

        render :json => @vendors, :adapter => :json
      end

      def new
        @vendor = ::Vendor.new

        render :json => @vendor, :adapter => :json
      end

      def show
        @vendor = ::Vendor.find(params[:id])

        render :json => @vendor, :adapter => :json
      end

      def update
        @vendor = ::Vendor.find(params[:id])

        if @vendor.update_attributes(vendor_params)
          redirect_to vendor_path(@vendor)
        else
          redirect_to :back
        end
      end

      private

      def vendor_params
        params.require(:vendor).permit(:name, :food_type, :description)
      end
    end
  end
end
