/*
Name : MetaDataExtractController.cls
Author: Shubham Vaishnav
Company: CRM Landing Software Private Limited
History:
Version 1.0 date
Date : 29/07/2023
Test Class : MetaDataExtractControllerTest
*/

public class MetaDataExtractController {


/*
    @description: createService Method to return service
    @param : 
    @return  return service;
    */
 @AuraEnabled
    public static MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        //service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.SessionHeader.sessionId = ApexTriggerController.fetchUserSessionId();
        return service;
    }

    // Profile OverView - start

/*
    @description: profileOverview Method to fetch the profile Overview
    @param : String selectedProfile
    @return  WraperOverviewList;
    */

      public class MetadataProfileOverViewWrapper { 

        @AuraEnabled
        public String fullName;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public Boolean custom;
        @AuraEnabled
        public String userLicense;
        
        public MetadataProfileOverViewWrapper(String fullName, String description, Boolean custom,String userLicense) {

            this.fullName = fullName;
            this.description = description;
            this.custom = custom;
            this.userLicense = userLicense;
        }
    }
    
    @AuraEnabled
    public static List<MetadataProfileOverViewWrapper> profileOverview(String selectedProfile) {
        String orignalName = selectedProfile;
      	selectedProfile = getProfileFullName(selectedProfile);

        List<MetadataProfileOverViewWrapper> WraperOverviewList = new List<MetadataProfileOverViewWrapper>();
        MetadataService.MetadataPort service = createService();

        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
                    MetadataProfileOverViewWrapper metadata = new MetadataProfileOverViewWrapper(
                        orignalName,
                        profile.description,
                        profile.custom,
                        profile.userLicense
                    );
                    WraperOverviewList.add(metadata);
            
        }
        return WraperOverviewList;
    }

    // Profile OverView - end


    

    // Login Ip Range - start
/*
    @description: getLoginIpRanges Method to fetch the Login Ip Ranges
    @param : String selectedProfile
    @return  loginIpRangeList;
    */
      public class MetadataLoginIpRangeWrapper {

        @AuraEnabled
        public String description;
        @AuraEnabled
        public String endAddress;
        @AuraEnabled
        public String startAddress;
        
        public MetadataLoginIpRangeWrapper(String description, String endAddress, String startAddress) {
            this.description = description;
            this.endAddress = endAddress;
            this.startAddress = startAddress;
        }
    }
    
    @AuraEnabled
    public static List<MetadataLoginIpRangeWrapper> getLoginIpRanges(String selectedProfile) {
       selectedProfile = getProfileFullName(selectedProfile);

        List<MetadataLoginIpRangeWrapper> loginIpRangeList = new List<MetadataLoginIpRangeWrapper>();
        MetadataService.MetadataPort service = createService();

        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
            if (profile.loginIpRanges != null) {
                for (MetadataService.ProfileLoginIpRange loginIpRange : profile.loginIpRanges) {
                    MetadataLoginIpRangeWrapper metadata = new MetadataLoginIpRangeWrapper(
                        loginIpRange.description,
                        loginIpRange.endAddress,
                        loginIpRange.startAddress
                    );
                    loginIpRangeList.add(metadata);
                }
            }
        }
        return loginIpRangeList;
    }

    // Login Ip Range - end

    // Tab Visibility - start
/*
    @description: getTabVisibility Method to fetch the Tab Visibility
    @param : String selectedProfile
    @return  tabVisibilityList;
    */
    public class MetadataTabVisibilityWrapper {
        @AuraEnabled
        public String tab;
        @AuraEnabled
        public String visibility;
        
        public MetadataTabVisibilityWrapper(String tab, String visibility) {
            this.tab = tab;
            this.visibility = visibility;
        }
    }

      @AuraEnabled
    public static List<MetadataTabVisibilityWrapper> getTabVisibility(String selectedProfile) {
       selectedProfile = getProfileFullName(selectedProfile);

        List<MetadataTabVisibilityWrapper> tabVisibilityList = new List<MetadataTabVisibilityWrapper>();
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
            if (profile.tabVisibilities != null) {
                for (MetadataService.ProfileTabVisibility profileVsbl : profile.tabVisibilities) {
                    MetadataTabVisibilityWrapper metadata = new MetadataTabVisibilityWrapper(
                        profileVsbl.tab,
                        profileVsbl.visibility
                    );
                    tabVisibilityList.add(metadata);
                }
            }
        }
        return tabVisibilityList;
    }

    // Tab Visibility - end

    //Application Visibility - start
/*
    @description: getAppVisibility Method to fetch the App Visibility
    @param : String selectedProfile
    @return  applicationVisibilityList;
    */
     public class MetadataApplicationVisibilityWrapper {
        @AuraEnabled
        public String application;
        @AuraEnabled
        public Boolean default_x;
        @AuraEnabled
        public Boolean visible;
        
        public MetadataApplicationVisibilityWrapper(String application, Boolean default_x, Boolean visible) {
            this.application = application;
            this.default_x = default_x;
            this.visible = visible;
        }
    }

      @AuraEnabled
    public static List<MetadataApplicationVisibilityWrapper> getAppVisibility(String selectedProfile) {
        selectedProfile = getProfileFullName(selectedProfile);

        List<MetadataApplicationVisibilityWrapper> applicationVisibilityList = new List<MetadataApplicationVisibilityWrapper>();
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
            if (profile.applicationVisibilities != null) {
                for (MetadataService.ProfileApplicationVisibility applicationVisibility : profile.applicationVisibilities) {
                    MetadataApplicationVisibilityWrapper metadata = new MetadataApplicationVisibilityWrapper(
                        applicationVisibility.application,
                        applicationVisibility.default_x,
                        applicationVisibility.visible
                    );
                    applicationVisibilityList.add(metadata);
                }
            }
        }
        return applicationVisibilityList;
    }

    //Application Visibility - end

    // User permission - start
