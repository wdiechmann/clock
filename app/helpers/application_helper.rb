module ApplicationHelper

  def show_brand
		home = cookies.permanent.signed[:clock_alco_dk].nil? ? t(:home) : cookies.permanent.signed[:clock_alco_dk]
		home = current_user ? current_user.account.name : home
    link_to( home, root_url, class: 'navbar-brand')
  end
  
end
