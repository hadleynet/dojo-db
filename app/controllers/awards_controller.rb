class AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin, only: [:new, :edit, :create, :update, :destroy]

  # GET /awards
  # GET /awards.json
  def index
    @awards = Award.where("date > :date", {date: Date.today-2.months}).order(:date)
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
  end

  # GET /awards/award_for_person/1
  def award_for_person
    @award = Award.new
    @person = Person.find(params[:person_id])
    @current_ranks = Style.active.collect do |style|
      @person.last_promotion(style)
    end.compact
    render :new
  end
  
  # GET /awards/new
  def new
    if params[:person_id]
      @person = Person.find(params[:person_id])
      @current_ranks = Style.active.collect do |style|
        @person.last_promotion(style)
      end.compact
    end
    @award = Award.new
  end

  # GET /awards/1/edit
  def edit
  end

  # POST /awards
  # POST /awards.json
  def create
    @award = Award.new(award_params)

    respond_to do |format|
      if @award.save
        format.html { redirect_to people_path, notice: "#{@award.person.display_name} was promoted to #{@award.rank.name} in #{@award.style.description}." }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1
  # PATCH/PUT /awards/1.json
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to @award, notice: 'Promotion was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to awards_url, notice: 'Promotion was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:date, :person_id, :rank_id)
    end
end
