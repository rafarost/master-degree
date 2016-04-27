#! /usr/bin/env python
def readable(data):
	if not data:
		return '_'
	out= ''
	for x in data:
		if x >= ' ' and x <= '~':
			out += x
		else:
			out += '~'
	return out

# OTP re-use adversary
# if an ASCII character was XOR'd with a space it will be a case-swapped ASCII character
def isxorspace(c):
	if (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '\0':
		return True
	return False

def sxor(s1, s2):
	out= ''
	for x in range(len(s1)):
		out += chr(ord(s1[x]) ^ ord(s2[x]))
	return out

def print_plaintexts(key, ciphers):
	print
	print 'key:'
	for x in range(len(key)):
		if Key[x] == None:
			print '__',
		else:
			print '%02X' % ord(key[x]),
	print
	print
	print 'plaintexts:'
	for y in range(len(ciphers)):
		out= ''
		for x in range(len(ciphers[y])):
			if key[x] == None:
				out += '_'
			else:
				out += readable(sxor(ciphers[y][x],key[x]))
		print out

# auto crack re-used one time pad by spotting where messages were XOR'd with a space
def otp_crack(candidates, key):
	for r in range(len(candidates)):
		other= 1
		mastermask= [' ' for x in range(len(candidates[0]))]
		# process the first ciphertext against all other candidates
		while other < len(candidates):
			string1= candidates[0]
			string2= candidates[other]
			if len(string1) > len(string2):
				maxlen= len(string2)
			else:
				maxlen= len(string1)
			string1= string1[:maxlen]
			string2= string2[:maxlen]

			# we nullify the key by xoring the two messages together: result is m1 xor m2
			m1m2= sxor(string1,string2)
			# if we get an ASCII letter then one of the strings was an XOR with ' ' (0x20) (or some number or punctuation, so we will get some false positives)
			# if we get an ASCII 0x00 then both of the strings were the same, and *may* have been a ' '
			# (this also results in some false positives, but removes far more false negatives so is overall worth doing)
			mask= []
			for x in m1m2:
				if isxorspace(x):
					mask.append(' ')
				else:
					mask.append('\0')

			# if we see a space in the same place for every message then we know it was in message 1, since that was the only constant
			# and as we are going to repeat this process for every message, we should get every key byte that corresponds to a space in any message
			for x in range(len(mask)):
				if mastermask[x] != mask[x]:
					mastermask[x]= '\0'
			other += 1
		# now we know where the spaces were in string1, an XOR with a space will reveal the key byte
		for x in range(len(string1)):
			if mastermask[x] == ' ':
				key[x]= chr(ord(string1[x]) ^ ord(' '))

		# print mask
		# print mastermask

		# rotate list
		candidates= [candidates.pop()] + candidates

	return key

args = ['3939252352554c5f51592621294d5c5229382f5d454b485d4554413132275458482d3157415046495c5b2a435a46543527364d5059394847382a2b4b555746404a38202d4c525652455c2a',
'4d514c503134405f305f4e44292c41534a57414f2c2c2d4054544d5f552741424c5931345f415d2c2e4d4454405e504142522e31424a434c5f2a2b415a412f585a55452d2e20394941562a',
'505725575951292c53594f515d435544484847522c2c4e5f4155575441274c45582d465d444c2e404b495859324f4f4227424131545644444d594e2e554a4b2c4757204947465f4c53572a',
'4d5625565f504c5e435f474f4d2c565f5a5b5d4e58492d4352494650504e59435954315d5b2047415e4758435349543553592e44595d4f504b5e4a4050244c5e4a48544249525849484b2a',
'56574023455d4449305b4745295b5b5a45385f59435a44574526453132445c5a454843404d585a2c4146464e3246544146554531445c49574a435f573a',
'5c57424f5847412c5c4e52554c5e41364f4a4a5a594943505926455d5e4842592d545e412854412c4c5a4f565927565c40534054455c2a43564e2b4d55415c4d413843445e485c4b533c',
'505f255a5e41294a5f5e484529585a532957414e2c58445e45265450562b355e45485f34514f5b2c46495c523241495b4e45465453395e4a51592b2e574b5a5e405d57425c4b37']

CipherText= []
for x in args:
	CipherText.append(x.decode('hex'))
maxlen= 0
for x in CipherText:
	if len(x) > maxlen:
		maxlen= len(x)

Key= [None for x in range(maxlen)]
OriginalKey= Key

otp_crack(CipherText, Key)
#print_plaintexts(otp_crack(CipherText, Key), CipherText)
