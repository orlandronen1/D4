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

end