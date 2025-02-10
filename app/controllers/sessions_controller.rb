class SessionsController < ApplicationController
  def new
    if session[:user_id] # Check if user is logged in
      redirect_to categories_path # Redirect to categories index
    end
  end
  
    def create
      user = User.find_by(email: params[:email]) # or use username if applicable
  
      if user && user.authenticate(params[:password]) # bcrypt authentication
        session[:user_id] = user.id
        flash[:notice] = "Logged in successfully!"
        redirect_to root_path
      else
        flash[:alert] = "Invalid email or password"
        render :new
      end
    end
  
    def destroy
      session[:user_id] = nil
      flash[:notice] = "Logged out successfully!"
      redirect_to login_path
    end
  end
  