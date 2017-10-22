require 'aws-sdk'

s3 = Aws::S3::Resource.new(
    region: ENV['S3_REGION'],
    access_key_id: ENV['ACCESS_KEY_ID'],
    secret_access_key: ENV['SECRET_ACCESS_KEY']
)

#s3.bucket(ENV['S3_BUCKET']).object('videos/Hola Colombia__9876543__.avi').get(response_target: '/home/ubuntu/Hola Colombia__9876543__.avi')

# obj = s3.bucket(ENV['S3_BUCKET']).object('videos/Hola Colombia__9876543__.avi')
# obj.upload_file('/home/ubuntu/Hola Colombia__9876543__.avi')

def convert_to_mp4(path)
  puts "convert to mp4 #{path}"
  download_video(path)
  movie = FFMPEG::Movie.new(path)
  new_path = ENV[VIDEO_CONVERTED] + File.basename(path,File.extname(path))
  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 10 -threads 10))
  upload_video(path)
  new_path = '';
  return new_path
end

def download_video(path)
  s3.bucket(ENV['S3_BUCKET']).object("#{ENV['S3_UPLOADS_FOLDER']+path}").get(response_target: "#{ENV[VIDEO_UPLOAD]+path}")
end

def upload_video(path)
  obj = s3.bucket(ENV['S3_BUCKET']).object("#{ENV['S3_CONVERTED_FOLDER']+path}")
  obj.upload_file("#{ENV[VIDEO_CONVERTED]+path}")

end

convert_to_mp4('Hola Colombia__9876543__.avi')