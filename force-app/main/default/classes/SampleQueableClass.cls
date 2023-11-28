public class SampleQueableClass implements Queueable {
    
    private List<Account> accounts;
    
    public SampleQueableClass(List<Account> accounts) {
        this.accounts = accounts;
    }
    
    public void execute(QueueableContext context) {
        List<Contact> conList = new List<Contact>();
        
        for (Account acc : accounts) {
            Contact newContact = new Contact();
            newContact.FirstName = 'Test Q2'; 
            newContact.LastName = 'QRest2'; 
            newContact.AccountId = acc.Id;
            
            conList.add(newContact);
        }
        
        if (!conList.isEmpty()) {
            system.debug('conList==='+conList);
            system.debug('conList==='+conList.size());
            
            insert conList;
        }
    }
}


/*
List<Contact> conList = new List<Contact>();
for(Integer i=0;i<100;i++){
Contact con = new Contact();
con.LastName= 'Test' + i + 'Batch';
con.ExpiryDate__c = Date.valueOf('2023-06-01');
conList.add(con);
}
Insert conList;
system.debug('conList'+conList.size());


SampleBatchClass batch1 = New SampleBatchClass();
Database.executeBatch(batch1);

List<Account> accountList = [SELECT Id FROM Account LIMIT 5]; 
system.debug('accountList'+accountList);
SampleQueableClass queueableInstance = new SampleQueableClass(accountList);
System.enqueueJob(queueableInstance);
*/