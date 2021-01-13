public class APICallOutUtility {
    
     public static String getLoginIdToken(string operator,CallOutService__mdt custommetadata) {
             string accessToken;
        //Getting the access token from org cache
        accessToken = (String)Cache.Org.get('tokenId'+operator+custommetadata.Environment__c);            
        //Making the call out to get access token if it is lost in cache.
        if (accessToken == null) {
            system.debug('cache lost');
            
            // Setting operator parameter dynamically to the end point fetched from the named credential.
            String urlParameterString = 'customerCode=10000007951&brandCode=';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(
                String.format(
                    'callout:'+custommetadata.NamedCred__c+'/{0}?{1}',
                    new String[]{'oauthTokens', urlParameterString}
                )
            );
            
            
            req.setHeader('userName', '{!$Credential.Username}');
            req.setHeader('password', '{!$Credential.Password}');
            System.debug('username '+req.getHeader('password'));

            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            String resStr =  res.getBody();
            System.debug('>>>access token end point : ' + req.getEndpoint());
            System.debug('>>>getLoginIdToken : ' + resStr +'nive');
            Map<String,Object> mapResponse = (Map<String,Object>)JSON.deserializeUntyped(resStr);
            accessToken = (String)mapResponse.get('idToken');
            
            if(accessToken != null){
                Cache.Org.put('tokenId'+operator+custommetadata.Environment__c, accessToken,6900);
            }
        } 
        return  accessToken;
            
         
     }
    
    public static CallOutService__mdt getCalloutServicesMetadataValue(String strObjectName,String strModuleName){        
        CallOutService__mdt callOutServicesMetadataDetails  = [select MasterLabel,Environment__c,End_point_URL__c, Timeout__c, Authorization_Key__c,Apex_Timeout__c,NamedCred__c
                                                               from CallOutService__mdt where Active__c = TRUE and MasterLabel = :strObjectName and Module__c = :strModuleName limit 1];       
        return callOutServicesMetadataDetails;
    } 
    
}