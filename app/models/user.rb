class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :articles
  attr_accessible :name, :provider, :uid

  def to_s
    name
  end

end

