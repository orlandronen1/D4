require_relative 'hash'
require_relative 'validate_block'


# Main file for the system
exit 1 unless check_args ARGV

# Open the file and pass the text to validate_block
text=File.open(ARGV[0]).read
block_array = create_array(text)
varify_block_number(block_array)