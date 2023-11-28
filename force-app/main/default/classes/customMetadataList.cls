public class customMetadataList {
     @AuraEnabled( cacheable=true )  
    public static List < Mapping_Object__mdt > getRecords() {
        
        List < Mapping_Object__mdt > mObjList = [ SELECT Id, Template_Name__c,Source_Object__c, Destination_Object__c FROM Mapping_Object__mdt ];
        system.debug('mObjList from apex'+mObjList);
        system.debug('mObjList from apexSize()==' +mObjList.size());

        return mObjList;
        
        
    }
    
    @AuraEnabled(cacheable=true)
    public static void  getAccount(){
    List<Account> acc = [SELECT Id , Name ,Phone,Rating,Fax,Website,Type,Types__C,Industry  FROM Account];
      system.debug('mObjList from apex'+acc);
        system.debug('mObjList from apexSize()==' +acc.size());  
        
                customMetadataList.getRecords();
                        customMetadataList.getContact();
                customMetadataList.getOppp();


    }
    @AuraEnabled(cacheable=true)
    public static void  getContact(){
    List<Contact> acc = [SELECT Id , Name ,Phone,Email  FROM Contact];
      system.debug('mObjList from apex'+acc);
        system.debug('mObjList from apexSize()==' +acc.size());  
        
                customMetadataList.getRecords();

    }
    
     @AuraEnabled(cacheable=true)
    public static void  getOppp(){
    List<Opportunity> acc = [SELECT Id , Name,stageName, closedate  FROM Opportunity];
      system.debug('mObjList from apex'+acc);
        system.debug('mObjList from apexSize()==' +acc.size());  
        
                customMetadataList.getRecords();

    }
}

/*
 List<Mapping_Object__mdt> moList = Mapping_Object__mdt.getAll().Values();
system.debug('moList'+moList);

String data;
string Name;
String LangGuage;
data = moList[0].Id;
system.debug('data'+data);
Name = moList[0].Template_Name__c;
system.debug('Name'+Name);

for (Mapping_Object__mdt mdt :moList ){
    LangGuage = mdt.Language;
    system.debug('LangGuage===='+LangGuage);
}

List<Mapping_Object__mdt> newMap = [SELECT id,Template_Name__c,Language
                                    FROM Mapping_Object__mdt];
System.debug('SOQL newMap'+newMap);



 */