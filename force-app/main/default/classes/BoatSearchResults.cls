public with sharing class BoatSearchResults {
	
	@AuraEnabled(cacheable=true)
	public static List<Boat__c> getBoats(String boatTypeId){
		String boatQuery = 
			  'SELECT '
			+ ' Id, Name, Picture__c, Contact__r.Name, '
			+ ' Geolocation__latitude__s, Geolocation__longitude__s '
			+ 'FROM Boat__c '
			+ (String.isNotBlank(boatTypeId) ? 
				' WHERE BoatType__c = :boatTypeId ' :
				'');
		return Database.query(boatQuery);
	}

	@AuraEnabled(cacheable=true)
	public static Boat__c getBoatById(String boatId) {
		return [
			SELECT 
				Id, Name, Description__c, Price__c, Length__c, 
				BoatType__r.Name, Picture__c, Contact__r.Name,
				Contact__r.Email, Contact__r.HomePhone
			FROM Boat__c 
			WHERE Id = :boatId
			LIMIT 1
		];
	}

}