public with sharing class MetadataController {
    @AuraEnabled(cacheable=true)
    public static List<ClienEditSuitability__mdt> getOccupationOptions() {
        List<ClienEditSuitability__mdt> options = [SELECT MasterLabel, Employeed__c, EmplyoyerName__c, Industry__c, Occupataion__c, Self_Employeed__c FROM ClienEditSuitability__mdt];
        return options;
    }
}