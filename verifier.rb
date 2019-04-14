require_relative 'hash'
require_relative 'validate_block'


# Main file for the system
exit 1 unless check_args ARGV

# Open the file and pass the text to validate_block
text=File.open(ARGV[0]).read
maps = create_maps(text)

# We can set the error if this returns false and print it out after. 
# It should never return true, will only let us know if it fails.
puts "error 1" if verify_block_number(maps) == false
puts "error 2" if verify_prev_hash_match(maps) == false

