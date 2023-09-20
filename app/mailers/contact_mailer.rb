class ContactMailer < ApplicationMailer
  default from: "from@example.com"

  def contact_email
    mail(to: "clipreactor86@gmail.com", subject: I18n.t('contact_mailer.subject'))
  end
end
