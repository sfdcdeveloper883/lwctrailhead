public class SearchNode {
    public class Node{  
        public integer data;  
        public Node next;  
        public Node(integer data) {  
            this.data = data;  
        }  
    }
    
    //Declaring head and tail pointer as null.  
    public Node head = null;  
    public Node tail = null;  
    
    //This function will add the new node at the end of the list.  
    public void add(integer data){  
        //Create new node  
        Node newNode = new Node(data);  
        //Checks if the list is empty.  
        if(head == null) {  
            //If list is empty, both head and tail would point to new node.  
            head = newNode;  
            tail = newNode;  
            newNode.next = head;  
        }  
        else {  
            //tail will point to new node.  
            tail.next = newNode;  
            //New node will become new tail.  
            tail = newNode;  
            //Since, it is circular linked list tail will point to head.  
            tail.next = head;  
        }
        system.debug('head: ' + head);
        system.debug('tail: ' + tail);
    } 
    
    //Searches for a node in the list  
    public void search(integer element) {  
        Node current = head;  
        integer i = 1;  
        boolean flag = false;  
        //Checks whether list is empty  
        if(head == null) {  
            System.debug('List is empty');  
        }  
        else {  
            do{  
                //Compares element to be found with each node present in the list  
                if(current.data ==  element) {  
                    flag = true;  
                    break;  
                }  
                current = current.next;  
                i++;  
            }while(current != head);  
            if(flag)  
                System.debug('Element is present in the list at the position : '+ i);  
            else  
                System.debug('Element is not present in the list');  
        }  
    }
}