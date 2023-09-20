class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    @clip_post = ClipPost.find(params[:clip_post_id])
    @comments =  @clip_post.comments.includes(:user).order(created_at: :desc)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(clip_post_id: params[:clip_post_id])
  end
end
