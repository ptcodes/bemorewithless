class UsersController < ApplicationController
  before_filter :find_user, only: %w(show comments gifts wishes)

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html 
      format.json { render json: @user.as_json(method: :avatar) }
    end
  end

  def comments
    @comments = @user.comments.includes([:user, :gift]).page(params[:page])
  end

  def gifts
    @gifts = @user.gifts.page(params[:page])
  end

  def wishes
    @wishes = @user.wishes.page(params[:page])
  end

  def omniauth_failure
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
