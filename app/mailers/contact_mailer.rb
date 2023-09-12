class ContactMailer < ApplicationMailer
  default from: "from@example.com"

  def contact_email
    mail(to: "clipreactor86@gmail.com", subject: "お問い合わせメール")
  end
end
