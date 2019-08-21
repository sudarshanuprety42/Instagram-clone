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

    end

  end

  def destroy

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
