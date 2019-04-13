# Check that the block number on each line iterated by 1
def create_array(text)
  array=text.split("\n")
  return array
end

def varify_block_number(array)
  a = Array.new
  array.each{|x| a.push(x[0].to_i)} 
  puts a
end
