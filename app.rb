require 'sinatra'
require 'sinatra/reloader' if development?
require 'fileutils'

# アップロード先
UPLOAD_DIR = File.join(settings.public_folder, 'uploads')
FileUtils.mkdir_p(UPLOAD_DIR)

get '/' do
  # アップロード済みの曲一覧
  @songs = Dir.glob("#{UPLOAD_DIR}/*").map { |f| File.basename(f) }
  erb :index
end

post '/upload' do
  if params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    path = File.join(UPLOAD_DIR, name)
    File.open(path, 'wb') { |f| f.write(tmpfile.read) }
    redirect '/'
  else
    "ファイルを選択してください"
  end
end
