class Plan < ActiveRecord::Base
  include Koudoku::Plan
  belongs_to :user
  belongs_to :coupon
  has_many :subscriptions

end
