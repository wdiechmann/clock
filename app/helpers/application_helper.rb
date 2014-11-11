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

  def list_every_day employee, month_range, &block
    dates = []
    employee.entrances.map(&:clocked_at).each{ |d| dates[d.day]= d }
    (1..month_range.last.day.to_i).each do |day|
      yield day, dates[day]
    end
  end
    
end
