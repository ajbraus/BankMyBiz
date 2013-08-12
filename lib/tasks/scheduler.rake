task :rebuild_index => :environment do
  rake "fs:rebuild"
end

# task :send_reminders => :environment do
#   User.send_reminders
# end