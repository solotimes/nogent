module ControllerExtensions
	module ErrorPages
		extend ActiveSupport::Concern

		included do
		  unless Rails.application.config.consider_all_requests_local
		    rescue_from Exception, :with => lambda { |exception| render_error 500, exception }
		    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, Mongoid::Errors::DocumentNotFound, :with => lambda { |exception| render_error 404, exception }
		  end
		end

	  private
	  #http://ramblinglabs.com/blog/2012/01/rails-3-1-adding-custom-404-and-500-error-pages
	  def render_error(status, exception)
	    @error = exception
	    logger.error @error.message
	    logger.error @error.backtrace.join("\n")
	    respond_to do |format|
	      format.html { render :template => "errors/error_#{status}", :layout => false , :status => status }
	      format.all { render :nothing => true, :status => status }
	    end
	  end
	end
end