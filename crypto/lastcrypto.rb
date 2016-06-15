require 'digest'

chuncks = []

File.open('video_03.mp4','r') do |file|
  until file.eof?
    chunck = file.read(1024)
    chuncks.push(chunck)
  end
end

until chuncks.empty?
  last = chuncks.pop
  sha = Digest::SHA256.digest(last)
  hex = Digest::SHA256.hexdigest(last)
  
  puts hex
  
  chuncks[chuncks.size - 1] = "#{chuncks.last}#{sha}" unless chuncks.empty?
end
