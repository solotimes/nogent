class SessionsController < ApplicationController
  layout 'blank'

  def new
    store_location request.referrer if request.referrer.present?
  end

  def create
    user = User.authenticate(params[:user])
    if user
      login_as user
      flash[:notice] = I18n.t('flash.sessions.create.notice')
      remember_me if params[:remember_me]
      redirect_back_or_default(root_url)
    else
      flash[:error] = I18n.t 'flash.sessions.create.alert'
      redirect_to(signin_url)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to request.referrer || root_url, :notice => I18n.t('flash.sessions.destroy.notice')
  end
end