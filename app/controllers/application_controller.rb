class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?

  def current_user
    if session[:user_jwt]
      token = session[:user_jwt]["value"].first

      if token && token["email"]
        @email = token["email"]
      else
        head :forbidden
        return
      end
      return token
    end
  end

  def logged_in?
    current_user.present?
  end

end
