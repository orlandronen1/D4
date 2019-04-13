# D4
Deliverable 4 for Software Quality Assurance

## Sean Mizerski and Ronen Orland

## Things that can be wrong:
- Incorrect block number (didn't iterate by 1, is negative)
- Incorrect hash of previous block (first is always 0)
    - Hash of a block is calculated from first character to last character of timestamp
        - Last pipe character ("|") is not included, & of course can't include the hash that's being calculated
- Address (to or from) is incorrect (not exactly 6 decimal digits or not "SYSTEM"
- No transaction in a block (must be at least one per block)
- First block has more than one transaction (can only be one in first block)
- First block's transaction is not from SYSTEM to a valid address
- Negative balance for one or more addresses at the end of a block
- No timestamp
- Incorrect timestamp (timestamp of a block is not strictly greater than timestamp of previous block)
- Incorrect syntax
    - Layout of correct syntax:
        - Integer|hash of previous block|series of transactions|timestamp(sec).timestamp(nsec)|hash of block
    - Example of correct syntax:
        - 0|0|SYSTEM>569274(100)|1553184699.650330000|288d
        - 1|288d|569274>735567(12):735567>561180(3):735567>689881(2):SYSTEM>532260(100)|1553184699.652449000|92a2

## Variables to store:
- Entire block as string?
- Block number
- Hash of previous block
- All addresses and their billcoin balances

## Verification flow:
1. Read in new block
    1. Can split blocks by "|" character. If any empty strings or not 5 strings made from split -> Cannot parse line
2. Verify block number
3. Verify "|"
4. Verify hash of previous block
5. Verify transactions
    1. Split by ":". If any empty strings -> cannot parse line
    1. Verify from address
    2. Verify ">"
    3. Verify to address
    4. Verify amount -> "(#{non-negative integer})"
    5. Update balances for both addresses
6. Verify timestamp
    1. 2 integers separated by "."
    2. Timestamp of current block must be strictly higher than that of previous block
7. Verify hash of current block
    1. Use all characters in the block line up to the final "|", not inclusive