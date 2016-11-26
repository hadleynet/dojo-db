class ReportsController < ApplicationController

  # GET /reports
  def index
  end

  # GET /reports/promotions_due
  def promotions_due
#    styles = Style.active
    @date = Date.today
    styles = [Style.shorin_ryu]
    @promotable_without_test_by_style = styles.map do |style|
      [style, Person.all_promotable(style, Test.none, Test.informal)]
    end
  end

  # GET /reports/tests_due
  def tests_due
    styles = Style.active
    @promotable_with_test_by_style = styles.map do |style|
      [style, Person.all_promotable(style, Test.formal)]
    end
  end

  def recent_promotions
    recent_promotions = Award.since(Date.today-2.months)
    @promotions = recent_promotions.collect do |promotion|
      rank = promotion.rank
      prev_rank = promotion.person.rank_prior_to(promotion)
      {
        person: promotion.person,
        date: promotion.date,
        rank: rank,
        prev_rank: prev_rank,
        cert: rank.test_needed_from(prev_rank),
        belt: (prev_rank==nil && rank.belt_color!=Color.white) || (prev_rank && rank.belt_color != prev_rank.belt_color)
      }
    end
  end
  
  def promotions_by_date_form
    @date = Date.today
  end
  
  def promotions_by_date
    @date = params[:date] ? Date.new(params[:date][:year].to_i, params[:date][:month].to_i) : Date.today    
    attendees_in_month = Attendance.joins(:person)
    promotions_in_month = Award.joins(:person)
      .where("to_char(awards.date, 'YYYY-MM')=:month", {month: @date.strftime('%Y-%m')})
      .order('awards.date', 'people.surname', 'people.forename')
      .to_a
    @full_rank_promotions = []
    @stripe_promotions = []
    @teaching_promotions = []
    promotions_in_month.each do |p|
      rank = p.rank
      if p.rank.style == Style.teaching
        @teaching_promotions.append(p)
      else
        prev_rank = p.person.rank_prior_to(p)
        if rank.test_needed_from(prev_rank)
          @full_rank_promotions.append(p)
        else
          @stripe_promotions.append(p)
        end
      end
    end
  end
  
  def dues_by_date_form
  end
  
  def dues_by_date
    @date = params[:month] ? Date.strptime(params[:month], '%m/%Y') : Date.today
    attendees_in_month = Person.joins(:attendances)
      .where("to_char(attendances.date, 'YYYY-MM')=:month", {month: @date.strftime('%Y-%m')})
      .distinct
      .order('people.surname', 'people.forename')
      .to_a
    promotions_in_month = Award.joins(:person)
      .where("to_char(awards.date, 'YYYY-MM')=:month", {month: @date.strftime('%Y-%m')})
      .order('awards.date', 'people.surname', 'people.forename')
      .to_a
    new_cert_promotions_in_month = {}
    new_belt_promotions_in_month = {}
    promotions_in_month.each do |promotion|
      new_rank = promotion.rank
      person = promotion.person
      prev_rank = person.rank_prior_to(promotion)
      if new_rank.style != Style.teaching
        if new_rank.test_needed_from(prev_rank)
          new_cert_promotions_in_month[person] ||= []
          new_cert_promotions_in_month[person].append(promotion)
          if new_rank.belt_color != prev_rank.belt_color
            new_belt_promotions_in_month[person] ||= []
            new_belt_promotions_in_month[person].append(promotion)
          end
        end
      end
    end
    @dues = attendees_in_month.map do |attendee|
      {person: attendee, certs: new_cert_promotions_in_month[attendee] || [], belts: new_belt_promotions_in_month[attendee] || []}
    end

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"svkc_dues_#{@date.strftime('%Y%m')}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
  
  def attendance
    periods = [6, 3, 1]
    @date = Date.today
    @attendance = Person.active.collect do |person|
      [person, periods.collect {|period| person.all_classes_since(Date.today-period.months)}]
    end
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"attendance.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
  
  def teachers
    @date = Date.today
    @teachers = Person.active.collect do |person|
      {:person => person, :last_teaching_promotion => person.last_teaching_promotion, :days_taught_last_year => person.days_teaching_since(Date.today - 1.year)}
    end
    @teachers = @teachers.select {|teacher| teacher[:days_taught_last_year] > 0}
  end
  
  def active_students
    @date = Date.today
    @styles = Style.active
    @people = Person.active.collect do |person|
      {
        person: person,
        classes_in_last_three_months: person.all_classes_since(@date-3.months),
        latest_awards: @styles.collect {|style| person.last_promotion(style)}
      }
    end
  end
  
  def service_length
    @date = Date.today
    @people = Person.active.collect do |person|
      {
        person: person,
        start_date: person.start_date
      }
    end
    @people.sort_by! {|person| person[:start_date]}
  end
  
end
