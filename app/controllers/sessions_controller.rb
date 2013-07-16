class SessionsController < ApplicationController
	def new
		
	end

	def create
		user = User.find_by_email(params[:email].downcase)
		
		# If user exists and she is authenticated(correct password)
		if user && user.authenticate(params[:password].downcase)
			# Sign in the user and redirect to the user's show page
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
