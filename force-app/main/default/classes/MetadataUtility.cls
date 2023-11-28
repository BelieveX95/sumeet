public class MetadataUtility{
    @AuraEnabled(cacheable=true)

    public static void generateField(String objectAPIName, String fieldAPIName, String fieldDescription, String fieldLabel,String fieldType){

        system.debug('objectAPIName-->'+ objectAPIName);
        system.debug('fieldAPIName-->'+ fieldAPIName);
        system.debug('fieldDescription-->'+ fieldDescription);
        system.debug('fieldLabel-->'+ fieldLabel);
        system.debug('fieldType-->'+ fieldType);



        String metadata ;
        if(fieldType == 'Html' || fieldType == 'LongTextArea'){
            System.debug('HimaHtml1');
           metadata = '{"Metadata" : {"type" : "'+fieldType+'","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'","length" : 32768,"required" : false, "visibleLines":30}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }

        if(fieldType == 'STRING' ){
             System.debug('HimanshuKunjjjjTest1111111');
            metadata = '{"Metadata" : {"type" : "Text","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'","length" : 255,"required" : false}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }
        //"PICKLIST"
        if(fieldType == 'PICKLIST' ){
            System.debug('HimanshuKuPickListTest1111111');
            metadata = '{"Metadata" : {"type" : "PICKLIST","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'",required" : false, "value": "Test", "isActive": true, "sorted": false}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }

        //""DATE""
        if(fieldType == 'DATE' ){
            System.debug('HimanshuKuPict1DATE');
            metadata = '{"Metadata" : {"type" : "Date","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'",required" : false, "value": "Test"}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }
       
        //"""EMAIL"""
        if(fieldType == 'EMAIL' ){
            System.debug('HimanshuKuPict1EMAIL');
            metadata = '{"Metadata" : {"type" : "'+fieldType+'","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'",required" : false}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }
        //"""Phone"""
        if(fieldType == 'PHONE' ){
            System.debug('HimanshuKuPict1EMAIL');
            metadata = '{"Metadata" : {"type" : "'+fieldType+'","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'",required" : false}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }
        //""""DOUBLE""""
        if(fieldType == 'DOUBLE' ){
            System.debug('HimanshuKuPict1EMAIL');
            metadata = '{"Metadata" : {"type" : "Number","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'",required" : false, "Length":18, "DecimalPlaces": 0}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }

        else{
            System.debug('HimanshuKunjjjjTest22222222');
            metadata = '{"Metadata" : {"type" : "'+fieldType+'","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'","length" : 255,"required" : false, "value": "Test"}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }
       
        String responseBody = createField(metadata);
    }
    @AuraEnabled
    public static void generateFormulaField(String objectAPIName, String fieldAPIName, String fieldDescription, String fieldLabel, String retrunType, String validFormula){
       
        String metadata = '{"Metadata" : {"type" : "'+retrunType+'","description" : "'+fieldDescription+'", "formula" : "'+String.escapeSingleQuotes(validFormula)+'","formulaTreatBlanksAs" : "BlankAsZero","label" : "'+fieldLabel+'"}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        String responseBody = createField(metadata);
        system.debug(responseBody);
    }
    @AuraEnabled
    public static String createField(String metadata) {
        
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
String restAPIURL = sfdcURL + '/services/data/v29.0/sobjects/CustomField';  
  system.debug('restAPIURL'+restAPIURL);

        
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        

       System.debug('-UserInfo--'+UserInfo.getSessionID());
        System.debug('-UserInfo--'+UserInfo.getSessionID().substring(15));


        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(restAPIURL);
        request.setMethod('POST'); System.debug('--URL-'+URL.getSalesforceBaseUrl().toExternalForm());
        request.setBody(metadata);
        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(res.getBody());
        return res.getBody();
    }
}