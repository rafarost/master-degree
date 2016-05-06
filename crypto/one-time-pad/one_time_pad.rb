cipher_text = [
    '3939252352554c5f51592621294d5c5229382f5d454b485d4554413132275458482d3157415046495c5b2a435a46543527364d5059394847382a2b4b555746404a38202d4c525652455c2a',
    '4d514c503134405f305f4e44292c41534a57414f2c2c2d4054544d5f552741424c5931345f415d2c2e4d4454405e504142522e31424a434c5f2a2b415a412f585a55452d2e20394941562a',
    '56574023455d4449305b4745295b5b5a45385f59435a44574526453132445c5a454843404d585a2c4146464e3246544146554531445c49574a435f573a',
    '505725575951292c53594f515d435544484847522c2c4e5f4155575441274c45582d465d444c2e404b495859324f4f4227424131545644444d594e2e554a4b2c4757204947465f4c53572a',
    '4d5625565f504c5e435f474f4d2c565f5a5b5d4e58492d4352494650504e59435954315d5b2047415e4758435349543553592e44595d4f504b5e4a4050244c5e4a48544249525849484b2a',
    '5c57424f5847412c5c4e52554c5e41364f4a4a5a594943505926455d5e4842592d545e412854412c4c5a4f565927565c40534054455c2a43564e2b4d55415c4d413843445e485c4b533c',
    '5a4b5c53455b4e5e515b4e5829454136594a4a584942593349482442575150584c413150414648495c4d44433253594542452e5e51394b524846424d555046435d4b20434157585d414b5722',
    '505f255a5e41294a5f5e484529585a532957414e2c58445e45265450562b355e45485f34514f5b2c46495c523241495b4e45465453395e4a51592b2e574b5a5e405d57425c4b37',
    '5c6f607168346a607f7e6221616d613668387c62607a6861206a6d7f7b697224',
    '5c6f607168346a607f7e6221616d613668387c62607a6861206a6d7f7b697224']

# Break the ciphers in pairs
#
ciphers = []

cipher_text.each do |cipher|
  decoded = []
  cipher.scan(/../).each do |c|
    decoded.push(c.hex.chr)
  end
  ciphers.push(decoded.join)
end

# Return true if is a space or a letter(a..zA..Z)
#
def space_or_letter(char)
	(char =~ /[A-Za-z]/ || char.to_s == "\u0000")
end

# Xor two strings
#
def xor(message1, message2)
  xored = ''
  message1.size.times { |x| xored += (message1[x].ord ^ message2[x].ord).chr }
	xored
end

# normalize xored text
#
def normalize(text)
	return '_' unless text
	out = ''
	text.size.times do |x|
    out += (text[x] >= ' ' && text[x] <= '~') ? text[x] : '~'
  end
	out
end

# Given a key and cipher texts, will print the plaintexts
#
def plaintexts(key, ciphers)
  key_string = ''
  key.size.times do |x|
    if key[x].nil?
      key_string += '__'
    else
      key_string += '%02X' % key[x].ord
    end
  end

  puts "Key: #{key_string}" 
  
  ciphers.size.times do |y|
    texts = ''
    ciphers[y].size.times do |x|
      if key[x].nil?
        texts += '_'
      else
        texts += normalize(xor(ciphers[y][x],key[x]))
      end
    end
    puts "Plaintext #{y}:#{texts}"
  end
end

def otp_attack(messages)
	# Create an array with the max cipher size
  #
  key = Array.new(messages.max_by(&:size).size)

  # Iterate through all the messages rotating and comparing all of them
  #
  messages.size.times do |r|
		message_to_compare = 1
		spaces_on_message1 = []
    messages[0].size.times { |x| spaces_on_message1.push(' ')}
		
		while message_to_compare < messages.size
			message1 = messages[0]
			message2 = messages[message_to_compare]
			
      # Use the min size between the messages being compared
      #
      if message1.size > message2.size
				maxlen = message2.size
			else
				maxlen = message1.size
      end			
      message1 = message1[0..maxlen - 1]
			message2 = message2[0..maxlen - 1]
			
      # Xor message 1 with message2
			xored = xor(message1,message2)
			
      # Check for empty spaces in the xor result
			xor_empty_spaces = []
			xored.size.times do |x|
				if space_or_letter(xored[x])
					xor_empty_spaces.push(' ')
				else
					xor_empty_spaces.push(nil)
        end
      end

			# If an spaces was already found at the same place
      # we can guess that the space belongs to message1
			xor_empty_spaces.size.times do |x|
				if spaces_on_message1[x] != xor_empty_spaces[x]
					spaces_on_message1[x]= nil
        end
      end

      # compares message1 with the next message
			message_to_compare += 1
    end

    # Having all the spaces of message1, we xor them to get the key
    message1.size.times do |x|
      if spaces_on_message1[x] == ' '
        key[x] = (message1[x].ord ^ ' '.ord).chr
      end
    end
		# rotate list
		messages = [messages.pop] + messages
  end
	return key
end

# Get the partial key
#
key = otp_attack(ciphers)

# Print partial plain texts
plaintexts(key, ciphers)

# Guess phase
# 
key[9] = (ciphers[7][9].ord ^ 'U'.ord).chr
key[14] = (ciphers[7][14].ord ^ 'H'.ord).chr
key[19] = (ciphers[7][19].ord ^ 'E'.ord).chr
key[31] = (ciphers[7][31].ord ^ 'T'.ord).chr
key[41] = (ciphers[7][41].ord ^ 'A'.ord).chr
key[42] = (ciphers[7][42].ord ^ 'V'.ord).chr
key[43] = (ciphers[7][43].ord ^ 'E'.ord).chr
key[46] = (ciphers[7][46].ord ^ 'I'.ord).chr
key[49] = (ciphers[7][49].ord ^ 'S'.ord).chr
key[52] = (ciphers[7][52].ord ^ 'D'.ord).chr
key[55] = (ciphers[7][55].ord ^ 'H'.ord).chr
key[56] = (ciphers[7][56].ord ^ 'I'.ord).chr
key[60] = (ciphers[7][60].ord ^ 'C'.ord).chr
key[63] = (ciphers[7][63].ord ^ 'R'.ord).chr
key[64] = (ciphers[7][64].ord ^ 'S'.ord).chr
key[29] = (ciphers[0][29].ord ^ ' '.ord).chr
key[70] = (ciphers[0][70].ord ^ 'O'.ord).chr
key[71] = (ciphers[0][71].ord ^ 'K'.ord).chr
key[72] = (ciphers[0][72].ord ^ 'E'.ord).chr
key[73] = (ciphers[0][73].ord ^ 'N'.ord).chr
key[74] = (ciphers[0][74].ord ^ '.'.ord).chr
key[75] = (ciphers[6][75].ord ^ '.'.ord).chr

# Prints plain texts and key
#
plaintexts(key, ciphers)