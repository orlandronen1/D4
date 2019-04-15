# frozen_string_literal: true

require_relative 'hash'
require_relative 'validate_block'

# Main file for the system
exit 1 unless check_args ARGV

# Open the file and pass the text to validate_block
text = File.open(ARGV[0]).read
maps = create_maps(text)

# We can set the error if this returns false and print it out after.
# It should never return true, will only let us know if it fails.
exit 1 unless verify_block_number(maps)
exit 1 unless verify_prev_hash_match(maps)
balance = verify_transactions(maps)
exit 1 if balance == false
exit 1 unless verify_time_stamp(maps)
exit 1 unless verify_hash(text)
exit 1 unless print_output(balance, maps.length - 1)
