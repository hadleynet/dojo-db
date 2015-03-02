class AttendancesController < ApplicationController

  # GET /attendances
  def index
    @date = Date.today
  end

  # GET /attendances/attendance
  def attendance
    @people = Person.active
    @styles = Style.active
    @date = params[:date] ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i) : Date.today
    @attendance = {}
    Attendance.where(date: @date).each do |a|
      @attendance[a.person_id] ||= {}
      @attendance[a.person_id][a.style_id] = a.count
    end
  end
  
  # GET /attendances/form
  def form
    @people = Person.active
    @date = params[:date] ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i) : Date.today
    @sessions = Session.for_day(@date.cwday)
  end
  
  def add
    date = Date.parse(params["date"])
    Style.active.each do |style|
      params["attendance_#{style.id}"].each do |attendance|
        count = attendance["count"].to_i
        a = Attendance.where(date: date, person_id: attendance["person"], style: style).first_or_initialize
        if count > 0
          a.date = date
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
    @date = date
    render :index
  end
    
end