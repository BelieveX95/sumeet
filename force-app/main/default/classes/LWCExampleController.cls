public inherited sharing class LWCExampleController {
    
    /*   @AuraEnabled
public static List<List<SObject>> readCSVFile(Id idContentDocument) {
List<Account> lstParentAccsToInsert = new List<Account>();
List<Order> lstOrderToInsert = new List<Order>();
List<Account> lstAccsToInsert = new List<Account>();

if (idContentDocument != null) {
// getting File Data based on document id
ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId = :idContentDocument];
// split the file data
List<String> lstCSVLines = objVersion.VersionData.toString().split('\n');

for (Integer i = 1; i < lstCSVLines.size(); i++) {
Account objPAcc = new Account();
List<String> csvRowData = lstCSVLines[i].split(',');
System.debug('csvRowData====> ' + csvRowData);
objPAcc.Name = csvRowData[0]; // accName
lstParentAccsToInsert.add(objPAcc);
System.debug('lstParentAccsToInsert====> ' + lstParentAccsToInsert);
}

for (Integer i = 1; i < lstCSVLines.size(); i++) {
Account objAcc = new Account();
List<String> csvRowData = lstCSVLines[i].split(',');
System.debug('csvRowData====> ' + csvRowData);
objAcc.Name = csvRowData[1];
objAcc.Industry = csvRowData[2];
objAcc.Rating = csvRowData[3];
objAcc.Type = csvRowData[4];
objAcc.Website = csvRowData[5];
lstAccsToInsert.add(objAcc);
System.debug('lstAccsToInsert====> ' + lstAccsToInsert);
}

for (Integer i = 1; i < lstCSVLines.size(); i++) {
Order odr = new Order();
List<String> csvRowData = lstCSVLines[i].split(',');
System.debug('csvRowData====> ' + csvRowData);
//  odr.EffectiveDate = system.today();
odr.Status =csvRowData[7];
odr.ContractId =csvRowData[8];

lstOrderToInsert.add(odr);
System.debug('lstOrderToInsert====> ' + lstOrderToInsert);
}
}

// Return all three lists in a list
List<List<SObject>> resultList = new List<List<SObject>>();
resultList.add(lstParentAccsToInsert);
resultList.add(lstAccsToInsert);
resultList.add(lstOrderToInsert);

return resultList;
}

*/   
    
    @AuraEnabled
    public static void insertCSVFile(list<Account> accList){
        system.debug('accList'+accList);
        
        try{    
            if(!accList.isEmpty()) {
                insert accList;
                system.debug('accList'+accList);
            }
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }     
    }
    
    
    
    @AuraEnabled
    public static void documentIdapx(Id idContentDocument){
        system.debug('idContentDocument'+idContentDocument);
        List<contentdocument> clist =[SELECT Id FROM contentdocument WHERE Id =:idContentDocument ];
        system.debug('clist'+clist);
        delete clist;
    }
    
    
    @AuraEnabled
    public static List<MyDataWrapper> readCSVFilex(Id idContentDocument) {
        List<MyDataWrapper> mergedData = new List<MyDataWrapper>();
        
        if (idContentDocument != null) {
            // getting File Data based on document id
            ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId = :idContentDocument];
            // split the file data
            List<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
            
            for (Integer i = 1; i < lstCSVLines.size(); i++) {
                List<String> csvRowData = lstCSVLines[i].split(',');
                //System.debug('csvRowData : '+csvRowData);
                MyDataWrapper dataWrapper = new MyDataWrapper();
                if(!csvRowData.isEmpty()){
                     System.debug(' ===> csvRowData : '+csvRowData);
                    
                  
                    dataWrapper.CompanyName = csvRowData[0];
                    dataWrapper.PartName = csvRowData[1];
                    dataWrapper.VoucherNumber = csvRowData[2];
                    dataWrapper.VoucherType = csvRowData[3];
                    dataWrapper.Amount = csvRowData[4];
                    dataWrapper.Quantity = csvRowData[5];
                    dataWrapper.Guid =csvRowData[6];
					
                }
              
                mergedData.add(dataWrapper);
                system.debug('wrapdata'+mergedData);
            }
        }
        
        return mergedData;
    }
    public class MyDataWrapper {
        @AuraEnabled
        public String CompanyName { get; set; }
        @AuraEnabled
        public String PartName { get; set; }
        @AuraEnabled
        public String VoucherNumber { get; set; }
        @AuraEnabled
        public String VoucherType { get; set; }
        @AuraEnabled
        public String Amount { get; set; }
        @AuraEnabled
        public String Quantity { get; set; }
        @AuraEnabled
        public String Guid{get;set;}
    }
    
    
}