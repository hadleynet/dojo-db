namespace :json do

  desc "Export DB to JSON"
  task :dump, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    ['Color', 'Style', 'Test', 'Rank', 'Person', 'Session', 'Award', 'Attendance', 'User'].each do |model|
      File.open(File.join(path, "#{model}.json"), 'w') do |file|
        items = model.constantize.all.collect {|item| item.attributes}
        JSON.dump(items, file)
      end
    end
  end

  desc "Import DB from JSON"
  task :load, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    ['Color', 'Style', 'Test', 'Rank', 'Person', 'Session', 'Award', 'Attendance', 'User'].each do |model|
      File.open(File.join(path, "#{model}.json"), 'r') do |file|
        JSON.load(file).each do |item|
          model.constantize.new(item).save
        end
      end
    end
  end

end