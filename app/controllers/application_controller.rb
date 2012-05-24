class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :find_categories

private
  def find_categories
    @categories = Category.all
  end

  helper_method :current_user
  def current_user
    User.first
  end

end

