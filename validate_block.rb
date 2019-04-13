def create_maps(text)
	maps = []
	array=text.split("\n")
	array.each{|x|
		# We'll need to do some validating of the blocks here
		# Check the number of pipes
        return false if x.count('|') != 4
		# Check for nulls is done in each method later
		elem = x.split('|')
        # Check the number of elements after splitting at pipe
        return false if elem.length != 5
		kv_map = {id: elem[0], prev_hash: elem[1], transactions: elem[2], time_stamp: elem[3], hash: elem[4]}
		maps.push(kv_map)
	}
	return maps
end

def verify_block_number(maps)
  maps.each_with_index{|x, i| 
  	return false if x[:id].to_i != i }
end

# Split the array on | and get the second element of the array
# For the first element, it should be 0
# Verify first the format, so should contain 0-9a-f(lowercase)
# Calculate hash of previous element and verify that they match.
def verify_prev_hash_match(maps)
	# special case for first line
	return false if maps[0][:id].to_i != 0
	#puts elem[1]

	# now start at the 1st line
	(1...maps.length).each{|i| 
		prev_hash = maps[i][:prev_hash]
		curr_hash = maps[i-1][:hash]


		# check that they match
		return false if prev_hash != curr_hash

		# check that the length of each is not more than 4
		return false if prev_hash.length > 4
		return false if curr_hash.length > 4

		# check the formatting of the hash
		prev_hash.delete!("abcdef0123456789")
		curr_hash.delete!("abcdef0123456789")
		return false if prev_hash.empty?
		return false if curr_hash.empty?
	}
end