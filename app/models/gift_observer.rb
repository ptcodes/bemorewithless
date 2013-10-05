class GiftObserver < ActiveRecord::Observer

  def after_activate(gift)
    if gift.promised_to_anyone?
      gift.promise!
    end
  end

  def after_give(gift, transition)
    UserMailer.gift_given(gift).deliver
  end
end
