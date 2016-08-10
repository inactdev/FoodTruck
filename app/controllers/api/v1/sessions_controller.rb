module Api
  module V1
    class SessionsController < ApplicationController
      def new
      end

      def create
        owner = ::Owner.find_by(:email => params[:session][:email].downcase)

        if owner && owner.authenticate(params[:session][:password])
          render :text => owner.access_token, :status => 200
        else
          case owner.nil?
          when true
            render :text => "Sorry, we couldn't find that email :o/", :status => 404
          else
            render :text => "Password Incorrect", :status => 401
          end
        end
      end

      def verify_access_token
        owner = ::Owner.find_by(:access_token => params[:session][:access_token])

        if owner
          render :text => "verified", :status => 200
        else
          render :text => "Token failed verification", :status => 422
        end
      end
    end
  end
end
