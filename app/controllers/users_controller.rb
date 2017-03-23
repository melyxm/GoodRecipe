class UsersController < ApplicationController
  # before_action :signed_in_user

  def new
      @user = User.new
  end

    def create
      @user = User.new(allowed_params)
      if @user.save
        redirect_to user_path(@user.id), notice: 'Thank you for signing up!'
      else
        render :new
      end
    end

    def show
      
    end

    private

    def allowed_params
      params.require(:user).permit(:email, :password, :password_salt)
    end
end
