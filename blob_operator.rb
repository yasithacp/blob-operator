BEGIN {
  require "azure"
  Azure.config.storage_account_name = "account"
  Azure.config.storage_access_key = "xxxxxxxxxxxxxxx+xxxxxxxxxxxxxxxx/xxxx+xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=="
  CONTAINER = "container"
  AZURE_BLOB_SERVICE = Azure::BlobService.new

  def download(blob_name, output_file)
    blob, content = AZURE_BLOB_SERVICE.get_blob(CONTAINER,blob_name)
    File.open(output_file,"wb") {|f| f.write(content)}
    puts blob_name + " downloaded succesfully.."
  end

  def upload(input_path, blob_name)
    content = File.open(input_path, "rb") { |file| file.read }
    blob = AZURE_BLOB_SERVICE.create_block_blob(CONTAINER,
      blob_name, content)
    puts blob.name + " uploaded succesfully.."
  end

  def delete(blob_name)
    AZURE_BLOB_SERVICE.delete_blob(CONTAINER, blob_name)
    puts blob_name + " deleted succesfully.."
  end

  def list()
    containers = AZURE_BLOB_SERVICE.list_containers()
    containers.each do |container|
      blobs = AZURE_BLOB_SERVICE.list_blobs(container.name)
      blobs.each do |blob|
        puts blob.name
      end
    end
  end
}

# quit unless the script gets operation to be performed
if ARGV.length < 1
  puts "Please provide the operation to be performed"
  puts "Usage: [get] | [put] | [delete]"
  exit
end

operation = ARGV[0]

unless ['get', 'put', 'delete'].include? operation
  puts "Please provide the valid operation"
  puts "Usage: [get] | [put] | [delete]"
  exit
end

if operation == "get"
  unless ARGV.length == 3
    puts "Invalid params"
    puts "Usage: [get] [blob_name] [output_file]"
    exit
  end
  download(ARGV[1], ARGV[2])
end

if operation == "put"
  unless ARGV.length == 3
    puts "Invalid params"
    puts "Usage: [put] [input_path] [blob_name]"
    exit
  end
  upload(ARGV[1], ARGV[2])
end

if operation == "delete"
  unless ARGV.length == 2
    puts "Invalid params"
    puts "Usage: [delete] [blob_name]"
    exit
  end
  delete(ARGV[1])
end