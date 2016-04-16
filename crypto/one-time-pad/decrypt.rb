# Playing with cripto
# http://travisdazell.blogspot.com.br/2012/11/many-time-pad-attack-crib-drag.html

def to_hex_string(text)
  text.chars.map { |c| "%02X" % c.ord }
end

class String
  def xor_with(other_string)
    self.bytes.zip(other_string.bytes).map { |(a,b)| a ^ b }.pack('c*')
  end
end

def xor(cipher1, cipher2)
  cipher1 = [cipher1] if cipher1.is_a?(String)
  cipher2 = [cipher2] if cipher2.is_a?(String)
  cipher1.zip(cipher2).map { |(a,b)| (a.hex ^ b.hex).to_s(16).rjust(2, '0') }
end

# message1 = 'Hello World'
# message2 = 'the program'
# key = 'supersecret'
letters = ('a'..'z').to_a + ('A'..'Z').to_a
#
# msg_1_hex_string =  to_hex_string(message1)
# msg_2_hex_string = to_hex_string(message2)
# key_hex_string = to_hex_string(key)
msg_1_hex_string = '3939252352554c5f51592621294d5c5229382f5d454b485d4554413132275458482d3157415046495c5b2a435a46543527364d5059394847382a2b4b555746404a38202d4c525652455c2a'
msg_2_hex_string = '4d514c503134405f305f4e44292c41534a57414f2c2c2d4054544d5f552741424c5931345f415d2c2e4d4454405e504142522e31424a434c5f2a2b415a412f585a55452d2e20394941562a'
space_hex_string = to_hex_string(' ')

# cipher1 =  xor(msg_1_hex_string, key_hex_string)
# cipher2 =  xor(msg_2_hex_string, key_hex_string)

cipher1 = '3939252352554c5f51592621294d5c5229382f5d454b485d4554413132275458482d3157415046495c5b2a435a46543527364d5059394847382a2b4b555746404a38202d4c525652455c2a'
cipher2 = '4d514c503134405f305f4e44292c41534a57414f2c2c2d4054544d5f552741424c5931345f415d2c2e4d4454405e504142522e31424a434c5f2a2b415a412f585a55452d2e20394941562a'

# xored = xor(cipher1, cipher2)

xored = (cipher1.hex ^ cipher2.hex).to_s(16).scan(/../)

# puts "Message 1 = #{msg_1_hex_string.join}"
# puts "Message 2 = #{msg_2_hex_string.join}"
# puts "Key       = #{key_hex_string.join}"
puts "Ciphertext 1: #{cipher1}"
puts "Ciphertext 2: #{cipher2}"
puts "Xored       : #{xored}"

index = 0

key1 = []
key2 = []

xored.each do |s|
  if letters.include?(s.hex.chr)
    cf1 = xor(cipher1[index], space_hex_string).first#.hex.chr
    cf2 = xor(cipher2[index], space_hex_string).first#.hex.chr
    key1.push(cf1)
    key2.push(cf2)
    puts "Char: #{s.hex.chr} CF1: #{cf1} CF2: #{cf2} Index: #{index}"
  else
    key1.push('')
    key2.push('')
  end
  index+=1
end

# puts key1
# puts key2

cipher3 = '5c6f607168346a607f7e6221616d613668387c62607a6861206a6d7f7b697224'.scan(/../)

puts key1.size
puts key2.size
puts cipher3.size
# puts cipher3
# puts cipher3[0..3]
xored1 = xor(key1[0..3], cipher3[0..3])
xored2 = xor(key2[0..3], cipher3[0..3])


xored1.each { |s| puts s.hex.chr }
xored2.each { |s| puts s.hex.chr }

# 4.times do |i|
#   puts "Chave 1: #{key1[i]} Chave 2: #{key2[i]} Cipher3: #{cipher3[i]}"
#   puts "Xored 1: "
# end

# cipher1 = '3939252352554c5f51592621294d5c5229382f5d454b485d4554413132275458482d3157415046495c5b2a435a46543527364d5059394847382a2b4b555746404a38202d4c525652455c2a'
# cipher2 = '4d514c503134405f305f4e44292c41534a57414f2c2c2d4054544d5f552741424c5931345f415d2c2e4d4454405e504142522e31424a434c5f2a2b415a412f585a55452d2e20394941562a'
# xored = (cipher1.hex ^ cipher2.hex).to_s(16)
# guess = to_hex('the')

# puts xored
#
# puts to_hex('A').hex
# puts to_hex(' ').hex
#
# b = (to_hex('A').hex ^ to_hex(' ').hex).to_s(16)
# puts [b].pack('H*')


# c5 = 0
# xored.size.times.each do |c|
#   c5 = c + 3
#   a = (xored[c..c5].hex ^ guess.hex).to_s(16)
#   puts "c: #{c} => #{[a].pack('H*')}"
# end
# puts xored

# a = (xored[3..5].hex ^ guess.hex).to_s(16)
# puts [a].pack('H*')



# puts to_hex('A').hex
# puts to_hex(' ').hex
#
# b = (to_hex('A').hex ^ to_hex(' ').hex).to_s(16)
# puts [b].pack('H*')

# guess = to_hex('the')
# a = (xored[3..5].hex ^ guess.hex).to_s(16)
# puts [a].pack('H*')

# 1. Take one of the cipher texts and xor with another one

#      3c0d094c1f523808000d09
# XOR  746865
# ——————————————————————————————————
# 48656c

 # (a.to_i(16) ^ b.to_i(16)).to_s(16)

# s.chars do |c|
#   puts "%s %3d %02X" % [ c, c.ord, c.ord ]
# end

puts '##### FROM HERE #####'

cipher5 = '3939252352554c5f51592621294d5c5229382f5d454b485d4554413132275458482d3157415046495c5b2a435a46543527364d5059394847382a2b4b555746404a38202d4c525652455c2a4d514c503134405f305f4e44292c41534a57414f2c2c2d4054544d5f552741424c5931345f415d2c2e4d4454405e504142522e31424a434c5f2a2b415a412f585a55452d2e20394941562a56574023455d4449305b4745295b5b5a45385f59435a44574526453132445c5a454843404d585a2c4146464e3246544146554531445c49574a435f573a505725575951292c53594f515d435544484847522c2c4e5f4155575441274c45582d465d444c2e404b495859324f4f4227424131545644444d594e2e554a4b2c4757204947465f4c53572a4d5625565f504c5e435f474f4d2c565f5a5b5d4e58492d4352494650504e59435954315d5b2047415e4758435349543553592e44595d4f504b5e4a4050244c5e4a48544249525849484b2a5c57424f5847412c5c4e52554c5e41364f4a4a5a594943505926455d5e4842592d545e412854412c4c5a4f565927565c40534054455c2a43564e2b4d55415c4d413843445e485c4b533c5a4b5c53455b4e5e515b4e5829454136594a4a584942593349482442575150584c413150414648495c4d44433253594542452e5e51394b524846424d555046435d4b20434157585d414b5722505f255a5e41294a5f5e484529585a532957414e2c58445e45265450562b355e45485f34514f5b2c46495c523241495b4e45465453395e4a51592b2e574b5a5e405d57425c4b375c6f607168346a607f7e6221616d613668387c62607a6861206a6d7f7b697224'
cipher5 = cipher5.scan(/../)

spaces = []
cipher5.each { |s| spaces.push(space_hex_string.first) }

xored_final = xor(cipher5, spaces)

xored_final.each { |s| puts s.hex.chr }
