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
  	#mail(:to => notify.email, :subject => subject)
  end

  def user_following_store(store, follower)
	subject = "#{follower.username} is now following #{store.name}"
  	@follower = follower
  	@store = store
  	
  	# switch this once we go live
  	#mail(:to => store.email, :subject => subject)
  	#mail(:to => "evanidul@gmail.com", :subject => subject)
  end

  def user_following_item(item, follower)
	subject = "#{follower.username} is now following #{item.name}@#{item.store.name}"
  	@follower = follower
  	@item = item
  	
  	# switch this once we go live
  	#mail(:to => item.store.email, :subject => subject)
  	#mail(:to => "evanidul@gmail.com", :subject => subject)
  end

  # NOTIFY STORE OWNERS OF NEW REVIEWS

  def store_has_new_review(review)
	subject = "#{review.user.username} wrote a new review about #{review.store.name}"
  	@review = review
  	
  	# switch this once we go live
  	#mail(:to => review.store.email, :subject => subject)
  	#mail(:to => "evanidul@gmail.com", :subject => subject)
  end

  def store_has_new_item_review(itemreview)
	subject = "#{itemreview.user.username} wrote a new review about #{itemreview.store_item.name}@#{itemreview.store_item.store.name}"
  	@itemreview = itemreview
  	
  	# switch this once we go live
  	#mail(:to => review.store.email, :subject => subject)
  	#mail(:to => "evanidul@gmail.com", :subject => subject)
  end	

  # NOTIFY STORE FOLLOWERS OF AN UPDATE

  def store_has_updated_ftp(follower, store)
  	subject = "#{store.name} has updated first time patient deals"
  	@follower = follower
  	@store = store
  	#mail(:to => follower.email, :subject => subject)
  end

  def store_has_updated_dailyspecials(follower, store)
  	subject = "#{store.name} has updated daily specials"
  	@follower = follower
  	@store = store
  	#mail(:to => follower.email, :subject => subject)
  end

  # COMMENTS

  def user_commented_on_store_review(commenter, review)
  	subject = "#{commenter.username} commented on your review of #{review.store.name}"
  	@commenter = commenter
  	@review = review
  	#mail(:to => review.user.email, :subject => subject)
  end

  def user_commented_on_item_review(commenter, itemreview)
  	subject = "#{commenter.username} commented on your review of #{itemreview.store_item.name}"
  	@commenter = commenter
  	@itemreview = itemreview	
  	#mail(:to => itemreview.user.email, :subject => subject)
  end

  def user_commented_on_post(commenter, post)
  	subject = "#{commenter.username} commented on #{post.title}"
  	@commenter = commenter
  	@post = post
  	#mail(:to => post.user.email, :subject => subject)
  end

end
