module ApplicationHelper

  def show_brand
    if user_signed_in? && current_user.admin?
      return t(:home)
    else
  		home = cookies.permanent.signed[:clock_alco_dk].nil? ? t(:home) : cookies.permanent.signed[:clock_alco_dk]
  		home = user_signed_in? ? current_user.account.name : home
      return home
    end
  rescue
    "Clock"
  end
  
end
