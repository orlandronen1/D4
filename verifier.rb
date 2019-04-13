require_relative 'hash'
require_relative 'validate_block'


# Main file for the system
exit 1 unless check_args ARGV

# Open the file and pass the text to validate_block
text=File.open(ARGV[0]).read
block_array = create_array(text)

# We can set the error if this returns false and print it out after. 
# It should never return true, will only let us know if it fails.
verify_block_number(block_array)
verify_block_pipes(block_array)

