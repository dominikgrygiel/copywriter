class Article < ActiveRecord::Base
  belongs_to :category
  attr_accessible :content, :title, :category_id, :user_id

  validates_presence_of :title, :category, :content
end
