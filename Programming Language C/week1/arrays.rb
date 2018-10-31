# ARRAYS

a = [1,2,3
]
# length of a array
a.size

# concatenate arrays
b = a + [true,false]

# array of unique elements between n arrays
c = [3,2,3] | [1,2,3] | [4]

# create new array of length n=9 (filled with value x=1)
y = Array.new(9) {1}

# methods
# push n - add to the end of array
# pop - remove last element of array
# shift - remove first element of array
# unshift n - add to beginning of array

# reference (aliasing)
d = a
# copying (new array)
e = a + []

# slice(i,n) - starts at index i and retrieves n elements
f = [2,4,6,8,10,12,14]
f[2,4] # [6,8,10,12]
f.slice(2,4) # [6,8,10,12]


# Blocks

a = Array.new(5) {|i| 4*(i+1)}
# forEach
a.each {|x| puts (x * 2) }
# map
a.map  {|x| x * 2 }
# some
a.any? {|x| x > 7 } 
# every
a.all? {|x| x > 7 } 
a.all? # implicit are elements "true" (neither false nor nil)
# reduce
a.inject(0) {|acc,elt| acc+elt }
# filter
a.select {|x| x > 7 }