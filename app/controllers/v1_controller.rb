class V1Controller < ApplicationController
  before_filter :authenticate_user!, :except => [:gifts_all, :gift]
  respond_to :json

  def gifts_all
    @gifts = Gift.all
    render json: @gifts.as_json(include: :photos)
  end

  def gifts_mine
    @gifts = current_user.gifts
    render json: @gifts.as_json(include: :photos)
  end

  def gifts_i_wish
    @wishes = current_user.wishes

    @wish_ids = []
    @wishes.each { |wish| @wish_ids.push wish[:gift_id] }
    @gifts = Gift.where('id IN (?)', @wish_ids)
    render json: @gifts.as_json(include: :photos)
  end

  def gift
    @gift = Gift.find(params[:id])

    render json: @gift.as_json(include: :photos)
  end

end
