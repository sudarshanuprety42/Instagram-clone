class CommentsController < ApplicationController
  def index

  end

  def create

    if(comment_params[:body].empty?)
      flash[:error]="Invalid comment"
      redirect_back(fallback_location: root_path)
    else
      post = Post.find(params[:post_id])
      comment = post.comments.create(:body=>comment_params[:body],:commenter=>current_user.id)
      flash[:success]="Comment posted"
      redirect_to post
    end
  end

private
  def comment_params
    params.require(:comment).permit(:body)
  end

end
