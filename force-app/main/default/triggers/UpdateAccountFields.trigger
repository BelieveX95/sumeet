trigger UpdateAccountFields on Account (before insert) {
    Map<String, ClienEditSuitability__mdt> metadataMap = new Map<String, ClienEditSuitability__mdt>();
    for (ClienEditSuitability__mdt metadataRecord : [SELECT MasterLabel,Employeed__c ,EmplyoyerName__c,Industry__c,Occupataion__c,Self_Employeed__c FROM ClienEditSuitability__mdt]) {
        metadataMap.put(metadataRecord.MAsterLabel, metadataRecord);
    }

    for (Account acc : Trigger.new) {
        if (metadataMap.containsKey(acc.Name)) {
            ClienEditSuitability__mdt metadataRecord = metadataMap.get(acc.Name);

            if (acc.Employee_Satus__c == metadataRecord.MAsterLabel) {
                
             
            }
        }
    }
}