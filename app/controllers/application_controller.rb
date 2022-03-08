class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  skip_before_action :login_required, only: [:new, :create], raise: false

  private
  def login_required
      redirect_to new_session_path unless current_user
  end
end