global with sharing class OrgConnectionList {
    
    @AuraEnabled(cacheable=true)
    global static List<Account> getAccount() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OrgConnection/services/apexrest/getDetails');
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        response = http.send(request);              
        if (response.getStatusCode() == 200) {
            List<Account> accountList = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class);
            System.debug('Account List:## ' + accountList);
            return accountList;
        } else {
            return new List<Account>();
        }
    }
    
    @AuraEnabled(cacheable=true)
    global static List<Contact> getContact(String accountId) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OrgConnection/services/apexrest/getDetails');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"accountId": "' + accountId + '"}');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        response = http.send(request);
        
        
        if (response.getStatusCode() == 200) {
            List<Contact> contactList = (List<Contact>) JSON.deserialize(response.getBody(), List<Contact>.class);
            System.debug('Contact List:@@ ' + contactList);
            return contactList;
        } else {
            return new List<Contact>();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounthisOrg(){
        List<Account> aclist = [SELECT id,Name,Phone FROM Account];
        
        return acList;
    }

}

/*

global class OrgConnectionList implements Database.Batchable<sObject> ,Database.AllowsCallouts{
global Database.QueryLocator start(Database.BatchableContext BC) {
return Database.getQueryLocator('SELECT Id,Name FROM Account');
}

global void execute(Database.BatchableContext BC, List<sObject> scope) {
HttpRequest request = new HttpRequest();
request.setEndpoint('callout:OrgConnection/services/apexrest/getDetails');
request.setMethod('GET');

HttpResponse response = new HttpResponse();
Http http = new Http();

response = http.send(request);
if (response.getStatusCode() == 200) {
List<Account> accountList = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class);
System.debug('Account List In EXECUTE:## ' + accountList);
System.debug('Account List Size:## ' + accountList.size());            
}
}

global void finish(Database.BatchableContext BC) {

}
}*/