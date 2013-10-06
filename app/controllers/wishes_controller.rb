class WishesController < InheritedResources::Base
  actions :create, :update, :destroy
  respond_to :js
  before_filter :find_gift, :only => [:create, :destroy, :update, :promise]

  def mine
    @wishes = current_user.wishes
    
    respond_to do |format|
      format.html 
      format.json { render json: @wishes }
    end
  end

  def create
    @wish = current_user.wishes.build(params[:wish])

    respond_to do |format|
      if @wish.save
        format.json { render :json => { :success => true } }
        format.js
      else
        format.json { render json: @wish.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def promise
    @gift.promise!
  end

  def update
    @wish = Wish.find(params[:id])
    @wish.update_attributes(params[:wish])
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def find_gift
    if params[:wish] && params[:wish][:gift_id]
      @gift = Gift.find(params[:wish][:gift_id])
    else
      wish = Wish.find(params[:id])
      @gift = wish.gift
    end
  end
end
