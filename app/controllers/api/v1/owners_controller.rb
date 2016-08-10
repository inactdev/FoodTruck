module Api
  module V1
    class OwnersController < ApplicationController
      skip_before_filter :verify_authenticity_token

      before_action :set_owner, only: [:show, :edit, :update, :destroy]

      def create
        @owner = ::Owner.new(owner_params)

        if @owner.save
          render :text => @owner.access_token, :status => 201
        else
          render :json => @owner.errors, :status => 422
        end
      end

      def edit
        if @owner
          render json: @owner, only: [:name, :email],  status: 200
        else
          render text: "Could not find Owner", status: 422
        end
      end

      def destroy
        if @owner.destroy
          render :text => "Owner deleted successfully", :status => 200
        else
          render :json => "Owner could not be deleted :o/", :status => 422
        end
      end

      def index
        @owners = ::Owner.all

        render :json => @owners, :adapter => :json
      end

      def new
        @owner = ::Owner.new

        render :json => @owner, :adapter => :json
      end

      def show
        if @owner
          render :json => @owner,  status: 200
        else
          render text: "Could not find Owner", status: 422
        end
      end

      def update
        if @owner.update_attributes(owner_params)
          render :text => "Owner updated successfully", :status => 200
        else
          render :json => "Owner could not be updated :o/", :status => 422
        end
      end

      private

      def owner_params
        params.require(:owner).permit(:name, :email, :password, :password_confirmation)
      end

      def set_owner
        @owner = ::Owner.by_access_token(params[:access_token]).first
      end
    end
  end
end
