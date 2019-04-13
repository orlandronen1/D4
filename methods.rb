# Checks command line arguments. If there isn't a single argument and it isn't the
# the name of an existing file, return false. Else, return true.
def check_args(args)
    # If argument is an array and of length one
    if args.is_a? Array and args.length == 1 and File.exist? args[0]
        true
    elsif args.is_a? String and File.exist? args
        true
    else
        false
    end     
end

# Calculates the hash for a block
# Assumes the string entered does not include the final pipe and own hash
def hash_block(block)
  chars = block.unpack('U') # Get array of UTF-8 values of each char in block
  hash_calc = 0
  chars.each { |c| hash_calc += ( ((c**3000) + (c**c) - (3**c)) * (7**x) )}
  hash_calc %= 65536  # Modulo
  hash_calc.to_s(16)  # Convert to string of hexadecimal representation
end