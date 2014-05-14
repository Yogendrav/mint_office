class MigrateImagesForUcloud < ActiveRecord::Migration
  
  def up
    @ucloud = UcloudStorage.new
    files_path = "#{Rails.root}/files"
    if File.directory?(files_path)
      upload_files_in_directory(files_path)
      delete_image_files_and_directories(files_path)
    end
  end

  def down
  end

  # Recursive하게 전송하려 했으나, 사이즈가 조정된 파일들은 어차피 다시 만들어지므로 제외 함.
  # 중복검사는 없으므로 ucloud가 비어있는 상태를 가정하여야함.
  def upload_files_in_directory(directory)
    @ucloud.authorize unless @ucloud.is_authorized?
    Dir.foreach(directory) do |item|
      next if item == '.' or item == '..'
      path = "#{directory}/#{item}"
      if !File.directory?(path)
        @ucloud.upload path, ENV['UCLOUD_BOX'], item
      end
    end
  end

  def delete_image_files_and_directories(directory)
    Dir.foreach(directory) do |item|
      next if item == '.' or item == '..'
      path = "#{directory}/#{item}"
      if File.directory?(path)
        delete_image_files_and_directories(path)
        Dir.rmdir(path)
      else
        File.delete(path)
      end
    end
  end
end
