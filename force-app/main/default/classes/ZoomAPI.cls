public class ZoomAPI {
    @AuraEnabled(cacheable=true)
    public static String createZoomMeeting() {
        
        String jwtToken = 'eyJzdiI6IjAwMDAwMSIsImFsZyI6IkhTNTEyIiwidiI6IjIuMCIsImtpZCI6IjA3NWJlOGI3LTYxZmMtNGE1NC04ZmVhLTQxYmM2MTQ1MjJiNSJ9.eyJ2ZXIiOjksImF1aWQiOiIzNjE2MTJmNjBjMTA5MDBjOGI2NTAzNzJiNWYwMGViNyIsImNvZGUiOiJUc3dmbWdhY3NncWx6am5JeFlEVHh1dHlTOWJZZFg0SEEiLCJpc3MiOiJ6bTpjaWQ6ZHN4Yk50U1FGS0FPU0lZaWd0dmx3IiwiZ25vIjowLCJ0eXBlIjowLCJ0aWQiOjAsImF1ZCI6Imh0dHBzOi8vb2F1dGguem9vbS51cyIsInVpZCI6IjUxQzJZb0R2UkJxUjM3NTFDcjYwcnciLCJuYmYiOjE2OTY4MzUwOTQsImV4cCI6MTY5NjgzODY5NCwiaWF0IjoxNjk2ODM1MDk0LCJhaWQiOiJVSXZ3S1MyVFNHMjhzaG01eWJ1NWxnIn0.K5mDloaMWOVyL3of2eZOqLbTDmdakRMzmVd_7gaqEYxtxZMt6kqfQ-4ASwnCsoPgbEN2ZBLe8aEWI3_LvHEuZA';
        
        // Define the meeting details
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('topic', 'test');
        requestBody.put('type', 2);
        requestBody.put('start_time', '2023-10-06T12:10:10Z');
        requestBody.put('duration', '3');
        
        Map<String, Object> settings = new Map<String, Object>();
        settings.put('host_video', true);
        settings.put('participant_video', true);
        settings.put('join_before_host', true);
        settings.put('mute_upon_entry', true);
        settings.put('watermark', true);
        settings.put('audio', 'voip');
        settings.put('auto_recording', 'cloud');
        
        requestBody.put('settings', settings);
        
        String jsonBody = JSON.serialize(requestBody);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.zoom.us/v2/users/me/meetings');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + jwtToken);
        request.setBody(jsonBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 201) { 
            return response.getBody();
        } else {
            String errorMessage = 'Error: ' + response.getStatusCode() + ' ' + response.getStatus();
            System.debug('Error Message: ' + errorMessage);
            return errorMessage;
        }
    }
    
    @AuraEnabled(cacheable=true)   
    public static void createRecording(String uuid){
        system.debug('uuid'+uuid);
    }
}