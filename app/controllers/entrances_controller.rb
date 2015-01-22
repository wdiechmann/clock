class EntrancesController < ApplicationController
  before_action :set_entrance, only: [:show, :edit, :update, :destroy]
  before_action :set_entrances, only: :index
  # GET /entrances
  # GET /entrances.json
  def index
    @entrances = Entrance.where( employee: current_user.account.employees.map(&:id))
  end

  # GET /entrances/1
  # GET /entrances/1.json
  def show
  end

  # GET /entrances/new
  def new
    @entrance = Entrance.new
  end

  # GET /entrances/1/edit
  def edit
  end

  # POST /entrances
  # POST /entrances.json
  def create
    if params[:multi]=='true'
      #
      # {"type"=>"free new_selected", "employee"=>"1", "month"=>"1", "day"=>"5", "entrance"=>"0"}
      #
      entrances = []
      params['elems'].each do |k,elem|
        etype = ENTRANCE_TYPES.index( elem[:type].gsub( /selected/,'').strip.split(" ")[0].strip)
        if elem[:entrance]=="0"
          Entrance.create( clocked_at: Date.new( Date.today.year, elem[:month].to_i, elem[:day].to_i), employee_id: elem[:employee], entrance_type: etype)
        else
          entrance = Entrance.find(elem[:entrance])
          if elem[:type] =~ /deleted/
            entrance.entrance_type = -1
          else
            entrance.entrance_type = etype
          end
          entrances << entrance
        end
      end
      entrances.sort.each do |entrance|
        if entrance.entrance_type == -1
          entrance.destroy
        else
          entrance.save
        end
      end

      respond_to do |format|
        format.html
        format.js   { render text: 'alt er opdateret'}
      end

    else
      entrance_params[:entrance_type] = PRESENT
      @entrance = Entrance.new(entrance_params)
      respond_to do |format|
        if @entrance.save
          format.html { redirect_to @entrance, notice: 'Entrance was successfully created.' }
          format.json { render :show, status: :created, location: @entrance }
        else
          format.html { render :new }
          format.json { render json: @entrance.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /entrances/1
  # PATCH/PUT /entrances/1.json
  def update
    respond_to do |format|
      if @entrance.update(entrance_params)
        format.html { redirect_to @entrance, notice: 'Entrance was successfully updated.' }
        format.json { render :show, status: :ok, location: @entrance }
      else
        format.html { render :edit }
        format.json { render json: @entrance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entrances/1
  # DELETE /entrances/1.json
  def destroy
    @entrance.destroy
    respond_to do |format|
      format.html { redirect_to entrances_url, notice: 'Entrance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entrance
      @entrance = Entrance.find(params[:id])
    end

    def set_entrances
      if request.path =~ /employees/
        @entrances = Employee.find(params[:employee_id]).entrances.order(clocked_at: :desc)
      else
        @entrances = Entrance.all
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entrance_params
      params.require(:entrance).permit(:employee_id, :clocked_at, :entrance_type)
    end
end
