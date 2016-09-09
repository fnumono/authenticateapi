include ActionController::HttpAuthentication::Basic::ControllerMethod
include ActionController::HttpAuthentication::Token::ControllerMethod

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  before_filter :authenticate_user_from_token, except: [:token]
  protect_from_forgery with: :exception

  def token
  	authenticate_with_http_basic do |email,password|
  		user = User.find_by(email: email)
  		if user && user.password == password
  			render json: {token: user.auth_token}
  		else
  			render json: {error: 'Incorrect credentials'}, status: 401
  		end
  end

  private 

  def authenticate_user_from_token
  	unless authenticate_with_http_token { |token, options| User.find_by(auth_token: token)}
  		render json: {error : 'Bad Token'}, status: 401
  	end
  end
end
