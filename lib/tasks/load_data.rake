require 'json'

task :load_data => [:libfarm, :latlon2coord, :coord2latlon] do

end

task :libfarm => :environment do
  puts "================================================================================"
  puts "Creating Organizations with Library and Farmers' Markets Data and saving to DB"
  puts "================================================================================"

  files = ['data/libraries_data.json', 'data/smc_farmers_markets.json']
  files.each do |file|
    puts "Processing #{file}"
    invalid_records = {}
    invalid_filename_prefix = file.split('.json')[0].split('/')[1]
    dataset = JSON.parse(File.read(file)).values
    dataset.each do |data_item|
      org = Organization.new(data_item)
      unless org.save
        name = org["name"]
        invalid_records[name] = {}
        invalid_records[name]["errors"] = org.errors
        File.open("data/#{invalid_filename_prefix}_invalid_records.json","w") do |f|
          f.write(invalid_records.to_json)
        end
      end
    end
    puts "Done loading #{file} into DB"
  end
  puts "Done loading libraries and farmers' markets into DB."
end

task :latlon2coord => :environment do
  orgs = Organization.all
  orgs.each do |org|
    org.update_attribute(:coordinates, [org.longitude, org.latitude]) if org.coordinates.blank?
  end
end

task :coord2latlon => :environment do
  orgs = Organization.all
  orgs.each do |org|
    if org.coordinates.present? && (org.latitude.blank? && org.longitude.blank?)
      org.update_attribute(:latitude, org.coordinates[1])
      org.update_attribute(:longitude, org.coordinates[0])
    end
  end
end