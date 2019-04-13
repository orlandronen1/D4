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
  array.each{|x| return false if x.count('|') != 4}
end