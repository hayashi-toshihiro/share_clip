class CommentLikesController < ApplicationController

  def create
    @comment = Comment.find(params[:comment_id])
    current_user.comment_like(@comment)
  end

  def destroy
    @comment = current_user.comment_likes.find(params[:id]).comment
    current_user.comment_unlike(@comment)
  end
end
