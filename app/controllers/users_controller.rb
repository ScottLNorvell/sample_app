class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_filter :not_signed_in_user, only: [:new, :create]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :admin_user,      only: :destroy

  def show
  	@user = User.find(params[:id]) # find user with id of page user/id
    @microposts = @user.microposts.paginate(page: params[:page])
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

  def edit
    # Don't need to define this because correct_user? defines it for us!
    # @user = User.find(params[:id])
    
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User Obliterated!"
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private


    def not_signed_in_user
      if signed_in?
        redirect_to root_url, notice: "You are already signed in!"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
