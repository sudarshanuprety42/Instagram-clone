class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "Posted Successfully."
      redirect_to root_path
    else
      flash[:error] = "Invalid post"
      redirect_to root_path
      #render plain: params[:post].inspect
      #render :template => 'instagram/index'

    end

  #For inserting to db without form
  # @article = Article.new(:title=>"no form",:text=>"success")
  # @article.save
  # redirect_to articles_path
  end

  def destroy
    # @user = Article.find(params[:article_id])
    # @comment = @article.comments.find(params[:id])
    # @comment.destroy
    # redirect_to article_path(@article)
    post = Post.find(delete_params[:id])
    post.destroy
    @followings = current_user.followings.pluck(:flwg).to_a
    @followers = current_user.followers.pluck(:flwr).to_a
    redirect_to '/instagram/currentuser'
  end
  def show
    @post = Post.find(params[:id])
    @post1 = Post.find(params[:id])
  end
  private
  def post_params
    params.require(:post).permit(:description, :user_id, images: [])
  end

  def delete_params
    params.permit(:id)
  end



end
