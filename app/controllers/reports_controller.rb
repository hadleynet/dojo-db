class ReportsController < ApplicationController

  # GET /reports
  def index
  end

  # GET /reports/promotions_due
  def promotions_due
    styles = [1,2].collect {|style_id| Style.find(style_id)}
    @promotable_without_test_by_style = styles.map do |style|
      [style, Person.all_promotable(style, Test::None, Test::Informal)]
    end
    @promotable_with_test_by_style = styles.map do |style|
      [style, Person.all_promotable(style, Test::Formal)]
    end
  end

  def recent_promotions
    recent_promotions = Award.since(Date.today-1.month)
    @promotions = recent_promotions.collect do |promotion|
      rank = promotion.rank
      prev_rank = promotion.person.rank_prior_to(promotion)
      {
        person: promotion.person,
        date: promotion.date,
        rank: rank,
        prev_rank: prev_rank,
        cert: rank.test_needed_from(prev_rank),
        belt: (prev_rank==nil && rank.belt_color!=Color::White) || (prev_rank && rank.belt_color != prev_rank.belt_color)
      }
    end
  end
  
  def attendance
    periods = [6, 3, 1]
    @attendance = Person.active.collect do |person|
      [person, periods.collect {|period| person.all_classes_since(Date.today-period.months)}]
    end
  end
end
