class V1Controller < ApplicationController
  before_filter :authenticate_user!, :except => [:login_via_facebook, :gifts_all, :gift]
  respond_to :json

  def login_via_facebook
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

  def gifts_all
    if params[:tag]
      @gifts = Gift.by_tag(params[:tag]).page(params[:page])
    elsif params[:category]
      @category = Category.find(params[:category])
      @gifts = Gift.by_category(@category).page(params[:page])
    else
      @gifts = Gift.includes(:user).page(params[:page])
    end

    render json: @gifts.as_json(include: [:user, :category, :photos], methods: :permalink)
  end

  def gifts_mine
    @gifts = current_user.gifts
    render json: @gifts.as_json(:include => :photos)
  end

  def gifts_i_wish
    @wishes = current_user.wishes

    @wish_ids = []
    @wishes.each { |wish| @wish_ids.push wish[:gift_id]  }
    @wish_ids.uniq!

    @gifts = Gift.where('id IN (?)', @wish_ids)
    render json: @gifts.as_json(:include => :photos)
  end

  def gift
    @gift = Gift.find(params[:id])

    render json: @gift.as_json(:include => :photos)
  end

end
