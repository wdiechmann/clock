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
    @month_range = Date.today.at_beginning_of_month..Date.today.at_end_of_month
    # Account.all.each do |account|
    #
    #   employees = Employee.where( account: self ).joins(:entrances).where('entrances.clocked_at' => month_range)
    #   render_to_string 'month_list.html.haml', locals: { employees: employees, month_range: month_range }
    #
    # end

    @employees = current_user.account.employees.all.includes(:entrances).where( 'entrances.clocked_at' => @month_range).order('employees.id','entrances.clocked_at')

    respond_to do |format|
      format.html #{}
    end
  end
  
end
