module Admin::UsersHelper
  def admin?
    current_user.admin if logged_in?
  end
  def choose_admin_path
    if action_name == "new"
      admin_users_path
    else
      admin_user_path(@user.id)
    end
  end
end