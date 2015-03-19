class AuthorizationsController < ApplicationController
    def exchange_token
         user_credentials.code = params[:code] if params[:code]
  user_credentials.fetch_access_token!
  redirect to('/')
    end
end