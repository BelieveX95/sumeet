public class SH_AccountUpdateAPI {
    private static String clientId = '3MVG9n_HvETGhr3BKwgrajgWcEILTwl5gaXZHCMzwnXxu6mpdcserNWdG2Jvq1Z1RNwr2XjJ8CCp4casDint4';
    private static String clientSecret = 'E5B243DD4D4A11412AB713AD89B35260D54B3FC2DBA66A3100DE831C8A1515BA';
    private static String username = 'sumitnagar@crmlanding.com';
    private static String password = 'Crmlanding23Av8bBroiwaGmuTjt7YKM6hSHo';
   
    public class ResWrapper {
        public String id;
        public String access_token;
    }
   
    public class AccountWrap {
        public String sId;
        public String sName;
        public String sPhone;
       
        public AccountWrap(String externalId, String name, String phone) {
            this.sId = externalId;
            this.sName = name;
            this.sPhone = phone;
            system.debug('this.sId is :'+this.sId);
        }
    }
   
    public String getRequestToken(SH_AccountUpdateAPI accnt) {
        String reqbody = 'grant_type=password' + '&client_id=' + clientId + '&client_secret=' + clientSecret +
            '&username=' + username + '&password=' + password;
       
        Http h1 = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint('https://crmlanding63-dev-ed.develop.my.salesforce.com/services/oauth2/token');
       
        HttpResponse res = h1.send(req);
        ResWrapper response = (ResWrapper) JSON.deserialize(res.getBody(), ResWrapper.class);
       
        System.debug('response--->>>' + response);
        return response.access_token;
    }
   
    @future(callout=true)
    public static void updateAccountMethod(Set<Id> accIdSet) {
        SH_AccountUpdateAPI accnt = new SH_AccountUpdateAPI();
        String accessToken;
        String JSNBody;
        accessToken = accnt.getRequestToken(accnt);
        List<Account> accList = new List<Account>();
       
        if (accessToken != null) {
            String endPoint = 'https://crmlanding63-dev-ed.develop.my.salesforce.com/services/apexrest/v1/accountRecordCreate/';
           
            for (Account acc : [SELECT Id, Name, Phone FROM Account]) {
                accList.add(acc);
               
                if (accList.size() > 0) {
                   // AccountWrap accObj = new AccountWrap(accList[0].External_ID__c,accList[0].Name, accList[0].Phone);
                   // system.debug('accObj is :'+accObj);
                   // JSNBody = JSON.serialize(accObj);
                }
               
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Authorization', 'Bearer ' + accessToken);
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('accept', 'application/json');
                req1.setMethod('PATCH');
                req1.setBody(JSNBody);
                System.debug('body--->>' + JSNBody);
                req1.setEndpoint(endPoint + acc.Id);
                HttpResponse res1 = h2.send(req1);
            }
        }
    }
}