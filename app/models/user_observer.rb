class UserObserver < ActiveRecord::Observer

  def before_create(user)
    user.language = I18n.locale
  end

  def after_create(user)
    UserMailer.welcome(user).deliver
  end

end
