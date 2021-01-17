/*
sidhartha sankar
*/

public with sharing class BoatReviews {

	@AuraEnabled(cacheable=true)
	public static List<BoatReview__c> getAll(Id boatId){
		return 
			[SELECT 
				Id,
				Name,
				Comment__c,
				Rating__c,
				LastModifiedDate,
				CreatedDate,
				CreatedBy.Name,
				CreatedBy.CompanyName,
				CreatedBy.SmallPhotoUrl
			FROM BoatReview__c
			WHERE Boat__c = :boatId
			ORDER BY CreatedDate DESC];
	}

}
