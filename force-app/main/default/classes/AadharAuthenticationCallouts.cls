public class AadharAuthenticationCallouts{
    
    
    @AuraEnabled
    
    public static OTPJSON makeCalloutforOTP(String aadharNumber){
        
        
        OTPJSON wrapper1 = new OTPJSON();
        
        
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://sandbox.aadhaarkyc.io/api/v1/aadhaar-v2/generate-otp');
        
        request.setMethod('POST');
        
        //request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        request.setHeader('Content-Type','application/json');
        
        
        
        // String authorizationHeader = 'BASIC ' +
        
        request.setHeader('Authorization',
                          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyNzUzOTYzNiwianRpIjoiNTg3YTQwOGMtZTgwMS00N2UyLWFlODYtYmQ4Yzk2NTAyZjliIiwidHlwZSI6ImFjY2VzcyIsImlkZW50aXR5IjoiZGV2Lm1hYW50aWN0ZWNoQGFhZGhhYXJhcGkuaW8iLCJuYmYiOjE2Mjc1Mzk2MzYsImV4cCI6MTYzMDEzMTYzNiwidXNlcl9jbGFpbXMiOnsic2NvcGVzIjpbInJlYWQiXX19.Ncth0jSHzWCV91AM2bGDle_NSCsJoQXky3TCM0AVKa8');
        
        
        
        String body = ' {\"id_number\": ' + '\"' + String.valueof(aadharNumber)  + '\"}' ;
        
        System.debug('@@@body'+body);
        
        
        
        // Set the body as a JSON object
        
        request.setBody(body);
        
        //request.setBody('{"id_number":  "988488389260"}');
        
        request.setTimeout(120000); // timeout in milliseconds
        
        
        HttpResponse response = http.send(request);
        
        
        
        // Parse the JSON response
        
        if (response.getStatusCode() != 201) {
            
            System.debug('The status code returned was not expected: ' +
                         
                         response.getStatusCode() + ' ' + response.getStatus());
            
        }  
        
        if(response.getStatusCode() == 200){
            
            
            
            System.debug('@@@OTPRESPONSE'+response.getBody());
            
            wrapper1 = AadharAuthenticationCallouts.parse(response.getBody());
            
            System.debug('@@@wrapper1'+wrapper1);
            
        }
        
        
        
        return wrapper1;
        
    }
    
    
    @AuraEnabled
    
    public static aadharDetailsWrapper makeCalloutforCustomerDetails(String otp, String mobileNumber, String clientId){
        
        
        
        aadharDetailsWrapper aadharWrapper = new aadharDetailsWrapper();
        
        
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://sandbox.aadhaarkyc.io/api/v1/aadhaar-v2/submit-otp');
        
        request.setMethod('POST');
        
        //request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        request.setHeader('Content-Type','application/json');
        
        
        
        // String authorizationHeader = 'BASIC ' +
        
        request.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyNzUzOTYzNiwianRpIjoiNTg3YTQwOGMtZTgwMS00N2UyLWFlODYtYmQ4Yzk2NTAyZjliIiwidHlwZSI6ImFjY2VzcyIsImlkZW50aXR5IjoiZGV2Lm1hYW50aWN0ZWNoQGFhZGhhYXJhcGkuaW8iLCJuYmYiOjE2Mjc1Mzk2MzYsImV4cCI6MTYzMDEzMTYzNiwidXNlcl9jbGFpbXMiOnsic2NvcGVzIjpbInJlYWQiXX19.Ncth0jSHzWCV91AM2bGDle_NSCsJoQXky3TCM0AVKa8');
        
        
        
        //String clientId = wrapper1.data.client_id;
        
        
        
        String body =  '{\"client_id\":' + '\"' + String.valueof(clientId)  + '\"' + ',' +
            
            '\"otp\": ' + '\"' + String.valueof(otp)  + '\"' + ',' +
            
            '\"mobile_number\": ' + '\"' + String.valueof(mobileNumber)  + '\"}' ;
        
        
        
        System.debug('@@@body'+body);
        
        request.setBody(body);
        
        
        request.setTimeout(120000); // timeout in milliseconds
        
        
        HttpResponse response = http.send(request);
        
        
        
        // Parse the JSON response
        
        if (response.getStatusCode() != 201) {
            
            System.debug('The status code returned was not expected: ' +
                         
                         response.getStatusCode() + ' ' + response.getStatus());
            
        }  
        
        if(response.getStatusCode() == 200){
            
            
            
            System.debug('@@@OTPRESPONSE'+response.getBody());
            
            aadharWrapper = aadharDetailsWrapper.parse(response.getBody());
            
            System.debug('@@@aadharWrapper'+aadharWrapper);
            
        }
        
        
        
        return aadharWrapper;
        
    }
    
    
    
    public class OTPJSON{
        
        @AuraEnabled public cls_data data;
        
        @AuraEnabled public Integer status_code; //200
        
        @AuraEnabled public String message_code; //success
        
        @AuraEnabled public String message;  //OTP Sent.
        
        @AuraEnabled public boolean success;
        
        
        
    }     
    
    
    
    public class cls_data {
        
        @AuraEnabled public String client_id;    //aadhaar_v2_hVZqjGfcvewdZccCFyyW
        
        @AuraEnabled public boolean otp_sent;
        
        @AuraEnabled public boolean if_number;
        
        @AuraEnabled public boolean valid_aadhaar; 
        
    }
    
    
    
    public static OTPJSON parse(String json){
        
        return (OTPJSON) System.JSON.deserialize(json, OTPJSON.class);
        
    }
    
}