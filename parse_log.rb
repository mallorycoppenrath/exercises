require 'pry'

file = File.open("Desktop/log.log", "r")
contents = file.read

def errors(contents)
  logs = contents.tr('"', "'").split("\n")
  errors = []
  logs.each do |log|
    split_log = log.split(" ")
    split_log.each do |line|
    if line == "status=404"
      error_log = split_log.join(" ")
      errors << error_log
    end
    end
  end
  return errors
end

def paths_with_count(contents)
  files = errors(contents)
  stripped_paths = files.uniq.flatten.map {|url| url.tr("'", "")}
    urls = stripped_paths.map do |file|
    file.split(" ").select {|file| file.start_with?('path')}
end
  puts hash = urls.each_with_object(Hash.new(0)) { |file, count| count[file] += 1 }
end

# path='/api/accounts/3' and path=/api/accounts/3 counted as separate keys, different 

def avg_server_time(contents) #avg serve time for all log entries, not just where 404
  logs = contents.split("\n")
    service = logs.map do |log|
      log.split(" ").select {|piece| piece.start_with?('service')}
  end
  time = service.flatten.map do |ms|
    ms.gsub(/[^\d]/,"").to_i
  end
  avg = (time.inject(0) {|sum, i|  sum + i }) / (time.count)
  puts avg.to_s + "ms"
  #assumes all time is in ms
end

def most_frequent_table(contents)
  logs = contents.split("\n")
  table_load = logs.select do |log|
    log.include?("FROM") == true
end
  split = table_load.map do |log|
    log.split("FROM")[1].split(" ")[0].tr('^A-Za-z0-9', '')
  end
  count = split.each_with_object(Hash.new(0)) { |table, count| count[table] += 1 }
  puts count.key(count.values.max) #returns key (table) with highest value (times it shows up in log file)
end

def redirect?(contents)
  logs = contents.split("\n")
  redirects = logs.select do |log|
    log.include?("status=302") == true || log.include?("status=301") == true
  end
  if redirects.count > 0 
    puts "There are #{redirects.count} redirects in this log."
  end
  return redirects
end

def server_errors?(contents)
  logs = contents.split("\n")
    server_errors = logs.select do |log|
    log.include?("status=500") == true || log.include?("status=503") == true
  end
  if server_errors.count > 0 
    puts "There are #{server_errors.count} server errors in this log."
  end
  return server_errors
end

errors(contents)
paths_with_count(contents)
avg_server_time(contents)
most_frequent_table(contents)
redirect?(contents)
server_errors?(contents)