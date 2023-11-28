global with sharing class CaseIntegrationClass {
    
    @AuraEnabled(cacheable=true)
    global static List<Case> getCases() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:OrgConnection/services/apexrest/getCaseDetails');
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        
        response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            List<Case> csList = (List<Case>) JSON.deserialize(response.getBody(), List<Case>.class);
            System.debug('csList:::' + csList);
            return csList;
        } else {
            return new List<Case>();
        }
    }
    
    @AuraEnabled
    global static void updateCase(String caseId, String product, String subject) {
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:OrgConnection/services/apexrest/getCaseDetails');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            
            Map<String, Object> caseData = new Map<String, Object>();
            caseData.put('caseId', caseId);
            caseData.put('product', product);
            caseData.put('subject', subject);
            
            String requestBody = JSON.serialize(caseData);
            request.setBody(requestBody);
            
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            
            response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                System.debug('Case updated successfully');
            } else {
                System.debug('Error updating case. StatusCode: ' + response.getStatusCode() + ', Message: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Error updating case: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    global static List<String> getProductOptions() {
        List<String> options = new List<String>();
        options.add('GC1040' );
        options.add('GC1060');
        options.add('GC3020');
        options.add('GC3040');
        options.add('GC3060');
        options.add('GC5020');
        options.add('GC5040');
        options.add('GC5060');
        options.add('GC1020');
        
        return options;
    }
}