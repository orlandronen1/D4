# Checks command line arguments. If there isn't a single argument and it isn't the
# the name of an existing file, return false. Else, return true.
def check_args(args)
    # If argument is an array and of length one
    if args.is_a? Array and args.length == 1 and File.exist? args[0]
        true
    elsif args.is_a? String and File.exist? args
        true
    else
        false
    end     
end

# Checks for valid address

# Checks for valid hash

# Checks for valid timestamp

# Checks for valid block syntax
