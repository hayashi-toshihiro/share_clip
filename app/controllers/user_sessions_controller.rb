class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new;end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to clip_posts_path, success: "ログインしたヨ"
    else
      flash.now[:danger] = 'ログイン失敗しちゃったヨ'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path, danger: 'ログアウトしたヨ'
  end
end
