class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :attendance]

  # GET /people
  # GET /people.json
  def index
    @people = Person.active
  end
  
  def search
    if params[:search]
      @people = Person.search(params[:search])
      @search = params[:search]
    else
      @people = Person.active
    end
    render :index
  end
  
  # GET /people/1/attendance.json
  def attendance
    @data = {
      labels: [],
      datasets: [
        {
          fillColor: "rgba(120,120,120,0.5)",
          strokeColor: "rgba(120,120,120,1)",
          pointColor: "rgba(120,120,120,1)",
          pointStrokeColor: "#fff",
          data: []
        }
      ]
    }
    Attendance.select("strftime('%Y-%m', date) as month, sum(count) as classes").where("person_id=:person AND date>:date", {person: @person.id, date: Date.today-1.year}).group("month").each do |a|
      @data[:labels].append(a.month)
      @data[:datasets][0][:data].append(a.classes)
    end

    respond_to do |format|
      format.html { redirect_to @person }
      format.json { render json: @data }
    end
  end
  
  # GET /people/1
  # GET /people/1.json
  def show
    @awards = @person.awards.order(:date).reverse_order
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
#     @person.destroy
#     respond_to do |format|
#       format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
#       format.json { head :no_content }
#     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:id, :forename, :surname, :birthdate, :active)
    end
end
