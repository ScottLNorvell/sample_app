class ApplicationController < ActionController::Base
  protect_from_forgery
  # to include this helper in all of our controllers!
  include SessionsHelper

  def handle_unverified_request
  	sign_out
  	super
  end
end
