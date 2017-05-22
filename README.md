Tests have shown that initial **id.js** has several issues:
 - reference error
 - new very expensive resources with same ID get duplicated in memory instead of referencing to one resource
 - on close() the very expensive resource won't actually be deleted from memory
My new commit contains fixes for these issues and other minor corrections as well.


Regarding this little **Python piece**: `''.join(itertools.chain(*zip(s[-2::-2], s[::-2])))`

It shuffles the string s in a specific pattern, the resulting string is reversed sequence of the original symbols pair by pair:
'abcdef' will turn into 'efcdab' (first 'ef' then 'cd' then 'ab').
It does it by zipping together two sequences of symbols:
 1) a reversed sequence of every second symbol of the original string
 2) same but starting from the next-to-last symbol of the original string

The result is a list of two-tuples, which is then chained into one list of symbols, which is then joined into one string.
If the original string contains an odd number of symbols, the first symbol of it is lost. The result length is always even.


**MyContract.sol** was vulnerable to reentrancy attack. The new commit contains fixes and also the implemented deposit() function.