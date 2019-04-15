# frozen_string_literal: true

require_relative 'hash'

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
    kv_map.each do |key, val|
      return false if val == ''
      return false if key == ''
    end
    maps.push(kv_map)
  end
  # sneaky way to return without pissing off rubocop
  maps = maps
end

def verify_block_number(maps)
  maps.each_with_index do |x, i|
    if x[:id].to_i != i
      puts "Line #{i}: Invalid block number #{x[:id]}, should be #{i}"
      puts 'BLOCKCHAIN INVALID'
      return false
    end
  end

  # If nothing wrong, return true
  true
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
    if prev_hash != curr_hash
      puts "Line #{i}: Previous hash was #{prev_hash}, should be #{curr_hash}.\nBLOCKCHAIN INVALID"
      return false
    end
    # check that the length of each is not more than 4
    if prev_hash.length > 4
      puts "Line #{i}: Previous hash #{prev_hash} is too long.\nBLOCKCHAIN INVALID"
      return false
    end
    if curr_hash.length > 4
      puts "Line #{i}: Current hash #{curr_hash} is too long.\nBLOCKCHAIN INVALID"
      return false
    end
    # check the formatting of the hash
    prev_hash.delete!('abcdef0123456789')
    curr_hash.delete!('abcdef0123456789')
    unless prev_hash.empty?
      puts "Line #{i}: Previous hash #{prev_hash} contains invalid characters.\nBLOCKCHAIN INVALID"
      return false
    end
    unless curr_hash.empty?
      puts "Line #{i}: Current hash #{curr_hash} contains invalid characters.\nBLOCKCHAIN INVALID"
      return false
    end
  end

  # If nothing wrong, return true
  true
end

# following steps of number 5 in verification flow doc
def verify_transactions(maps)
  # hash literal same as Hash.new
  balance_map = {}
  valid = -1
  maps.each do |x|
    trans = x[:transactions].split(':')
    trans.each_with_index do |y, i|
      # verifing from  address vaild/correct format
      from_addr = y[0..5]
      balance_map[from_addr] = 0 unless balance_map.key?(from_addr)
      if i == trans.length - 1
        valid = x[:id] unless from_addr == 'SYSTEM'
      else
        from_addr.delete!('0123456789')
        valid = x[:id] unless from_addr.empty?
      end
      # verifing > in position 7
      valid = x[:id] unless y[6] == '>'

      # verifing to address valid/correct format
      to_addr = y[7..12]
      balance_map[to_addr] = 0 unless balance_map.key?(to_addr)
      # puts balance_map[to_addr]
      to_addr.delete!('0123456789')
      valid = x[:id] unless to_addr.empty?
      valid = x[:id] unless y[13] == '('
      valid = x[:id] unless y[y.length - 1] == ')'

      amount_num = y[14..y.length - 2]
      balance_map[y[0..5]] -= amount_num.to_i
      balance_map[y[7..12]] += amount_num.to_i
      amount_num.delete!('0123456789')
      valid = x[:id] unless amount_num.empty?
    end
  end
  # really rubocop
  unless valid.to_i.negative?
    puts "Line #{valid}: Could not parse transactions list.'#{maps[valid.to_i][:transactions]}'\nBLOCKCHAIN INVALID"
    return false
  end
  balance_map = balance_map
end

def verify_time_stamp(maps)
  (1...maps.length).each do |i|
    curr_time = maps[i][:time_stamp].split('.')
    unless curr_time.length == 2
      puts "Line #{i}: Invalid number of time stamps.\nBLOCKCHAIN INVALID"
      return false
    end
    prev_time = maps[i - 1][:time_stamp].split('.')
    unless prev_time.length == 2
      puts "Line #{i}: Invalid number of time stamps.\nBLOCKCHAIN INVALID"
      return false
    end
    unless curr_time[1].to_i > prev_time[1].to_i || curr_time[0].to_i > prev_time[0].to_i
      puts "Line #{i}: Previous timestamp #{maps[i - 1][:time_stamp]} >= new timestamp #{maps[i][:time_stamp]}."
      puts 'BLOCKCHAIN INVALID'
      return false
    end
  end
  # If nothing wrong, return true
  true
end

def verify_hash(text)
  array = text.split("\n")
  array.each do |s|
    pipe_index = s.rindex('|')
    hash_str = s[0...pipe_index]
    hex = hash_block(hash_str)
    unless hex == s[pipe_index + 1..-1]
      puts "Line #{s[0]}: String #{hash_str} has hash set to #{s[pipe_index + 1..-1]}, should be #{hex}."
      puts 'BLOCKCHAIN INVALID'
      return false
    end
  end
  # If nothing wrong, return true
  true
end

def print_output(balance_map, last_line)
  print_array = []
  balance_map = balance_map.sort
  balance_map.each do |k, v|
    next if k == 'SYSTEM'

    if v.negative?
      puts "Line #{last_line}: Invalid block, address #{k} has #{v} billcoins!"
      puts 'BLOCKCHAIN INVALID!!'
      exit 1
    end
    print_array.push("#{k}: #{v} billcoins\n") if v.positive?
  end
  puts print_array
end
