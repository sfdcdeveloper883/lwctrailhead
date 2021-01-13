public class rotatedigits {
    public integer rotatedDigits(integer N) {
        integer result = 0;
        
        for(integer i=1; i<=N; i++){
            integer j=i;
            boolean contains347 = false;
            boolean contains2569 = false;
            while(j!=0){
                integer mod = Math.mod(j, 10);
                if(mod==2||mod==5||mod==6||mod==9){
                    contains2569=true;
                }
                
                if(mod==3||mod==4||mod==7){
                    contains347=true;
                }
                
                j=j/10;
            }
            
            if(!contains347&&contains2569){
                result++;
            }
        }
        
        return result;
    }
}