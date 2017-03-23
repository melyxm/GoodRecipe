class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path, :notice => "Signed in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def create_from_omniauth
    auth_hash = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
      if authentication.user
        user = authentication.user
        authentication.update_token(auth_hash)
        @next = root_path
        @notice = "Signed in with Facebook!"
      else
        user = User.create_with_auth_and_hash(authentication, auth_hash)
        @next = root_path(user)
        @notice = "User created - confirm or edit details..."
      end
    sign_in(user)
    redirect_to @next, :notice => @notice
  end

end
