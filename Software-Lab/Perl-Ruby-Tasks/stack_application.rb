#RUBY PROGRAM MADE BY ABDUL SATTAR MAPARA (SOFTWARE LAB-II EVALUATION-II) Prepared on Dt:30th March,2018
module StackDS
	class Node		#LINKEDLIST IMPLEMENTATION
		attr_accessor :data,:next_ptr
		
		def initialize(data,next_ptr)
			@data=data
			@next_ptr=next_ptr
		end
		def insert_at_end(ptr,data)

			Node.new(data,nil)
			
		end
		def traverse(ptr)
			curr=ptr
			res="["
			while curr.next_ptr != nil
				res=res+curr.data.to_s+","

				curr=curr.next_ptr
			end
			res=res+curr.data.to_s+"]"
			print "LINKED LIST LOOKS LIKE:\n"
			puts res

		end
	end
	class Stack
		def initialize
			@first=nil
		end
		def push(data)
			@first=Node.new(data,@first)
		end
		alias_method :"<<",:push
		def pop
			raise "THE STACK IS EMPTY" if empty?
			data=@first.data
			@first=@first.next_ptr
			data
		end
		def empty?
			@first.nil?
		end
	end
end
stack=StackDS::Stack.new
arr1=Array.new
arr2=Array.new
print "ENTER THE SIZE OF THE SEQUENCES:\t"
size=gets.chomp
size=size.to_i
print "ENTER THE FIRST SEQUENCE:\n"
count=0
while count < size
    element=gets.chomp
    element=element.to_i
    arr1.push(element)
    count = count + 1
end
print "ENTER THE SECOND SEQUENCE:\n"
count=0
while count < size
    element = gets.chomp
    element = element.to_i
    arr2.push(element)
    count = count + 1
end
possible=true
count = 0
while count < size and possible
    val2 = arr2[count]
    found = false
    while !(arr1.empty?) and !found
        val1=arr1.shift
        if val1 == val2
            found=true
        else
            stack.push(val1)
        end
    end
    if !found
        if stack.empty? or stack.pop != val2
            possible = false
        end
    end
    count = count + 1
end
if possible
    print "Yes\n"
else
    print "No\n"
end
