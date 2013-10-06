class GiftsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show, :feed]
  actions :all, :except => [:index, :show]
  respond_to :js, :html

  def mine
    @gifts = current_user.gifts
    
    respond_to do |format|
      format.html 
      format.json { render json: @gifts.as_json(include: :photos) }
    end
  end

  def new
    new! do
      @gift.photos.build
      address = {}
      if current_user.address
        address = current_user.address.attributes.slice(*%w(country_code state_code city))
      end
      @gift.build_address(address)
    end
  end

  def index
    if params[:tag]
      @gifts = Gift.by_tag(params[:tag]).page(params[:page])
    elsif params[:category]
      @category = Category.find(params[:category])
      @gifts = Gift.by_category(@category).page(params[:page])
    else
      @gifts = Gift.includes(:user).page(params[:page])
    end

    respond_to do |format|
      format.html 
      format.json { 
        render json: @gifts.as_json(include: [:user, :category, :photos], methods: :permalink)
      }
    end
    
  end

  def give
    @gift = Gift.find(params[:id])
    if params[:gift][:status] == "true"
      @gift.give!
    elsif params[:gift][:status] == "false"
      @gift.ungive!
    end
  end

  def show
    @gift = Gift.find(params[:id])
    if current_user
      @comment = current_user.comments.new(gift: @gift)
    end
    
    respond_to do |format|
      format.html 
      format.json { render json: @gift.as_json(include: :photos) }
    end
  end

  def feed
    @gifts = Gift.includes(:user).order('created_at desc')
    @updated = @gifts.first.updated_at unless @gifts.empty?

    respond_to do |format|
      format.html { redirect_to feed_path(format: :atom), status: :moved_permanently }
      format.rss  { redirect_to feed_path(format: :atom), status: :moved_permanently }
      format.atom { render layout: false }
    end
  end

  protected

  def begin_of_association_chain
    current_user
  end

end
