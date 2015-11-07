class AttendancesController < ApplicationController
  before_action :verify_is_admin, only: [:attendance, :add, :add_by_session]

  # GET /attendances
  def index
    @date = Date.today
  end

  # GET /attendances/form
  def form
    @date = params[:date] ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i) : Date.today
    if Attendance.non_session_based?(@date)
      @people = Person.active
      @styles = Style.active
      @attendance = {}
      Attendance.where(date: @date).each do |a|
        @attendance[a.person_id] ||= {}
        @attendance[a.person_id][a.style_id] = a.count
      end
      render :attendance
    else
      @people = Person.active
      @sessions = Session.for_day(@date.cwday)
      @attendance = {}
      Attendance.where(date: @date).each do |a|
        @attendance[a.person_id] ||= {}
        @attendance[a.person_id][a.session_id] = a.count > 0 ? true : false
      end
      render :form
    end
  end
  
  # GET /attendances/month
  def month
    start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1)
    end_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, -1)
    @people = Person.active
    @dates = (start_date..end_date).select do |date|
      Session.for_day(date.cwday).length > 0
    end
  end

  # Handle POST from new session-based form
  def add_by_session
    @date = Date.parse(params["date"])
    Session.for_day(@date.cwday).each do |session|
      params["attendance_#{session.id}"].each do |attendance|
        count = attendance["count"].to_i
        a = Attendance.where(date: @date, person_id: attendance["person"], session: session).first_or_initialize
        if count > 0
          a.count = count
          a.style = session.style
          a.save
        elsif a.count
          # remove the old attendance entry, don't want any with class count of zero
          a.delete
        end
      end
    end
    flash[:notice] = 'Attendance Saved'
    render :index
  end
  
  # Handle POST from original attendance form
  def add
    @date = Date.parse(params["date"])
    Style.active.each do |style|
      params["attendance_#{style.id}"].each do |attendance|
        count = attendance["count"].to_i
        a = Attendance.where(date: @date, person_id: attendance["person"], style: style).first_or_initialize
        if count > 0
          a.date = @date
          a.person_id = attendance["person"]
          a.count = count
          a.save
        elsif a.count
          # remove the old attendance entry, don't want any with class count of zero
          a.delete
        end
      end
    end
    flash[:notice] = 'Attendance Saved'
    render :index
  end
    
end