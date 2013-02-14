class ApplicationController < ActionController::Base
  protect_from_forgery
  include ControllerExtensions::Authentication
  include ControllerExtensions::ErrorPages
end
