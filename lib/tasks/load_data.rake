require 'json'

task :load_data => [:libraries] do

end

task :libraries => :environment do
  puts "===================================================="
  puts "Creating Organizations with Library Data and saving to DB"
  puts "===================================================="

  data = JSON.parse(File.open('data/libraries_data.json','r').read).values
  data.each do |json_library|
    Organization.create! do |db_library|
      json_library.keys.each do |field|
        db_library[field] = json_library[field.to_s]
      end
    end
  end
  puts "DONE."
end