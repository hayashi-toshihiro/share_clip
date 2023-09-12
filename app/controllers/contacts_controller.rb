class ContactsController < ApplicationController
  def new
  end

  def create
    if params[:contact_text].blank?
      flash[:danger] = "要望を入力してください"
      render :new
    else
      ContactMailer.with(user: current_user, email: params[:email], contact_text: params[:contact_text]).contact_email.deliver_now
      redirect_to contact_success_path
    end
  end

  def success
  end
end
