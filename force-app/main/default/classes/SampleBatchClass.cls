public class SampleBatchClass implements Database.Batchable<sObject>, Database.Stateful {
    Integer deletedRec; 

    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date oneMonthAgo = Date.today().addMonths(-1);
        
        return Database.getQueryLocator('SELECT Id, ExpiryDate__c FROM Contact WHERE ExpiryDate__c <= :oneMonthAgo');
    }

    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        deletedRec = [SELECT COUNT() FROM Contact WHERE isDeleted = TRUE];
        System.debug('Deleted Records Count: EXECUTE ' + deletedRec);

        delete scope;
        
        deletedRec += scope.size();
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Deleted Records Count: ' + deletedRec);
    }
}