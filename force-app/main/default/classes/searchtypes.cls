public class searchtypes {
    

    
    public static String findPrefix(String[] args) {
        if(args == null || args.size() == 0) {
            return '';
        }
        String lcp = args[0];
        for(Integer i = 1;i< args.size(); i++) {
            String currentword = args[i];
            integer j = 0;
            while(j < currentword.length() && j < lcp.length() && currentword.charAt(j) == lcp.charAt(j)) {
                j++;
            }
            if(j == 0){
                return '';
            }
            lcp = currentword.substring(0,j);
        }
        return lcp;
    }
    public static integer BinarySearch(integer[] array1, integer item)
    {
        integer left = 0;
        integer right = array1.size() - 1;
        
        while (left <= right)
        {
            integer middle = (left + right) / 2;
            system.debug(middle);
            if (array1[middle] == item)
                return middle;
            
            if (item < array1[middle]){
                right = middle - 1;
            system.debug(right);
            }
            else{
                left = middle + 1;
            system.debug(left);
            }
        }
        
        return -1;
    }
}