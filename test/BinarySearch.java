import java.util.ArrayList;
import java.util.HashMap;

public class BinarySearch {

    public static <E, T extends Comparable<T> > Integer binarySearch
        (ArrayList<HashMap<E, T > > patterns, T target, E attribute) {
        
        return binarySearch(patterns, target, attribute, 0, patterns.size()-1);
    }
     
    private static <E, T extends Comparable<T> > Integer binarySearch
        (ArrayList<HashMap<E, T > > patterns, T target, E attribute,
        int start, int end) {

        if(start > end) return null;
        
        // One element left lets check that element
        if(start == end) {
            if(patterns.get(start).get(attribute).compareTo(target) == 0) {
                // The last value is the one we are looking for
                return start;
            }
            return null; // The value is not here.
        }
        
        int middle = (start + end) / 2;
        int result = patterns.get(middle).get(attribute).compareTo(target);
        if (result > 0)
            return binarySearch(patterns, target, attribute, middle+1, end);
        else if(result < 0)
            return binarySearch(patterns, target, attribute, start, middle-1);
        return middle;
    }
}