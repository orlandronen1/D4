require 'minitest/autorun'

require_relative 'methods'

# Test file for verifier.rb
class MethodsTest < Minitest::Test

    # UNIT TESTS FOR METHOD check_args(args)
    # Equivalence classes:
    # 1 argument, is the name of existing file -> return true
    # 1 argument, not the name of existing file -> return false
    # Not just 1 argument -> return false

    # Valid argument
    def test_check_args_valid
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