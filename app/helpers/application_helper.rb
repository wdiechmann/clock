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
    # where( 'entrances.clocked_at' => month_range).
    employee.entrances.where( 'entrances.clocked_at' => month_range).each{ |e| dates[e.clocked_at.day]= e }
    (1..month_range.last.day.to_i).each do |day|
      yield day, dates[day]
    end
  end

  def show_date date
    date.strftime '%d/%m/%Y'
  end

end
