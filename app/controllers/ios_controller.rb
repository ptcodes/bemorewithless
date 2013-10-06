class IosController < ApplicationController
  def login
    begin
      token = params[:token]

      # debugger

      fb_user = FbGraph::User.me(token)
      # debugger
      fb_user = fb_user.fetch

      

      user = User.where(:email => fb_user.email).first
      user = User.create(:email => fb_user.email, :password => fb_user.identifier, :password_confirmation => fb_user.identifier, 
        :first_name => fb_user.first_name, :last_name => fb_user.last_name, :username => "#{fb_user.first_name}-#{fb_user.last_name}") unless user
      
      user.reset_authentication_token!

      render :json => { :user => user, :auth_token => user.authentication_token, :fb_user => fb_user }
    # rescue Exception => e
    #   render :json => { :error => e.message }
    end
  end
end
