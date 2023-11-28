public class SampleBatchClass2 implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Amount, StageName FROM Opportunity]);
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        List<Opportunity> opList = new List<Opportunity>();
        
        for (Opportunity opp : scope) {
            if (opp.Amount > 1000) {
                opp.StageName = 'In Progress';
                opList.add(opp);
            }
        }
        
        update opList;
    }

    public void finish(Database.BatchableContext BC) {
         Integer successCount = 0;
        Integer failCount = 0;
        
        successCount = [SELECT COUNT() FROM Opportunity WHERE StageName = 'In Progress'];
        failCount = [SELECT COUNT() FROM Opportunity WHERE StageName != 'In Progress'];

        System.debug('Success Count: ' + successCount);
        System.debug('Fail Count: ' + failCount);
    }
}