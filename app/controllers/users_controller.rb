class UsersController < InheritedResources::Base
  actions :show
  before_filter :find_user, only: %w(show comments gifts wishes)

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
