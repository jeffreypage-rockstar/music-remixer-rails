class App::CommentsController < App::BaseController
  before_action :require_login

  def create
    @commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(@commentable, current_user.id, body)
#    @comments = Comment.where(commentable_id: commentable_id)

    respond_to do |format|
      if @comment.save
        make_child_comment
        format.html  { redirect_to(:back, :notice => 'Comment was successfully added.') }
        format.js do
          @new_comment = Comment.build_from(@commentable, current_user.id, "")
          render :comments_template
        end
      else
        format.html  { render :action => "new" }
      end
    end
  end

  def index
    @commentable = params[:commentable_type].constantize.find(params[:commentable_id])
    @new_comment = Comment.build_from(@commentable, current_user.id, "")
    render :comments_template
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return "" if comment_id.blank?

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end

end