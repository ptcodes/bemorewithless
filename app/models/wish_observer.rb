class WishObserver < ActiveRecord::Observer

  def after_create(wish)
    UserMailer.new_wish(wish).deliver
  end

  def after_update(wish)
    if wish.promised?
      UserMailer.new_promise(wish).deliver
    end

    if wish.gift.promised_to_anyone?
      if wish.promised?
        wish.gift.promise!
      end
    else
      wish.gift.unpromise!
    end
  end

  def after_delete(wish)
    unless wish.gift.promised_to_anyone?
      wish.gift.unpromise!
    end
  end
end
