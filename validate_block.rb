# Check that the block number on each line iterated by 1
def create_array(text)
  array=text.split("\n")
  return array
end

def varify_block_number(array)
  array.each_with_index{|x, i| 
  	puts false if x[0].to_i != i }
end
