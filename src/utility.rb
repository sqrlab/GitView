module Utility
    def Utility.toInteger(array)
        if array.class.name == Array.to_s
            #puts "is_array"
            return array[0]
        else
            return array
        end
    end

    def Utility.toValue(array)
    	return Utility.toInteger(array)
    end
end