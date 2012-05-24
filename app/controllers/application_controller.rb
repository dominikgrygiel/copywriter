class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :find_categories

private
  def find_categories
    @categories = Category.all
  end

  helper_method :current_user, :signed_in?
  def current_user
    @user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def login_required
    redirect_to root_url and return unless signed_in?
  end

end

