public with sharing class ProductController {
    @AuraEnabled (cacheable=true)
    public static List<Product2> getAllProducts(){
        return [SELECT Id, Name FROM Product2];
    }
}