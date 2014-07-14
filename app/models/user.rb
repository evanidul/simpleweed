class User < ActiveRecord::Base
	rolify

	# user can follow 
	acts_as_follower
	# user may be followed
	acts_as_followable

	# users may flag objects
	make_flagger
	# users may only flag an object once
	make_flagger :flag_once => true

	include PublicActivity::Common    

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable, :confirmable, :authentication_keys => [:login]

 	# Virtual attribute for authenticating by either username or email
  	# This is in addition to a real persisted field like 'username'
  	attr_accessor :login         

	def login=(login)
		@login = login
	end

	def login
		@login || self.username || self.email
	end

	def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

	validates :username,
  		:uniqueness => {
	    :case_sensitive => false
	}

end
