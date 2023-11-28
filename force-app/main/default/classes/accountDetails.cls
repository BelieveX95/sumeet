public class accountDetails {
    @AuraEnabled
    public static List<Account> getAccountDetails(Id opportunityId) {
        Opportunity opp = [SELECT Id, Types__c, AccountId, Account.Name, Account.Types__c 
                           FROM Opportunity WHERE Id = :opportunityId];
        
        if (opp.AccountId != null) {
            List<Account> accounts = [SELECT Id, Name, Types__c 
                                      FROM Account WHERE Types__c = :opp.Types__c];
            return accounts;
        }
        
        return new List<Account>();
        
    }
    
    @AuraEnabled
    public static List<Account> searchAccountsByType(String searchKey) {
        List<Account> accounts = [SELECT Id, Name, Types__c 
                                  FROM Account WHERE Types__c = :searchKey];
        return accounts;
    }
    
    @AuraEnabled
    public static List<Account> searchAccountsInDetails(String searchKey, List<Account> accountList) {
        List<Account> filteredAccounts = new List<Account>();
        if (String.isBlank(searchKey)) {
            return accountList;
        }
        for (Account acc : accountList) {
            if (acc.Name != null && acc.Name.toLowerCase().contains(searchKey.toLowerCase())) {
                filteredAccounts.add(acc);
            }
        }
        return filteredAccounts;
    }
    
    @AuraEnabled
    public static void updateOpportunityAccount(Id opportunityId, Id accountId) {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :opportunityId];
        
        if (opp.AccountId != accountId) {
            opp.AccountId = accountId;
            update opp;
        }
    }
    
    @AuraEnabled
    public static Account saveAccount(Account account) {
        try {
            insert account;
            return account;
        } catch (Exception e) {
            System.debug('Error creating account: ' + e.getMessage());
            throw e;
        }
    }
    
    @AuraEnabled
    public static void updateOpportunity(Id opportunityId, Id accountId) {
        try {
            Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :opportunityId];
            if (opp.AccountId != accountId) {
                opp.AccountId = accountId;
                update opp;
            }
        } catch (Exception e) {
            System.debug('Error updating Opportunity: ' + e.getMessage());
            throw e;
        }
    }
}