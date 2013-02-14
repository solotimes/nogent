module ControllerExtensions
	module Authentication
		extend ActiveSupport::Concern

    def current_user
      @current_user ||= login_from_session || login_from_cookies unless defined?(@current_user)
      @current_user
    end

	  def user_signed_in?
	    !!current_user
	  end

	  def admin?
	    !!current_user.try(:admin?)
	  end

    def store_location(path = nil)
      session[:return_to] = path || request.fullpath
    end

	  def authenticate_user!
	    if !current_user
	    	store_location
	      redirect_to signin_url, :alert => I18n.t('errors.messages.login_required')
	    end
	  end

	  def authenticate_admin!
	    if !admin?
	    	store_location
	      redirect_to signin_url, :alert => I18n.t('errors.messages.permission_required')
	    end
	  end

    def login_as(user)
      session[:user_id] = user.id
      @current_user = user
    end

    def logout
      session.delete(:user_id)
      @current_user = nil
      forget_me
    end

    def login_from_session
      if session[:user_id].present?
        begin
          User.find session[:user_id]
        rescue
          session[:user_id] = nil
        end
      end
    end

    def login_from_cookies
      if cookies[:remember_token].present?
        if user = User.find_by_remember_token(cookies[:remember_token])
          session[:user_id] = user.id
          user
        else
          forget_me
          nil
        end
      end
    end

    def login_from_access_token
      @current_user ||= User.find_by_access_token(params[:access_token]) if params[:access_token]
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def redirect_referrer_or_default(default)
      redirect_to(request.referrer || default)
    end

    def forget_me
      cookies.delete(:remember_token)
    end

    def remember_me
      cookies[:remember_token] = {
        :value   => current_user.remember_token,
        :expires => 4.weeks.from_now
      }
    end
	end
end