/*
    @description: getUserPrmsn Method to fetch the User Permission
    @param : String selectedProfile
    @return  userPermissionList;
    */
    public class MetadataUserPermissionWrapper {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Boolean enabled;
        
        public MetadataUserPermissionWrapper(String name, Boolean enabled) {
            this.name = name;
            this.enabled = enabled;
        }
    }

      @AuraEnabled
    public static List<MetadataUserPermissionWrapper> getUserPrmsn(String selectedProfile) {
       selectedProfile = getProfileFullName(selectedProfile);

        List<MetadataUserPermissionWrapper> userPermissionList = new List<MetadataUserPermissionWrapper>();
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
            if (profile.userPermissions != null) {
                for (MetadataService.ProfileUserPermission userPrmsn : profile.userPermissions) {
                    MetadataUserPermissionWrapper metadata = new MetadataUserPermissionWrapper(
                        userPrmsn.name,
                        userPrmsn.enabled
                    );
                    userPermissionList.add(metadata);
                }
            }
        }
        return userPermissionList;
    }

    // User permission - end

    //Record Type Visibility - start
/*
    @description: getRcrdTypVisble Method to fetch the Rcord Type Visibility
    @param : String selectedProfile
    @return  recordTypeList;
    */
     public class MetadataRecordTypeVisibilityWrapper {
        @AuraEnabled
        public String recordType;
        @AuraEnabled
        public Boolean visible;
        @AuraEnabled
        public Boolean default_x;
        
        public MetadataRecordTypeVisibilityWrapper(String recordType, Boolean visible, Boolean default_x) {
            this.recordType = recordType;
            this.visible = visible;
            this.default_x = default_x;
        }
    }

      @AuraEnabled
    public static List<MetadataRecordTypeVisibilityWrapper> getRcrdTypVisble(String selectedProfile) {
       selectedProfile = getProfileFullName(selectedProfile);

        List<MetadataRecordTypeVisibilityWrapper> recordTypeList = new List<MetadataRecordTypeVisibilityWrapper>();
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
            if (profile.recordTypeVisibilities != null) {
                for (MetadataService.ProfileRecordTypeVisibility recordTypeVisibility : profile.recordTypeVisibilities) {
                    MetadataRecordTypeVisibilityWrapper metadata = new MetadataRecordTypeVisibilityWrapper(
                        recordTypeVisibility.recordType,
                        recordTypeVisibility.visible,
                        recordTypeVisibility.default_x
                    );
                    recordTypeList.add(metadata);
                }
            }
        }
        return recordTypeList;
    }

    //Record Type Visibility - end

    // Profile Layout Assignment - start
/*
    @description: getLayoutAsign Method to fetch the get Layout Assignment
    @param : String selectedProfile
    @return  layoutAssignmentList;
    */
    public class MetadataLayoutAssignmentWrapper {
        @AuraEnabled
        public String recordType;
        @AuraEnabled
        public String layout;
        
        public MetadataLayoutAssignmentWrapper(String recordType, String layout) {
            this.recordType = recordType;
            this.layout = layout;
        }
    }

      @AuraEnabled
    public static List<MetadataLayoutAssignmentWrapper> getLayoutAsign(String selectedProfile) {
        selectedProfile = getProfileFullName(selectedProfile);
        
        List<MetadataLayoutAssignmentWrapper> layoutAssignmentList = new List<MetadataLayoutAssignmentWrapper>();
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata(
            'Profile',
            new String[] { selectedProfile }
        ).getRecords();

        for (MetadataService.Profile profile : profiles) {
            if (profile.layoutAssignments != null) {
                for (MetadataService.ProfileLayoutAssignment layoutAssignment: profile.layoutAssignments) {
                    MetadataLayoutAssignmentWrapper metadata = new MetadataLayoutAssignmentWrapper(
                        layoutAssignment.recordType,
                        layoutAssignment.layout
                    );
                    layoutAssignmentList.add(metadata);
                }
            }
        }
        return layoutAssignmentList;
    }

    // Profile Layout Assignment - end

    // fetchUserSessionId - start
    /*
    @description: fetchUserSessionId Method to fetch the user session ID
    @param
    @return  sessionId;
    */
     public static String fetchUserSessionId() {
        String sessionId = '';
        // Refer to the Page
        PageReference reportPage = Page.GetSessionIdVF;
        // Get the content of the VF page
        if (!Test.isRunningTest()) {
            String vfContent = reportPage.getContent().toString();
            // Find the position of Start_Of_Session_Id and End_Of_Session_Id
            Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                endP = vfContent.indexOf('End_Of_Session_Id');
            // Get the Session Id
            sessionId = vfContent.substring(startP, endP);
            // Return Session Id
        }
        return sessionId;
    }
  // fetchUserSessionId - end

  // get profile full name - start 

  /*
    @description: getProfileFullName Method to fetch the FullName of a Profile based on the provided Name
    @param String profileName
    @return String fullName
    */
    public static String getProfileFullName(String profileName) {
        try {
            String query = 'SELECT Name, FullName FROM Profile WHERE Name = \'' + profileName + '\' LIMIT 1';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v52.0/tooling/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + fetchUserSessionId());
            req.setHeader('Content-Type', 'application/json');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> records = (List<Object>) responseMap.get('records');
                if (!records.isEmpty()) {
                    Map<String, Object> record = (Map<String, Object>) records[0];
                    return (String) record.get('FullName');
                } else {
                    return 'Profile not found.';
                }
            } else {
                return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
            }
        } catch (Exception ex) {
            // Handle the exception (if needed)
            return 'Exception: ' + ex.getMessage();
        }
    }

    // get profile full name - end  
}