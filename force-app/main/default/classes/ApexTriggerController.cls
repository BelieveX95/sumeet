public class ApexTriggerController {
    public static Boolean isException = false;
    public static String fetchUserSessionId(){
        String sessionId = '';
        String vfContent;
        try{
            // Refer to the Page
            PageReference reportPage = Page.GetSessionIdVF;
            if(Test.isRunningTest()){
                blob pdfBody;
                pdfBody = blob.valueOf('Unit.Test');
            }else{
                // Get the content of the VF page
                vfContent = reportPage.getContent().toString();
            }
            if(vfContent != null){
                // Find the position of Start_Of_Session_Id and End_Of_Session_Id
                Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                    endP = vfContent.indexOf('End_Of_Session_Id');
                // Get the Session Id
                sessionId = vfContent.substring(startP, endP);
            }
        } catch(exception ex){
          /*  cl_eme__Metadata_Exception_log__c exceptionRecord = new cl_eme__Metadata_Exception_log__c();
            if(Schema.sObjectType.cl_eme__Metadata_Exception_log__c.fields.cl_eme__Message__c.isCreateable() &&
               Schema.sObjectType.cl_eme__Metadata_Exception_log__c.fields.cl_eme__Line_number__c.isCreateable()){
                   exceptionRecord.cl_eme__Message__c = ex.getMessage();
                   exceptionRecord.cl_eme__Line_number__c = ex.getStackTraceString();
                   insert exceptionRecord; */
               }
            return sessionId;
        }
}