require 'CSV'

namespace :import do

  desc "Import ranks from CSV"
  task :ranks, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    CSV.foreach(path) do |row|
      rank = Rank.where(id: row[0].to_i).first_or_initialize
      rank.name = row[2]
      rank.translation = row[1]
      rank.class_delta = row[3].to_i
      rank.order = row[4].to_i
      rank.next_rank_test = row[5]=='Y' ? Test.find(2) : Test.find(1)
      rank.style = Style.find(row[6].to_i)
      rank.active = row[8]=='Y' ? true : false
      rank.belt_color = Color.find(1)
      rank.stripe_color = Color.find(1)
      rank.stripe_count = 0
      rank.save
    end
  end
  
  desc "Import people from CSV"
  task :people, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    CSV.foreach(path) do |row|
      person = Person.where(id: row[0].to_i).first_or_initialize
      person.forename = row[3]
      person.surname = row[2]
      if row[4]
        date = row[4].split(' ')[0]
        month,day,year = date.split('/')
        person.birthdate = Date.new(year.to_i,month.to_i,day.to_i)
      end
      person.active = row[6]=='Y' ? true : false
      person.save
    end
  end

  desc "Import awards from CSV"
  task :awards, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    CSV.foreach(path) do |row|
      person_id = row[0].to_i
      rank_id = row[1].to_i
      style_id = row[2].to_i
      award_date = nil
      if row[3]
        date = row[3].split(' ')[0]
        month,day,year = date.split('/')
        award_date = Date.new(year.to_i,month.to_i,day.to_i)
      end
      award = Award.where(date: award_date, person_id: person_id, rank_id: rank_id).first_or_initialize
      award.date = award_date
      award.person = Person.find(person_id)
      award.rank = Rank.find(rank_id)
      award.save
    end
  end

  desc "Import attendance from CSV"
  task :attendance, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    CSV.foreach(path) do |row|
      person_id = row[0].to_i
      class_date = nil
      if row[1]
        date = row[1].split(' ')[0]
        month,day,year = date.split('/')
        class_date = Date.new(year.to_i,month.to_i,day.to_i)
      end
      style_id = row[2].to_i
      count = row[3].to_i
      attendance = Attendance.where(date: class_date, person_id: person_id, style_id: style_id).first_or_initialize
      attendance.date = class_date
      attendance.person_id = person_id
      attendance.style_id = style_id
      attendance.count = count
      attendance.save
    end
  end

end