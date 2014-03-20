class StoreItem < ActiveRecord::Base
  belongs_to :store
  validates :name, presence: true
end
