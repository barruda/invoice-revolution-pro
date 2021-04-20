# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def login
    user_credentials = AuthenticateUser.new.process(login_params)
    if user_credentials
      render json: user_credentials, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
