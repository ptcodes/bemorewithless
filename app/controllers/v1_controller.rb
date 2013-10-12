class V1Controller < ApplicationController
  before_filter :authenticate_user!, :except => [:login_via_facebook, :user_profile, :gifts_all, :gift, :all_comments_for_gift]
  respond_to :json

  def is_gift_wished_by_me
    @user = current_user
    @gift_id = params[:id]

    if (!@user)
      @result = { :wished => false }
    else
      @wishes = Wish.where(:gift_id => @gift_id, :user_id => @user.id)

      @result = nil
      if (!@wishes.empty?)
        @result = { :wished => true }
      else
        @result = { :wished => false }
      end
    end
      render json: @result
  end

  def unwish_gift
    @user = current_user
    @gift = Gift.find(params[:id])
    @wishes = Wish.where(:gift_id => @gift.id, :user_id => @user.id).destroy_all

    @result = {:success => true, :msg => "Unwished okay"}
    render json: @result
  end

  def wish_gift
    @user = current_user
    @gift = Gift.find(params[:id])

    @wishes = Wish.where(:gift_id => @gift.id, :user_id => @user.id)

    if (!@wishes.empty?)
      render :json => { :success => true, :msg => "Is wished already" }
      return
    end

    @wish = Wish.new
    @wish.user_id = @user.id
    @wish.gift_id = @gift.id

    if @wish.save
      @result = {:success => true, :msg => "Wished okay"}
    else
      @result = {:success => false, :msg => "Can't be wished"}
    end
    render json: @result
  end

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
    q = params[:q]

    if params[:tag]
      @gifts = Gift.by_tag(params[:tag]).page(params[:page])
    elsif params[:category]
      @category = Category.find(params[:category])
      @gifts = Gift.by_category(@category).page(params[:page])
    elsif !q.nil?
      terms = []
      q.split.each { |term| terms.push "%#{term}%" }

      queries = []

      columns = ["title","description"]
      terms.each { |term|
        columns.each { |column|
          queries.push "#{column} LIKE \'#{term}\'"
        }
      }

      query = queries.join " OR "
      ap query

      @gifts = Gift.where(query)
    else
      @gifts = Gift.includes(:user).page(params[:page])
    end

    user = current_user
    if (user)
      @gifts.each { |gift| gift.current_user = user }
    end

    render json: @gifts.as_json(include: [:user, :category, :photos], methods: [:can_be_wished_by?, :wishers_count, :comments_count])
  end

  def gifts_mine
    @gifts = current_user.gifts.page(params[:page])

    user = current_user
    if (user)
      @gifts.each { |gift| gift.current_user = user }
    end

    render json: @gifts.as_json(include: [:user, :category, :photos], methods: [:can_be_wished_by?, :wishers_count, :comments_count])
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

    render json: @gifts.as_json(include: [:user, :category, :photos], methods: [:can_be_wished_by?, :wishers_count, :comments_count])
  end

  def gift
    @gift = Gift.find(params[:id])
    @gift.current_user = current_user

    render json: @gift.as_json(include: [:user, :category, :photos], methods: [:can_be_wished_by?, :wishers_count, :comments_count])
  end

  def new_comment_for_gift
    gift = Gift.find(params[:id])
    content= params[:content]

    comment = Comment.new
    comment.user = current_user
    comment.gift = gift
    comment.content = content
    comment.type_id = 1

    if comment.save!
      @result = {:success => true, :msg => "Comment posted"}
    else
      @result = {:success => false, :msg => "Comment wasn't posted"}
    end

    #puts "\n\n=======================\n\n"
    #ap params
    #puts "\n\n=======================\n\n"

    render json: @result
  end

  def all_comments_for_gift
    gift = Gift.find(params[:id])
    render json: gift.gift_comments.as_json(include: :user)
  end

  def delete_comment
    comment_id = params[:id]
    comment = Comment.where("id = ?", comment_id).first

    ap comment
    if comment.nil?
      @result = {:success => false, :msg => "There isn't comment :: id == \'#{comment_id}\''"}
    elsif !comment.owner? current_user
      @result = {:success => false, :msg => "It's not your comment :: id == \'#{comment_id}\''"}
    else
      if comment.destroy
        @result = {:success => true, :msg => "Comment was deleted :: id == \'#{comment_id}\''"}
      else
        @result = {:success => false, :msg => "Comment wasn't deleted :: id == \'#{comment_id}\''"}
      end
    end

    ap @result
    render json: @result
  end
end
