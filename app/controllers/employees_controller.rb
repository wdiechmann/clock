class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy, :last_seen]
  # before_filter :authenticate_user!
  # after_action :verify_authorized


  # GET /employees/1/last_seen
  def last_seen
    @employee.entrances.where('clocked_at between ? and ?', DateTime.now.at_beginning_of_day,DateTime.now.at_end_of_day).destroy_all
    entrance = Entrance.create( employee: @employee, clocked_at: DateTime.parse(params[:at]))
    @employee.update_attributes( last_seen: entrance.clocked_at)
    entrance.update_attributes entrance_type: PRESENT
    head(:ok) and return if entrance
    head(404)
  end

  def month_list
    @month_range = Date.today.at_beginning_of_month..Date.today.at_end_of_month
    # Account.all.each do |account|
    #
    #   employees = Employee.where( account: self ).joins(:entrances).where('entrances.clocked_at' => month_range)
    #   render_to_string 'month_list.html.haml', locals: { employees: employees, month_range: month_range }
    #
    # end
    # @employees = current_user.account.employees.joins('LEFT OUTER JOIN entrances ON entrances.employee_id=employees.id').where( 'entrances.clocked_at' => @month_range).order('employees.id','entrances.clocked_at')
    # d1 = Date.today.at_beginning_of_month.to_s
    # d2 = Date.today.at_end_of_month.to_s
    # @employees = Employee.find_by_sql("
    #   SELECT `employees`.`id` AS t0_r0, `employees`.`name` AS t0_r1, `employees`.`last_seen` AS t0_r2, `employees`.`created_at` AS t0_r3, `employees`.`updated_at` AS t0_r4, `employees`.`punch_clock_id` AS t0_r5, `employees`.`account_id` AS t0_r6, `employees`.`born_at` AS t0_r7, `entrances`.`id` AS t1_r0, `entrances`.`employee_id` AS t1_r1, `entrances`.`clocked_at` AS t1_r2, `entrances`.`created_at` AS t1_r3, `entrances`.`updated_at` AS t1_r4, `entrances`.`entrance_type` AS t1_r5
    #   FROM `employees`
    #   LEFT OUTER JOIN `entrances` ON `entrances`.`employee_id` = `employees`.`id` AND (`entrances`.`clocked_at` BETWEEN '"+d1+"' AND '"+d2+"')
    #   WHERE `employees`.`account_id` = " + current_user.account.id.to_s + "
    #   ORDER BY employees.id, entrances.clocked_at"
    # )
    #
    #
    #
    # @employees = current_user.account.employees.joins('LEFT OUTER JOIN `entrances` ON `entrances`.`employee_id` = `employees`.`id` AND (`entrances`.`clocked_at` BETWEEN "'+d1+'" AND "'+d2+'")')
    #.includes(:entrances_in_month_range)#.where( 'entrances.clocked_at' => @month_range).order('employees.id','entrances.clocked_at')
    # @employees = @employees.order('employees.id','entrances.clocked_at')
    @employees = current_user.account.employees.includes(:entrances)
    @employees = current_user.account.employees.
    joins("left outer join entrances on entrances.id is NULL or (entrances.clocked_at between '"+@month_range.min.to_s+"' and '"+@month_range.min.to_s+"')")

    respond_to do |format|
      format.html #{}
    end
  end


  # GET /employees
  # GET /employees.json
  def index
    if params[:format]=='js'
      if cookies.permanent.signed[:punch_clock].nil? || PunchClock.where(id: cookies.permanent.signed[:punch_clock]).empty?
        @employees = []
      else
        pc = PunchClock.find(cookies.permanent.signed[:punch_clock])
        @employees = pc.employees + Employee.where( account: pc.account, punch_clock: nil )
      end
    else
      if user_signed_in? && current_user.admin?
        @employees = Employee.all
      else
        @employees = params[:punch_clock_id].nil? ? current_user.account.employees : PunchClock.find(params[:punch_clock_id]).employees
      end
    end

    respond_to do |format|
      format.html # {}
      format.js
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.js   { head :no_content }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params[:employee][:account_id]=current_user.account.id
      params.require(:employee).permit(:name, :punch_clock_id,:account_id, :born_at)
    end
end
