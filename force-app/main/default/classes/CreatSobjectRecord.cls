public class CreatSobjectRecord {
    public static Id createSObjectRecord(String objectName, Map<String, Object> recordDetails) {
        // Create an SObject instance based on the object name
        SObject newRecord = (SObject) Type.forName('Schema.' + objectName).newInstance();
        
        // Populate the SObject fields with the provided record details
        for (String fieldName : recordDetails.keySet()) {
            newRecord.put(fieldName, recordDetails.get(fieldName));
        }
        
        // Insert the new record
        try {
            insert newRecord;
            return newRecord.Id;
        } catch (DmlException e) {
            // Handle any exceptions or errors that occur during record creation
            System.debug('Error creating record: ' + e.getMessage());
            return null;
        }
    }
    
}