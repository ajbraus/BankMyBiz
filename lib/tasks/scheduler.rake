task :rebuild_index => :environment do
  Post.rebuild_index
end

# task :send_reminders => :environment do
#   User.send_reminders
# end