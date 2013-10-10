class V1Controller < ApplicationController
  before_filter :authenticate_user!, :except => [:login_via_facebook, :user_profile, :gifts_all, :gift]
  respond_to :json

  def my_profile
    @user = current_user
    render json: @user.as_json(method: :avatar)
  end

  def user_profile
    @user = User.find(params[:id])
    render json: @user.as_json(method: :avatar)
  end

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

    user = current_user
    if (user)
      @gifts.each { |gift| gift.current_user = user }
    end

    render json: @gifts.as_json(include: [:user, :category, :photos], methods: :can_be_wished_by?)
  end

  def gifts_mine
    @gifts = current_user.gifts.page(params[:page])

    user = current_user
    if (user)
      @gifts.each { |gift| gift.current_user = user }
    end

    render json: @gifts.as_json(:include => :photos, methods: :can_be_wished_by?)
  end

  def gifts_i_wish
    @wishes = current_user.wishes.page(params[:page])

    @wish_ids = []
    @wishes.each { |wish| @wish_ids.push wish[:gift_id]  }
    @wish_ids.uniq!

    @gifts = Gift.where('id IN (?)', @wish_ids)

    user = current_user
    if (user)
      @gifts.each { |gift| gift.current_user = user }
    end

    render json: @gifts.as_json(:include => :photos, methods: :can_be_wished_by?)
  end

  def gift
    @gift = Gift.find(params[:id])

    @gift.current_user = user

    render json: @gift.as_json(:include => :photos, methods: :can_be_wished_by?)
  end

end
