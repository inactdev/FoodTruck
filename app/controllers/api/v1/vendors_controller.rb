module Api
  module V1
    class VendorsController < ApplicationController
      before_action :set_search_area, only: [:index]
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
        if @origin
          # TODO make default distance customizable
          @distance ||= 5
          bounds = ::Geokit::Bounds.from_point_and_radius(@origin, @distance)
          @vendors = ::Vendor.in_bounds(bounds).all
          search if includes_more_search_params?

          render :json => @vendors, :adapter => :json
        else
          render :text => "We don't know where you are"

        end

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

      def includes_more_search_params?
        search_params[:name] || search_params[:food_type] || search_params[:description]
      end

      def search
        @vendors = @vendors.by_name(search_params[:name]) if search_params[:name]
        @vendors = @vendors.by_food_type(search_params[:food_type]) if search_params[:food_type]
        # TODO need to make description a fuzzy search
        @vendors = @vendors.by_description(search_params[:description]) if search_params[:description]
      end

      def set_search_area
        return unless search_params
        @distance = search_params[:distance]
        @origin = [search_params[:latitude], search_params[:longitude]]
        @origin = ::Vendor.geocode(search_params[:address]) unless @origin
      end

      def search_params
        params.require(:search).permit(:name, :food_type, :description, :address, :latitude, :longitude, :distance) if params[:search]
      end

      def vendor_params
        params.require(:vendor).permit(:name, :food_type, :description)
      end
    end
  end
end
