class Category < ActiveRecord::Base
  has_many :articles
  attr_accessible :name, :subdomain

  def to_s
    name
  end

end

