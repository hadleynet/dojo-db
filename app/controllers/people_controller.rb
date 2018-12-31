class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :attendance, :promote, :deactivate]
  before_action :verify_is_admin, only: [:new, :edit, :create, :update, :destroy, :deactivate]

  # GET /people
  # GET /people.json
  def index
    @people = Person.active
  end
  
  def search
    if params[:search_field]
      @people = Person.search(params[:search_field])
      @search = params[:search_field]
    else
      @people = Person.active
    end
    render :index
  end
  
  # GET /people/1/promote
  def promote
    redirect_to new_award_path(person_id: @person)
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
    
    # for SQLite3
#     attendance = Attendance.select("strftime('%Y-%m', date) as month, sum(count) as classes").where("person_id=:person AND date>:date", {person: @person.id, date: Date.today-14.months}).group("month").to_a
    # for Postgres
    attendance = Attendance.select("to_char(date, 'YYYY-MM') as month, sum(count) as classes").where("person_id=:person AND date>:date AND style_id != :teaching_id", {person: @person.id, date: Date.today-14.months, teaching_id: Style.teaching.id}).group("month").to_a

    now = Date.today
    m = now.month
    y = now.year-1
    for i in 1..12 do
      d = Date.new(y, m)
      label = d.strftime('%Y-%m')
      @data[:labels].append(label)
      @data[:datasets][0][:data].append(get_class_count(attendance, label))
      m = m+1
      if m==13
        m=1
        y=y+1
      end
    end

    respond_to do |format|
      format.html { redirect_to @person }
      format.json { render json: @data }
    end
  end
  
  # GET /people/1
  # GET /people/1.json
  def show
    @date = Date.today
    @awards = @person.styles.collect do |style_id|
      style = Style.find(style_id)
      awards = Award.for_person_and_style(@person, style)
      if awards.length > 10
        significant_awards = []
        for i in 1..awards.length-2
          if awards[i].rank.test_needed_from(awards[i+1].rank)
            significant_awards.append(awards[i])
          end
        end
        significant_awards.prepend(awards.first)
        awards = significant_awards
      end
      [style, awards]
    end
    @total_classes = @person.all_classes
    @total_classes_this_year = @person.all_classes_since(@date-1.year)
    @start_date = @person.start_date
  end

  # GET /people/new
  def new
    @person = Person.new
    @person.active = true
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    Person.transaction do
      @person = Person.new(person_params)
      @success = @person.save
      if @success && params[:initial_rank] && params[:initial_rank][:rank_id]
        initial_promotion = Award.new
        initial_promotion.person = @person
        initial_promotion.date = Date.today
        initial_promotion.rank = Rank.find(params[:initial_rank][:rank_id])
        initial_promotion.save
      end
    end

    respond_to do |format|
      if @success
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
  
  def deactivate
    @person.active = false
    @person.save
    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to), notice: "#{@person.display_name} was deactivated"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:id, :forename, :surname, :birthdate, :active, :belt_size)
    end
    
    def get_class_count(attendance, label)
      count = 0
      attendance.each do |a|
        count = a.classes if a.month==label
      end
      count
    end
end
