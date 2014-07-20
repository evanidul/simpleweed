class UserMailer < ActionMailer::Base
  default from: "evanidul@simpleweed.org"

  def test(email)
    mail(:to => email, :subject => "Hello World!")
  end

  
end
