public with sharing class ContactController {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, Object>> getRecordsAndFields(String objectName, String fieldSetName) {
    String query = 'SELECT Id, Name FROM ' + objectName;
    List<SObject> records = Database.query(query);

    List<Map<String, Object>> recordData = new List<Map<String, Object>>();

    Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
    Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
    Schema.FieldSet fieldSet = objectDescribe.FieldSets.getMap().get(fieldSetName);

    for (SObject record : records) {
      Map<String, Object> recordMap = new Map<String, Object>();
      recordMap.put('Id', record.get('Id'));
      recordMap.put('Name', record.get('Name'));
      

      if (fieldSet != null) {
        for (Schema.FieldSetMember field : fieldSet.getFields()) {
          String fieldName = field.getFieldPath();
          Object fieldValue = record.get(fieldName);
          recordMap.put(fieldName, fieldValue);
        }
      }

      recordData.add(recordMap);
    }

    return recordData;
  }
}