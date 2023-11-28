public with sharing class ObjectListController {
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectNames() {
        List<String> objectNames = new List<String>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        
        for (String objectName : globalDescribe.keySet()) {
            objectNames.add(objectName);
        }
        system.debug('objectNames'+objectNames);
        return objectNames;
    }
    
    
    

    
public class CustomFieldDefinition {
    public String fieldType;
    public String fieldName;
    public String fieldLabel;
}



@AuraEnabled(cacheable=true)
public static String insertFields(String objectApiName, String fieldDefinitions, String fieldAPIName, String fieldLabel,String fieldType) {
    
            System.debug('objectApiName : ' + objectApiName);

        System.debug('fieldAPIName : ' + fieldAPIName);
    System.debug('fieldLabel : ' + fieldLabel);
    System.debug('fieldType : ' + fieldType);

    
    System.debug('fieldDefinitions : ' + fieldDefinitions);

    List<CustomFieldDefinition> customFields = (List<CustomFieldDefinition>) JSON.deserialize(fieldDefinitions, List<CustomFieldDefinition>.class);
        System.debug('customFields : ' + customFields);

    List<Map<String, Object>> customFieldList = new List<Map<String, Object>>();
    
    for (CustomFieldDefinition field : customFields) {
        Map<String, Object> customField = new Map<String, Object>();
        customField.put('fullName',field.fieldName );
        customField.put('label', field.fieldLabel);
        customField.put('type', field.fieldType);
        customFieldList.add(customField);
    }
            System.debug('customFieldList : ' + customFieldList);

    
    String endpoint = 'https://believe-dev-ed.develop.my.salesforce.com';
    
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v46.0/tooling/sobjects/CustomField');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');
    request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    request.setBody(JSON.serialize(customFieldList));
    
    HttpResponse response = http.send(request);
    System.debug('Response Body: ' + response.getBody());
    System.debug('HTTP Response Status: ' + response.getStatus());
    System.debug('HTTP Response Body: ' + response.getBody());
    
   if (response.getStatusCode() == 200) {
     return 'Custom fields created successfully.';
    } else {
        return 'Failed to create custom fields: ' ;
    }

}

}