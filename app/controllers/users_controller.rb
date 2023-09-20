class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create get_user_stamp]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to clip_posts_path, success: '登録ありがとネ'
    else
      flash.now[:danger] = '登録失敗しちゃったヨ'
      render :new
    end
  end

  def get_user_stamp
    stamp_id = Image.find_by(name: params[:streamer_name]).image_id
    stamp_data = TwitchApi.new.get_stamp(stamp_id)
    random_stamp = stamp_data["data"].sample

    template = "https://static-cdn.jtvnw.net/emoticons/v2/{{id}}/{{format}}/{{theme_mode}}/{{scale}}"
    data = {
      id: random_stamp["id"],
      format: random_stamp["format"].sample,
      theme_mode: random_stamp["theme_mode"].sample,
      scale: "3.0"
    }

    url = template.gsub("{{id}}", data[:id])
                  .gsub("{{format}}", data[:format])
                  .gsub("{{theme_mode}}", data[:theme_mode])
                  .gsub("{{scale}}", data[:scale])

    respond_to do |format|
      format.js { render 'get_user_stamp.js.erb', locals: { stamp_url: url } }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :stamp_url)
  end
end
