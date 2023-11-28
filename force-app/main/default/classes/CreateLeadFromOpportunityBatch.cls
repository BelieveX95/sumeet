global class CreateLeadFromOpportunityBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date oneYearAgo = Date.today().addYears(-1);
        return Database.getQueryLocator([
            SELECT Id, Name, CreatedDate, AccountId, Amount, CloseDate
            FROM Opportunity
            WHERE YearCheck__c <= :oneYearAgo
        ]);
    }
    

    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        List<Lead> leadsToInsert = new List<Lead>();
        
        for (Opportunity opp : scope) {
            Lead lead = new Lead();
            lead.FirstName = 'New Lead'; 
            lead.LastName = 'From Opportunity';
            lead.Company = 'Believe';
            lead.State ='Open - Not Contacted';
        
            leadsToInsert.add(lead);
            
        }
        
        // Insert the created Leads
        if (!leadsToInsert.isEmpty()) {
            insert leadsToInsert;
            
            system.debug('leadsToInsert'+leadsToInsert);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}