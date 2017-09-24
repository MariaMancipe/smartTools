require 'streamio-ffmpeg'
require 'mysql2'

$original = "#{ENV['VIDEO_ORIGINAL']}"
$converted = "#{ENV['VIDEO_CONVERTED']}"
$upload = "#{ENV['VIDEO_UPLOAD']}"

def move_upload_to_original(path)
  new_path = File.basename(path)
  File.rename(path, "./public/video/original/#{new_path}")
end

def convert_to_mp4(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  converted = "./public/video/converted/"
  new_path = File.basename(path)
  new_path = $converted+ new_path[0,new_path.length-4]

  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 1 -threads 1))
  #move_upload_to_original(path)
end

def search_files

  Dir.mkdir($original) unless File.exist?($original)
  Dir.mkdir($converted) unless File.exist?($converted)
  Dir.entries($upload).select {|f| convert_to_mp4($upload+f) unless File.directory?(f)}
end

def send_emails

end

def search_emails
  connect = Mysql2::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}")
  #connect = Mysql2::Client.new(:host => , :username => "smarttools", :password => "smarttools", :database => "smarttools")
  #connect = Mysql2.new("smarttools.ckojm8kxu6a7.us-east-1.rds.amazonaws.com", "smarttools", "smarttools", "smarttools")
  result = connect.query("SELECT * FROM video")
  result.each {|x| puts x }
  connect.close

end

search_files
