/*------------------------------------------------------------
This class provides the background logic to broadcast LITN component.

<Date>      <Authors Name>      <Brief Description of Change>
10/13/2020  TPCP Team                  10/28(20.14 tpcp Release)
------------------------------------------------------------*/
public with sharing class TPCP_BroacastMessageDisplay {
    
    
    
     @AuraEnabled
    public static List<String> getTPCP_AlertMessageDisplay() {
         system.debug(System.today()+'Message entry :--- '+System.now());
         
         list<account> allAlertRecord=[select Name from account where IsActive__c=true];       
        List<String> alertActiveRecords= new List<String>();
       
        if(allAlertRecord.size() > 0) {
        	for(account artmes:allAlertRecord)
            {
                alertActiveRecords.add(artmes.Name);
            }
        }                
         return alertActiveRecords;        
    }
    
    
    

}