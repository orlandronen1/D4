# Check that the block number on each line iterated by 1
def create_array(text)
  array=text.split("\n")
  return array
end

def verify_block_number(array)
  array.each_with_index{|x, i| 
  	return false if x[0].to_i != i }
end

def verify_block_pipes(array)
  array.each{|x| puts false if x.count('|') != 4}
end

# Split the array on | and get the second element of the array
# For the first element, it should be 0
# Verify first the format, so should contain 0-9a-f(lowercase)
# Calculate hash of previous element and verify that they match.
def verify_prev_hash_match(array)
	# special case for first line
	elem = array[0].split('|')
	puts false if elem[1].to_i != 0
	#puts elem[1]

	# now start at the 1st line
	(1...array.length).each{|i| 
		elem = array[i].split('|')
		prev_elem = array[i-1].split('|')

		# check that they match
		return false if elem[1] != prev_elem[4]

		# check that the length of each is not more than 4
		return false if elem[1].length > 4
		return false if elem[1].length > 4

		# check the formatting of the hash
		elem[1].delete!("abcdef0123456789")
		prev_elem[1].delete!("abcdef0123456789")
		return false if elem[1].empty?
		return false if prev_elem[1].empty?
	}
end