# frozen_string_literal: true

# Hash of characters that have been encountered
$char_hashes = {}

# Checks command line arguments. If there isn't a single argument and it isn't the
# the name of an existing file, return false. Else, return true.
def check_args(args)
  # If argument is an array and of length one
  if (args.is_a? Array) && (args.length == 1) && (File.exist? args[0])
    true
  elsif (args.is_a? String) && (File.exist? args)
    true
  else
    puts 'Usage: ruby verifier.rb <name_of_file>'
    puts '     name_of_file = name of file to verify'
    false
  end
end

# Calculates the hash for a block
# Assumes the string entered does not include the final pipe and own hash
def hash_block(block)
  chars = block.unpack('U*') # Get array of UTF-8 values of each char in block
  hash_calc = 0
  chars.each do |c|
    temp_char_hashes = $char_hashes
    temp_char_hashes[c] = (((c**3000) + (c**c) - (3**c)) * (7**c)) % 65_536 if temp_char_hashes[c].nil?
    hash_calc += temp_char_hashes[c]
    $char_hashes = temp_char_hashes
  end
  hash_calc %= 65_536 # Modulo
  hash_calc.to_s(16) # Convert to string of hexadecimal representation
end
