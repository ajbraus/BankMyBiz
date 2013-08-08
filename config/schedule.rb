# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "#{path}/log/cron.log"
job_type :script, "'#{path}/script/:task' :output"

case @environment
when 'production'
  every 2.hours do
    "rake fs:rebuild"
  end
end

when 'development'
  every 2.hours do
    "rake ts:rebuild"
  end
end

# every 15.minutes do
#   command "rm '#{path}/tmp/cache/foo.txt'"
#   script "generate_report"
# end

# every :sunday, at: "4:28 AM" do
#   runner "Cart.clear_abandoned"
# end

# every :reboot do
#   rake "ts:start"
# end

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
