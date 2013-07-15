module SessionsHelper

	def sign_in(user)
		# add a permanent cookie (20.years.from_now) to cookies based on generated remember_token
		cookies.permanent[:remember_token] = user.remember_token
		# make current_user accessible in controllers and views!
		self.current_user = user
	end

	# Function to check if user is signed in
	def signed_in?
		# current_user is not nil!
		!current_user.nil?
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	# a sweet function to assign something to var @current_user!
	# func_name=(var) and assigning allows func_name = var later!
	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end
end
