require 'minitest/autorun'

require_relative 'methods'

# Test file for verifier.rb
class MethodsTest < Minitest::Test

    # UNIT TESTS FOR METHOD check_args(args)
    # Equivalence classes:
    # String, is the name of existing file -> true
    # Single element Array, has name of existing file -> true
    # String, not the name of existing file -> false
    # Array with more than one element -> false

    # Valid argument, String
    def test_check_args_valid_string
        assert_equal true, check_args("sample.txt")
    end

    # Valid argument, passed in as single element array
    def test_check_args_valid_array
        assert_equal true, check_args(["sample.txt"])
    end

    # 1 argument, but not name of existing file
    def test_check_args_invalid_name
        assert_equal false, check_args("this isn't a real file.txt")
    end

    # More than one argument
    def test_check_args_too_many_args
        args = ["too", "many", "arguments"]
        puts args.length
        assert_equal false, check_args(args)
    end


    # UNIT TESTS FOR METHOD hash_block(block)
    # Properties:
    # The return shall be a string
    # The value of the hexadecimal value the String represents shall be < 65536 and >= 0

    # Check that the return is a string
    def test_hash_block_is_string
      property_of {
        string
      }.check() { |s|
        assert_kind_of String, hash_block(s), "string property didn't return String type"
      }
    end

    # Check that the value of the String returned is 0 < x < 65536
    def test_hash_block_correct_range
      property_of {
        string
      }.check() { |s|
        assert_includes 0..65535, hash_block(s).to_i, "Return of hash_block wasn't in right range"
      }
    end
end