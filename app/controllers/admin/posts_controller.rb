class Admin::PostsController < ApplicationController
  def index
    @posts = Post.visible

    case params[:sort]
    when "favorites"
      @posts = @posts.order(favorites_count: :desc)
    when "latest"
      @posts = @posts.order(created_at: :desc)
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_hashtags = @post.hashtags
  end
end
