class UserMailer < ActionMailer::Base
  default from: "evanidul@simpleweed.org"
  layout 'base_email_template'

  def test(email)
    mail(:to => email, :subject => "Hello World!")
  end

  def user_following_user(notify, stalker)
  	subject = "#{stalker.username} is now following you"
  	@stalker = stalker
  	@notify = notify
  	mail(:to => notify.email, :subject => subject)
  end

end
