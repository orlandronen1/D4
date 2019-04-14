require_relative 'validate_block'
require_relative 'hash'

# Test file for validate_block.rb
class ValidateBlockTest < Minitest::Test

  # Have strings to use for map creation
  def setup
    @good = "ID|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n"
    @full = "0|0|SYSTEM>569274(100)|1553184699.650330000|288d
1|288d|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2"
  end

  # UNIT TESTS FOR METHOD create_maps(text)
  # Equivalence classes:
  # Exactly 4 '|' characters -> returns a map of the blocks
  # Not exactly 4 '|' -> returns false
  # Not 5 sections of a block created after splitting on '|' -> returns false

  def test_create_maps_valid_one_line
    map = create_maps(@good)
    # Should only have 1 element (1 block)
    assert_equal 1, map.length
    # Should have split block into 5 sections
    assert_equal 5, map[0].length
  end

  def test_create_maps_valid_several_lines
    str = @good + @good + @good
    map = create_maps(str)
    # Should have 3 elements (3 block)
    assert_equal 3, map.length
    # Should have split each block into 5 sections
    map.each do |x| 
      assert_equal 5, x.length
    end
  end
  
  def test_create_maps_invalid_bad_num_of_pipes
    assert_equal false, create_maps("ID|PREV_HASHTRANSACTIONS|TIME_STAMP|HASH\n")
  end
  
  def test_create_maps_invalid_extra_pipes
    assert_equal false, create_maps("ID|PREV_HASH|TRANSACTIONS|TIME_STAMP||HASH\n")
  end

  def test_create_maps_invalid_not_5_sections
    assert_equal false, create_maps("ID|PREV_HASHTRANSACTIONS|TIME_STAMP||HASH\n")
  end

  # UNIT TESTS FOR METHOD verify_block_number(maps)
  # Equivalence classes:
  # Block numbers start at 0 and increment by 1 -> returns true
  # Block numbers don't start at 0 -> returns false
  # Block numbers don't increment by 1 at any point -> returns true
  # Block number is not a number

  def test_verify_block_number_valid_one_line
    map = create_maps("0|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n")
    assert_equal true, verify_block_number(map)
  end

  def test_verify_block_number_valid_several_lines
    map = create_maps("0|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n1|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n")
    assert_equal true, verify_block_number(map)
  end

  def test_verify_block_number_invalid_not_start_at_zero
    map = create_maps("1|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n")
    assert_equal false, verify_block_number(map)
  end

  def test_verify_block_number_invalid_not_increment_by_one
    map = create_maps("0|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n2|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n")
    assert_equal false, verify_block_number(map)
  end

  def test_verify_block_number_invalid_block_num_not_a_num
    map = create_maps("B|PREV_HASH|TRANSACTIONS|TIME_STAMP|HASH\n")
    assert_equal false, verify_block_number(map)
  end

  # UNIT TESTS FOR METHOD verify_prev_hash_match(maps)
  # Properties of valid hashes:
  # => First hash is 0
  # => Hash at end of a block matches hash at beginning of next block
  # => Hashes consist only of hexadecimal digits
  # => Hashes are at most 4 digits long
  # => Hashes are not empty (Assured in create_maps())
  # If all of these properties are met, the method returns true
  # Else, it returns false

  def test_verify_prev_hash_match_valid
    map = create_maps(@full)
    assert_equal true, verify_prev_hash_match(map)
  end

  def test_verify_prev_hash_match_invalid_non_matching_hashes
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288a
1|288d|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_prev_hash_match(map)
  end

  def test_verify_prev_hash_match_invalid_first_hash_not_zero
    map = create_maps("0|1|SYSTEM>569274(100)|1553184699.650330000|288a
1|288d|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_prev_hash_match(map)
  end

  def test_verify_prev_hash_match_invalid_not_only_hex
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288g
1|288g|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_prev_hash_match(map)
  end

  def test_verify_prev_hash_match_invalid_longer_than_4_digits
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_prev_hash_match(map)
  end

  # UNIT TESTS FOR METHOD verify_transactions(maps)
  # Properties of valid transactions:
  # => Have valid to/from addresses
  # => Have non-negative integers for each transaction
  # => Have proper syntax: FROM_ADDR>TO_ADDR(VAL)
  # => => Each transaction is separated by ':'

  def test_verify_transactions_valid
    balances = verify_transactions(create_maps(@full))
    assert_kind_of Hash, balances
    balances.each do |addr, balance|
      if addr == "SYSTEM"
        assert balance < 0
      else
        assert balance >= 0
      end
    end
  end

  def test_verify_transactions_invalid_addrs_wrong_length
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>53220(100)|1553184699.652449000|92a2")
    assert_equal false, verify_transactions(map)
  end

  def test_verify_transactions_invalid_addrs_use_not_decimal_digits
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>53226A(100)|1553184699.652449000|92a2")
    assert_equal false, verify_transactions(map)
  end

  def test_verify_transactions_invalid_negative_transaction
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12):735567>561180(-3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_transactions(map)
  end

  def test_verify_transactions_invalid_missing_open_paren
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12):735567>561180(3):735567>6898812):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_transactions(map)
  end

  def test_verify_transactions_invalid_missing_close_paren
    map = create_maps("0|0|SYSTEM>569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12:735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_transactions(map)
  end

  def test_verify_transactions_invalid_missing_addr_separator
    map = create_maps("0|0|SYSTEM569274(100)|1553184699.650330000|288aa
1|288aa|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2")
    assert_equal false, verify_transactions(map)
  end

end