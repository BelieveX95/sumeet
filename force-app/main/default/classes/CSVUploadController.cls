public with sharing class CSVUploadController {
    @AuraEnabled
    public static List<List<String>> processCSVFile(Id parentId, String fileContents) {
           system.debug('parentId==>'+parentId);
                system.debug('fileContents==>'+fileContents);

        List<List<String>> csvData = new List<List<String>>();
        
        try {
            // Split the fileContents by line to get rows
            List<String> rows = fileContents.split('\n');
            
            for (String row : rows) {
                List<String> columns = new List<String>();
                String[] values = row.split(',');
                columns.addAll(values);
                csvData.add(columns);
            }
            
        } catch (Exception e) {
            System.debug('Error processing CSV: ' + e.getMessage());
        }
                        system.debug('csvData==>'+csvData);

        return csvData;
    }}