class ContactMailer < ActionMailer::Base
  include SendGrid

  default from: "jason@jasonrhall.com"

  def send_feedback(email, name, content)
    emails = ['jakesorce@gmail.com']
    @email = email
    @name = name
    @content = content
    mail(:to => emails, :subject => "#{name} is trying to contact you via the Jason R Hall Website.")
  end
end