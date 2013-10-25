# task :rebuild_index => :environment do
#   rake "fs:rebuild"
# end

task :set_peers_and_matches => :environment do
  User.set_peers_and_matches
end

task :clean_up_peers_and_matches => :environment do
  User.clean_up_peers_and_matches
end

task :send_profile_reminders => :environment do
  User.send_profile_reminders
end