class MicropostsController < ApplicationController
	before_filter :signed_in_user

	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			# When micropost posted to micropost_path, we get flash,
			# and go back to root!
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			# Create empty array for @feed_items for error handling
			@feed_items = []
			render 'static_pages/home'
		end
		
	end

	def destroy
		
	end

end

