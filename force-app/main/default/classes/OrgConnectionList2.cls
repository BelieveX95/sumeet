global with sharing class OrgConnectionList2 {
    
     @AuraEnabled(cacheable=true)
    global static List<Opportunity> getOpportunity(String accountId) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OrgConnection/services/apexrest/getDetailsX');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"accountId": "' + accountId + '"}');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        response = http.send(request);
        
        
        if (response.getStatusCode() == 200) {
            List<Opportunity> OpportunityList = (List<Opportunity>) JSON.deserialize(response.getBody(), List<Opportunity>.class);
            System.debug('OpportunityList List:@@ ' + OpportunityList);
            return OpportunityList;
        } else {
            return new List<Opportunity>();
        }
    }

}