# frozen_string_literal: true

class AuthenticateUser
  def process(params)
    user = User.find_by_username(params[:username])
    return unless user

    user.authenticate(params[:password])
    token = JsonWebToken.encode(user_id: user.id)
    time = Time.now + 1.hours.to_i
    { token: token, exp: time.strftime('%m-%d-%Y %H:%M'), username: user.username }
  end
end
