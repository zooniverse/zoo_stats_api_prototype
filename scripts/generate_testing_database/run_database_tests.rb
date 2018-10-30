require "benchmark"
# Change to env variables
database_size   = ARGV[0]
unless database_size
  database_size = ENV["database_size"]
end
repeat_count    = ARGV[1]
unless repeat_count
  repeat_count  = ENV["repeats"]
end
repeat_count = repeat_count.to_i

# Query variables
time_value     = 1
time_units     = 'seconds'

# test runs
cold = "True"
repeat_count.times do
  time = Benchmark.measure do
    test_user_id = rand(1..1_000_000)
    time_bucket = Event.select("time_bucket('#{time_value} #{time_units}', event_time) AS bucket, count(*)").group("bucket")
    time_bucket.where(user_id: test_user_id, event_type: "classification").load
    time_bucket.where(user_id: test_user_id, event_type: "comment").load
  end
  puts "#{database_size},#{time.real.round(5)},#{cold}"
  cold = "False"
end

# output CSV layout
# database_size,time,cold



## ActiveRecord queries

# select (add SQL code in "")
# Time bucket:          Event.select("time_bucket('1 seconds', event_time) AS bucket, count(*)").group("bucket")

# where (search for matching records)
# Specific where:       Event.where(user_id: 1)
# Between where:        Event.where(user_id: 1..1000)
# In where:             Event.where(event_id: [1, 3, 4, 11])

# other methods
# Bounded selection:    Event.limit(5).offset(30)
# Full count:           Event.all.count
# Group by:             Event.all.group("project_id")
# Attributes:           Event.all.first.attributes.to_yaml
