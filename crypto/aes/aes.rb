require 'openssl'

### COURSEWORK 3
def decrypt(hex_key, hex_ciphertext, mode)
  ciphertext =  hex_to_bin(hex_ciphertext)
  decipher = OpenSSL::Cipher::AES.new(128, mode)
  decipher.decrypt
  decipher.key = hex_to_bin(hex_key)
  decipher.iv = ciphertext[0..15]
  plain = decipher.update(ciphertext[16..ciphertext.size]) + decipher.final
end

def encrypt(hex_key, hex_plaintext, mode)
  plaintext = hex_to_bin(hex_plaintext)
  cipher = OpenSSL::Cipher::AES.new(128, mode)
  cipher.encrypt
  iv = cipher.random_iv
  cipher.iv = iv
  cipher.key = hex_to_bin(hex_key)
  encrypted = cipher.update(plaintext) + cipher.final
  # prependes the iv to the ciphertext
  prepended = iv + encrypted
  # hex enconde the result
  bin_to_hex(prepended).scan(/../).pack('A2' * prepended.size)
end

def bin_to_hex(s)
  s.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
end

def hex_to_bin(s)
 s.scan(/../).map { |x| x.hex.chr }.join
end

# Task 1
puts decrypt('140b41b22a29beb4061bda66b6747e14', '4ca00ff4c898d61e1edbf1800618fb2828a226d160dad07883d04e008a7897ee2e4b7465d5290d0c0e6c6822236e1daafb94ffe0c5da05d9476be028ad7c1d81', :CBC)
# Task 2
puts decrypt('140b41b22a29beb4061bda66b6747e14', '5b68629feb8606f9a6667670b75b38a5b4832d0f26e1ab7da33249de7d4afc48e713ac646ace36e872ad5fb8a512428a6e21364b0c374df45503473c5242a253', :CBC)
# Task 3
puts decrypt('36f18357be4dbd77f050515c73fcf9f2', '69dda8455c7dd4254bf353b773304eec0ec7702330098ce7f7520d1cbbb20fc388d1b0adb5054dbd7370849dbf0b88d393f252e764f1f5f7ad97ef79d59ce29f5f51eeca32eabedd9afa9329', :CTR)
# Task 4
puts decrypt('36f18357be4dbd77f050515c73fcf9f2', '770b80259ec33beb2561358a9f2dc617e46218c0a53cbeca695ae45faa8952aa0e311bde9d4e01726d3184c34451', :CTR)
# Task 5
key = '36f18357be4dbd77f050515c73fcf9f2'
encrypted = encrypt(key, '5468697320697320612073656e74656e636520746f20626520656e63727970746564207573696e672041455320616e6420435452206d6f64652e', :CTR)
puts "Cipher: #{encrypted}"
puts decrypt(key, encrypted, :CTR)
# Task 6
key = '140b41b22a29beb4061bda66b6747e14'
encrypted = encrypt(key, '4e657874205468757273646179206f6e65206f66207468652062657374207465616d7320696e2074686520776f726c642077696c6c2066616365206120626967206368616c6c656e676520696e20746865204c696265727461646f72657320646120416d6572696361204368616d70696f6e736869702e', :CBC)
puts "Cipher: #{encrypted}"
puts decrypt(key, encrypted, :CBC)
