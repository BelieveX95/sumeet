@RestResource(urlMapping='/v1/accountRecordCreate/*')
global class AccountCreateAPI {
    @HttpPost
    global Static string createAccount(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string jsonString=req.requestBody.tostring();
        System.debug('JsonString-->>'+jsonString);
        responseWrapper wResp=(responseWrapper) JSON.deserialize(jsonString,responseWrapper.class);
        System.debug('WResp-->>'+wResp);
        Account acc=new Account();
        acc.Name=wResp.wName;
        acc.Phone=wResp.wPhone;
        Insert acc;
//        acc.External_ID__c = acc.Id;  
   //     update acc;
        system.debug('after insert acc is :'+acc);
        return 'Success';
    }
   
    public class responseWrapper{
        public string wName;
        public string wPhone;
    }
   
    // Add the following method for update operation
    @HttpPatch
    global static String updateAccount() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jsonString = req.requestBody.toString();
        System.debug('JsonString update is-->>' + jsonString);
        ResponseWrapper2 wResp2 = (ResponseWrapper2) JSON.deserialize(jsonString, ResponseWrapper2.class);
        System.debug('WResp2 update is:-->>' + wResp2);
        String externalId = wResp2.sId;
        system.debug('externalId is:'+externalId);
        Account acc = [SELECT Id, Name, Phone FROM Account WHERE Id = :externalId];
        acc.Name = wResp2.sName;
        acc.Phone = wResp2.sPhone;
        system.debug('acc update is:'+acc);
        Update acc;
        return 'Success';
    }
   
    // Add the following inner class for update operation
    public class ResponseWrapper2 {
        public String sId;
        public String sName;
        public String sPhone;
    }
}