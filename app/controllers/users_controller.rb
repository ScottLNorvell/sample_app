class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id]) # find user with id of page user/id
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		# Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
  		
  	else
  		render 'new'
  	end
  end
end
