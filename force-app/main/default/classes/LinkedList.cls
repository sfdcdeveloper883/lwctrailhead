public class LinkedList {
    SearchNode.Node head;
    
    
    public void add(integer data) {
        system.debug('head: ' + head);
        SearchNode.Node nod = new SearchNode.Node(data);
        if(head == null) {
            head = nod;
        } else{
            SearchNode.Node n = head;
            while(n.next !=null) {
                n = n.next;
            }
            n.next = nod;
        }
    }
    
    public void show() {
        SearchNode.Node node = head; 
        while(node.next != null) {
            system.debug('node data: ' + node.data);
            node = node.next;
        }
        system.debug('node data: ' + node.data);
    }
    
    public void insertAt(integer index, integer data) {
        SearchNode.Node nod = new SearchNode.Node(data);
        nod.next = null;
        SearchNode.Node node = head; 
        for(integer i=0; i<index-1;i++) {
             node = node.next;
        }
        nod.next = node.next;
        node.next = nod;
    }
    
    public void deleteAt(integer index) {
        if(index==0)
        {
            head = head.next;
        }
        else
        {
            SearchNode.Node n = head;
            SearchNode.Node n1 = null;
            for(integer i=0;i<index-1;i++)
            {
                n = n.next;
            }
            n1 = n.next;
            n.next = n1.next;
            n1 = null;
        }
    }
    
    public void insertAtStart(Integer data) {
        SearchNode.Node nod = new SearchNode.Node(data);
        nod.next = head;
        head = nod;
    }
}