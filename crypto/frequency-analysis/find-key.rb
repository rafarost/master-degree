class Cripto
  # Initializes the class
  # Read the ciphertext and store on a local variable
  #
  def initialize(ciphertext)
    @ciphertext = File.open(ciphertext).read.strip
  end

  # Decrypts the ciphertext
  #
  def decrypt
    show_coincidence_index
    frequency_analysis
  end

  private

  # Constant array with the percentual
  # of occurrences of each letter in
  # common english sentences
  EN_PERC =
  { "a" => 8, "b" => 2, "c" => 3, "d" => 4,
    "e" => 13,"f" => 2, "g" => 2, "h" => 6,
    "i" => 7, "j" => 0, "k" => 1, "l" => 4,
    "m" => 2, "n" => 7, "o" => 8, "p" => 2,
    "q" => 0, "r" => 6, "s" => 6, "t" => 9,
    "u" => 3, "v" => 1, "w" => 2, "x" => 0,
    "y" => 2, "z" => 0 }

  def show_coincidence_index
    puts 'What is the max key size that you want to try?'
    max_key_size = gets.chomp.to_i

    max_key_size.times do |m|
      size = m + 1
      puts ''
      puts "M(#{size})"
      chuncked = @ciphertext.chars.each_slice(size).map(&:join)

      indexes = []
      size.times do |a|
        text = ''
        chuncked.each do | chunck |
         text += chunck[a] || ''
        end
        indexes.push(index_of_coincidence(text))
      end
      puts indexes
    end
    puts ''
    puts 'Index of coincidence of sentence in English: 0.065'
    puts ''
  end

  def frequency_analysis
    puts 'So, based on your analysis, what is the key size?'
    key_size = gets.chomp.to_i

    chuncked = @ciphertext.chars.each_slice(key_size).map(&:join)
    key = ''

    key_size.times do |a|
     text = ''
     chuncked.each do | chunck |
       text += chunck[a] || ''
     end

     f = frequency(text)
     f_total = f.values.inject(0, :+).to_f
     f_perc = f.inject({}) { |h, (k, v)| h[k] = ((v * 100).to_f / f_total).round; h }
     f_perc = normalize(f_perc)

     puts ''
     puts "BLOCK #{a}"

     text = ''
     ('A'..'Z').each { |letter| text += " #{letter} " }
     puts text

     f_perc = f_perc.sort.to_h

     text = ''
     ('a'..'z').each { |letter| text += " #{f_perc[letter]} " }
     puts text

     en_perc = EN_PERC.sort.to_h

     text = ''
     ('a'..'z').each { |letter| text += " #{en_perc[letter]} " }
     puts text
     puts ''
     puts "LETTER 'E' SHIFT (Most frequent letter in english)"
     arr = f_perc.sort.to_h.values
     shift = arr.rindex(arr.max) - 4
     puts "Shift: #{shift}"
     puts "Key: #{('A'..'Z').to_a[shift]}"
     key += ('A'..'Z').to_a[shift]
    end

    puts "The key is #{key}"

    @ciphertext.chars[0..30].each do |char|
      puts ('a'..'z').to_a[]
    end
  end
  # Fill missed letters
  #
  def normalize(hash)
    ('a'..'z').to_a.each do |l|
      hash[l] = 0 unless hash.key?(l)
    end
    hash
  end
  # Counts the occurrences of each letter
  # in the text
  def frequency(text)
    occurrences = Hash.new(0)
    text.each_char do |char|
      occurrences[char] += 1
    end
    occurrences
  end
  # Calculates f * (f - 1) for each
  # frequency. Returns the sum of
  # all calculated values.
  def frequency_sum(text)
    occurrs = frequency(text)
    occurrs = occurrs.values.map do |item|
      item * (item - 1)
    end
    occurrs.inject(0, :+)
  end
  # Calculates the index of coincidence
  def index_of_coincidence(text)
    sum = frequency_sum(text)
    size = (text.size * (text.size - 1))
    (sum.to_f / size.to_f)
  end
end

cli = Cripto.new('ciphertext')
cli.decrypt
