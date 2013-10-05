class CommentsController < InheritedResources::Base
  actions :create, :edit, :update, :destroy
  respond_to :js

  def new
    @comment = current_user.comments.new(gift_id: params[:gift_id])
  end

  protected

  def begin_of_association_chain
    current_user
  end
end
