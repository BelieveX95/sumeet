public class AuraDesignApexClass {
    @AuraEnabled(cacheable=true)
    
    public static List<TableRow> getRecord(String objectName, String fieldNames) {
        List<TableRow> recordData = new List<TableRow>();
        
        try {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
            if (objectType != null) {
                String[] fields = fieldNames.split(',');
                
                String query = 'SELECT ';
                for (String fieldName : fields) {
                    query += fieldName + ', ';
                }
                query = query.substring(0, query.length() - 2);
                query += ' FROM ' + objectName;
                
                List<SObject> records = Database.query(query);
                
                for (SObject record : records) {
                    TableRow row = new TableRow();
                    for (String fieldName : fields) {
                        if (record.get(fieldName) != null) {
                            row.values.add(String.valueOf(record.get(fieldName)));
                        } else {
                            row.values.add('');
                        }
                    }
                    recordData.add(row);
                }
            }
        } catch (Exception e) {
            System.debug('Error occurred: ' + e.getMessage());
        }
        
        return recordData;
    }
    
    public class TableRow {
        @AuraEnabled
        public List<String> values;
        
        public TableRow() {
            values = new List<String>();
        }
    }
}