class UserMailer < ActionMailer::Base
  default from: "evanidul@simpleweed.org"
  layout 'base_email_template'

  def test(email)
    mail(:to => email, :subject => "Hello World!")
  end

  # FOLLOWING 

  def user_following_user(notify, stalker)
  	subject = "#{stalker.username} is now following you"
  	@stalker = stalker
  	@notify = notify
  	mail(:to => notify.email, :subject => subject)
  end

  # COMMENTS

  def user_commented_on_store_review(commenter, review)
  	subject = "#{commenter.username} commented on your review of #{review.store.name}"
  	@commenter = commenter
  	@review = review
  	mail(:to => review.user.email, :subject => subject)
  end

  def user_commented_on_item_review(commenter, itemreview)
	subject = "#{commenter.username} commented on your review of #{itemreview.store_item.name}"
	@commenter = commenter
	@itemreview = itemreview	
	mail(:to => itemreview.user.email, :subject => subject)
  end

  def user_commented_on_post(commenter, post)
  	subject = "#{commenter.username} commented on #{post.title}"
  	@commenter = commenter
  	@post = post
  	mail(:to => post.user, :subject => subject)
  end

end
