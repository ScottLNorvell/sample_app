class MicropostsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, 	 only: :destroy

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
		@micropost.destroy
		redirect_to root_url
	end

	private

		def correct_user
			# see if the micropost belongs to the current_user
			# by looking it up!
			# .find_by_id returns nil instead of an error (like .find)
			# ALSO, alsways run lookups by association for security!
			@micropost = current_user.microposts.find_by_id(params[:id])
			# redirect to root_url if not!
			redirect_to root_url if @micropost.nil?
		end

end

