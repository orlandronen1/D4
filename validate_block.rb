# frozen_string_literal: true

# above is a demand made by rubocop
def create_maps(text)
  maps = []
  array = text.split("\n")
  array.each do |x|
    # We'll need to do some validating of the blocks here
    # Check the number of pipes
    return false if x.count('|') != 4

    # Check for nulls is done in each method later
    elem = x.split('|')

    # Check the number of elements after splitting at pipe
    return false if elem.length != 5

    kv_map = { id: elem[0], prev_hash: elem[1], transactions: elem[2], time_stamp: elem[3], hash: elem[4] }
    maps.push(kv_map)
  end
  # sneaky way to return without pissing off rubocop
  maps = maps
end

def verify_block_number(maps)
  maps.each_with_index do |x, i|
    return false if x[:id].to_i != i
  end
end

# Split the array on | and get the second element of the array
# For the first element, it should be 0
# Verify first the format, so should contain 0-9a-f(lowercase)
# Calculate hash of previous element and verify that they match.
def verify_prev_hash_match(maps)
  # special case for first line
  return false if maps[0][:id].to_i != 0

  # now start at the 1st line
  (1...maps.length).each do |i|
    prev_hash = maps[i][:prev_hash]
    curr_hash = maps[i - 1][:hash]
    # check that they match
    return false if prev_hash != curr_hash
    # check that the length of each is not more than 4
    return false if prev_hash.length > 4

    return false if curr_hash.length > 4

    # check the formatting of the hash
    prev_hash.delete!('abcdef0123456789')
    curr_hash.delete!('abcdef0123456789')
    return false unless prev_hash.empty?
    return false unless curr_hash.empty?
  end
end

# following steps of number 5 in verification flow doc
def verify_transactions(maps)
  # hash literal same as Hash.new
  balance_map = {}
  maps.each do |x|
    trans = x[:transactions].split(':')
    trans.each_with_index do |y, i|
      # verifing from  address vaild/correct format
      from_addr = y[0..5]
      balance_map[from_addr] = 0 unless balance_map.key?(from_addr)
      if i == trans.length - 1
        return false unless from_addr == 'SYSTEM'
      else
        from_addr.delete!('0123456789')
        return false unless from_addr.empty?
      end
      # verifing > in position 7
      return false unless y[6] == '>'

      # verifing to address valid/correct format
      to_addr = y[7..12]
      balance_map[to_addr] = 0 unless balance_map.key?(to_addr)
      # puts balance_map[to_addr]
      to_addr.delete!('0123456789')
      return false unless to_addr.empty?
      # open_paren = y[13]
      # closed_paren = y[y.length - 1]
      return false unless y[13] == '('
      return false unless y[y.length - 1] == ')'

      amount_num = y[14..y.length - 2]
      balance_map[y[0..5]] -= amount_num.to_i
      balance_map[y[7..12]] += amount_num.to_i
      amount_num.delete!('0123456789')
      return false unless amount_num.empty?
    end
  end
  # really rubocop
  balance_map = balance_map
end

def verify_time_stamp(maps)
  (1...maps.length).each do |i|
    curr_time = maps[i][:time_stamp].split('.')
    puts false unless curr_time.length == 2
    prev_time = maps[i - 1][:time_stamp].split('.')
    puts false unless prev_time.length == 2
    puts false unless curr_time[1].to_i > prev_time[1].to_i
  end
end
