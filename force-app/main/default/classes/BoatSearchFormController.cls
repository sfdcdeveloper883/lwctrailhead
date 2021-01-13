public with sharing class BoatSearchFormController {
	
	@AuraEnabled(cacheable=true)
	public static List<BoatType__c> getAllBoatTypes(){
		return [SELECT Id, Name FROM BoatType__c ORDER BY Name ASC];
	}

}