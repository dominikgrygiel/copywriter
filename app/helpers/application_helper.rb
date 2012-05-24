module ApplicationHelper

  def facebook_auth_url
    URI.parse(root_url(:subdomain => false)).merge("auth/facebook").to_s
  end

end

