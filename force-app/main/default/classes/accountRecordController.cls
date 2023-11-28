public class accountRecordController {

   @AuraEnabled(cacheable=true)
public static List<AccountWrapper> getAccountRecord(){
    List<Account> accList = [SELECT Id, Name, Phone, Type,NumberOfContacts__c FROM Account];
    List<AccountWrapper> accountWrappers = new List<AccountWrapper>();
    
    for (Account account : accList) {
        Integer contactSize = [SELECT COUNT() FROM Contact WHERE AccountId = :account.Id];
        AccountWrapper wrapper = new AccountWrapper(account, contactSize);
        accountWrappers.add(wrapper);
    }
    
    return accountWrappers;
}



   @AuraEnabled(cacheable=true)
   public static List<Account> accountDetails(string accountId){
       List<Account> acList = [SELECT Id,Name,Phone, Type,Rating,Website FROM Account WHERE Id = :accountId];
       System.debug('acList'+acList);
       return acList;
   }


   @AuraEnabled(cacheable=true)
   public static List<contact> getContacts(string accountId){
       List<contact> conList =[SELECT id, LastName, Phone,Email FROM Contact WHERE accountId =:accountId];
       System.debug('Contaact Details'+conList);
       return conList;
   }

@AuraEnabled
public static void saveContacts(Id accountId, List<Contact> contacts) {
    List<Contact> newContacts = new List<Contact>();
    
    for (Contact contact : contacts) {
        Contact newContact = new Contact();
        
        newContact.LastName =contact.LastName;
        newContact.Phone = contact.Phone;
        newContact.Email = contact.Email;
        
        newContact.AccountId = accountId;
        
        newContacts.add(newContact);
    }
    
    try {
        insert newContacts;
        System.debug('New contacts added successfully.');
    } catch (Exception e) {
        System.debug('Error occurred while adding new contacts: ' + e.getMessage());
        throw new AuraHandledException('Error occurred while adding new contacts: ' + e.getMessage());
    }
}


@AuraEnabled(cacheable=true)
public static List<Opportunity> getOpportunity(string accountId){
    List <Opportunity> opList = [SELECT id, Name, StageName, CloseDate, Amount from Opportunity WHERE accountId = :accountId];
    return opList;
}

public class AccountWrapper {
    @AuraEnabled
    public Account account;
    @AuraEnabled
    public Integer contactSize;

    public AccountWrapper(Account account, Integer contactSize) {
        this.account = account;
        this.contactSize = contactSize;
    }
}


}