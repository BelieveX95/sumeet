public with sharing class SalesAssistController {
    @AuraEnabled(cacheable=true)
    public static String makePostRequest(String apiKey, String apiSecret, String email, String mobileNumber, String name, String storeName) {
              
        String endpoint = 'https://platform.saleassist.ai/partners/workflows/onboard_web_store_to_new_client';
        
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('email', email);
        requestBody.put('mobile_number', mobileNumber);
        requestBody.put('name', name);
        requestBody.put('store_name', storeName);
        
        String jsonBody = JSON.serialize(requestBody);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('api_key', apiKey);
        request.setHeader('api_secret', apiSecret);
        request.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        
        
        System.debug('HTTP Response Code: ' + response.getStatusCode());
        System.debug('HTTP Response Body: ' + response.getBody());
        
        if (response.getStatusCode() == 200) {
            return response.getBody(); 
        } else {
            String errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
            System.debug('Error Message: ' + errorMessage);
            return errorMessage;
        }
    }
}