class VisitorsController < ApplicationController
  
  def index
    if current_user.nil?
      if cookies.permanent.signed[:punch_clock].nil?
        @punch_clocks = []
      else
        @punch_clocks = PunchClock.where id: cookies.permanent.signed[:punch_clock]
      end
    else
      @punch_clocks = current_user.admin? ? [] : current_user.account.punch_clocks
    end
  end
  
  
  def month_list
    first_date = Date.today.at_beginning_of_month
    last_date = Date.today.at_end_of_month
    @month_range = (first_date.to_time .. last_date.to_time)
    # Account.all.each do |account|
    #
    #   employees = Employee.where( account: self ).joins(:entrances).where('entrances.clocked_at' => month_range)
    #   render_to_string 'month_list.html.haml', locals: { employees: employees, month_range: month_range }
    #
    # end

    @employees = current_user.account.employees.all.joins(:entrances).where('entrances.clocked_at' => @month_range)
    
    respond_to do |format|
      format.html #{}
    end
  end
  
end
