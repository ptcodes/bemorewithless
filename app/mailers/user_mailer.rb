# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: 'Be More With Less <noreply@bemorewithless.herokuapp.com>'

  def welcome(user)
    @user = user
    I18n.locale = @user.language.to_sym
    mail(to: @user.email, subject: I18n.t('email.subject.welcome'))
  end

  def new_wish(wish)
    @wish = wish
    @user = wish.gift.user
    I18n.locale = @user.language.to_sym
    mail(to: @user.email, subject: I18n.t('email.subject.new_wish'))
  end

  def new_promise(wish)
    @wish = wish
    @user = wish.user
    I18n.locale = @user.language.to_sym
    mail(to: @user.email, subject: I18n.t('email.subject.new_promise'))
  end

  def new_gift_comment(comment, user)
    @comment = comment
    @user = user
    I18n.locale = @user.language.to_sym
    mail(to: @user.email, subject: I18n.t('email.subject.new_comment'))
  end

  def new_meeting_comment(comment, user)
    @comment = comment
    @user = user
    I18n.locale = @user.language.to_sym
    mail(to: @user.email, subject: I18n.t('email.subject.new_meeting_comment'))
  end

  def new_thank_comment(comment, user)
    @comment = comment
    @user = user
    I18n.locale = @user.language.to_sym
    mail(to: @user.email, subject: I18n.t('email.subject.new_thank_comment'))
  end

  def gift_given(gift)
    @gift = gift
    gift.promisees.each do |wish|
      @user = wish.user
      I18n.locale = @user.language.to_sym
      mail(to: @user.email, subject: I18n.t('email.subject.gift_given'))
    end
  end

end
