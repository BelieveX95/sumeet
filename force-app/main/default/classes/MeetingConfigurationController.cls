public class MeetingConfigurationController {

    @AuraEnabled(cacheable=true)
    public static String createMeetingConfiguration() {
        String restEndpoint = 'https://platform.saleassist.ai/api/meetings/v1';
        String apiKey = '419294D617DE904831D36E4449DCFF3D';
        String apiSecret = '376936fe91543a4faeb793c7d694a0650e1d9ec8824b5d8abf2d76a053ec26da';
        
        
        Map<String, Object> meetingConfig = new Map<String, Object>();
        meetingConfig.put('moderators', new List<String>{'sumeet.kendre@gmail.com'});
        meetingConfig.put('participants', new List<String>{'sumeet.kendre@crmlanding.in'});
        meetingConfig.put('meeting_type', 'audio_call');

        String jsonInput = JSON.serialize(meetingConfig);
        System.debug(jsonInput);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(restEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('api_key', apiKey);
        req.setHeader('api_secret', apiSecret);
        req.setBody(jsonInput);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
                        System.debug('Meeting Configuration created successfully');

            return res.getBody(); 
        } else {
            // Handle errors (you can throw an exception, log the error, etc.)
            return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
}