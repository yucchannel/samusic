require 'sinatra'
require 'sinatra/reloader' if development?
require 'fileutils'

UPLOAD_DIR = File.join(settings.public_folder, 'uploads')
FileUtils.mkdir_p(UPLOAD_DIR)

get '/' do
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

# Render の PORT 環境変数を使用
set :port, ENV.fetch('PORT', 4567)
set :bind, '0.0.0.0'
