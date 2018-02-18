class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :admin_dashboard_version
  before_action :set_cart, :set_categories, :authorize!

  def current_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def set_categories
    @categories = Category.all
  end

  def not_found
    render file: '/public/404', status: 404
  end

  private

  def authorize!
    not_found unless current_permission.authorized?
  end

  def current_permission
    @current_permission ||= Permission.new(current_user, params[:controller], params[:action])
  end
end
