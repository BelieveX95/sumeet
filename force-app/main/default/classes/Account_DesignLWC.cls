public with sharing class Account_DesignLWC {

    @AuraEnabled(cacheable=true)
    public static List<RecordWrapper> getDataWithFieldSet(String fieldSet, String obj) {
        SObjectType objType = Schema.getGlobalDescribe().get(obj);
        String query = 'SELECT ';

        Schema.FieldSet fieldSetObj = objType.getDescribe().fieldSets.getMap().get(fieldSet);

        if (fieldSetObj != null && !fieldSetObj.getFields().isEmpty()) {
            for (Schema.FieldSetMember fld : fieldSetObj.getFields()) {
                query += fld.getFieldPath() + ', ';
            }
            query = query.removeEnd(', ');
        } else {
            for (Schema.SObjectField fld : objType.getDescribe().fields.getMap().values()) {
                query += fld.getDescribe().getName() + ', ';
            }
            query = query.removeEnd(', ');
        }

        query += ' FROM ' + obj; 

        System.debug('getDataWithFieldSet Query: ' + query);

        List<SObject> records = Database.query(query);
        List<RecordWrapper> recordWrappers = new List<RecordWrapper>();

        for (SObject record : records) {
            recordWrappers.add(new RecordWrapper(record));
        }

        return recordWrappers;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getLabels(String obj) {
        Map<String, String> mapName = new Map<String, String>();
        Map<String, Schema.SObjectType> describeResult = Schema.getGlobalDescribe();

        for (Schema.SObjectField strFld : describeResult.get(obj).getDescribe().fields.getMap().values()) {
            mapName.put(strFld.getDescribe().getName(), strFld.getDescribe().getLabel());
        }

        System.debug('getLabels Map: ' + mapName);

        return mapName;
    }

    public class RecordWrapper {
        @AuraEnabled
        public Map<String, Object> dataMap;

        public RecordWrapper(SObject record) {
            dataMap = new Map<String, Object>();
            for (String fieldName : record.getPopulatedFieldsAsMap().keySet()) {
                dataMap.put(fieldName, record.get(fieldName));
            }
        }
    }
}