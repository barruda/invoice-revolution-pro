# frozen_string_literal: true

class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  protected

  def authorize
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @decoded = JsonWebToken.decode(header)
    @current_user = User.find(@decoded[:user_id])
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { errors: 'Invalid Authorization Signature' }, status: :unauthorized
  end
end
