class UsersController < ApplicationController
    before_action :require_login, except: [:new, :create]  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path, notice: "Successfully signed up!"
      else
        render :new  # Keeps the form and displays errors instead of redirecting
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  
    def require_login
      unless session[:user_id]
        flash[:alert] = "You must be logged in to view this page."
        redirect_to login_path
      end
    end
  end

  