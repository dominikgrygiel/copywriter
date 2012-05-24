class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :articles
  attr_accessible :name, :provider, :uid

  validates_presence_of :name, :provider, :uid

  def to_s
    name
  end

  def can_edit?(obj)
    articles.find_by_id(obj.id).present?
  end

  def self.from_omniauth(hsh)
    find_by_provider_and_uid(hsh["provider"], hsh["uid"]) || create_with_omniauth(hsh)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

end

