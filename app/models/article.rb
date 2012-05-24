class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category
  belongs_to :user
  attr_accessible :content, :title, :category_id, :user_id

  validates_presence_of :title, :category, :content, :user_id

end

