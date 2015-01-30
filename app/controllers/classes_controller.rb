class ClassesController < ApplicationController

  # GET /classes
  def index
    @date = Date.today
  end

  # GET /classes/attendance
  def attendance
    @people = Person.active
    @styles = Style.all
    @date = params[:date] ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i) : Date.today
    @attendance = {}
    Attendance.where(date: @date).each do |a|
      @attendance[a.person_id] ||= {}
      @attendance[a.person_id][a.style_id] = a.count
    end
  end
  
  def add
    date = Date.parse(params["date"])
    Style.all.each do |style|
      params["attendance_#{style.id}"].each do |attendance|
        count = attendance["count"].to_i
        if count > 0
          a = Attendance.where(date: date, person_id: attendance["person"], style: style).first_or_initialize
          a.count = count
          a.save
        end
      end
    end
    render :index
  end
    
end