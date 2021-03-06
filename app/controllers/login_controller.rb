class LoginController < ApplicationController
  layout 'login'

  def redirecter
    if session[:id].present?
      if session[:manager]
        redirect_to '/manager'
      else
        redirect_to check_in_path
      end
    else
      redirect_to action: :login
    end
  end

  def login
    if request.post?
      username = params[:username]
      password = params[:password]
      if username.blank? && password.blank?
        flash[:error] = "Invalid username/email or password"
        return
      end
      if username.blank?
        flash[:error] = "Invalid username/email"
        return
      end
      if password.blank?
        flash[:error] = "Invalid password"
        return
      end
      user = User.authenticate(username: username, password: password)
      if user.nil?
        flash[:error] = "Invalid username/email or password"
        return
      end
      session[:id] = user.id
      session[:name] = user.name
      session[:manager] = user.manager?
      if session[:manager]
        redirect_to "/manager"
      else
        redirect_to check_in_path
      end
    end
  end

  def logout
    session[:id] = nil
    session[:name] = nil
    session[:manager] = nil
    redirect_to action: :login
  end
end
