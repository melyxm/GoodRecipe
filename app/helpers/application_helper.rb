module ApplicationHelper
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def sign_in(user)
     @remember_token = cookies.permanent[:remember_token]
     user.update_attribute(:remember_token, @current_user)
  end

    def signed_in?
      !current_user.nil?
    end

    def signed_in_user
          unless signed_in?
             flash[:danger] = "Please log in."
             redirect_to log_in_path
          end
       end

end
