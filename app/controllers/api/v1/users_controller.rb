include ActionController::HttpAuthentication::Token

module Api
  module V1
    class UsersController < ApplicationController
      before_filter :restrict_access
      protect_from_forgery with: :null_session

      def create_new_session
        api_key = token_and_options(request)[0]

        if params[:user_id] && params[:username]
          user = User.find_or_create_api_user(
            params[:user_id], 
            params[:username], 
            api_key)

          sign_in(user)
          redirect_to campaigns_path
        else
          @error_code = 22
          @error_message = 'User id and username required'

          render 'api/v1/error', status: 401
        end
      end
    end
  end
end
