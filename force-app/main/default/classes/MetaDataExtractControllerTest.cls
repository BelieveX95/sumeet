@isTest
private class MetaDataExtractControllerTest {
    @isTest
    static void testCreateService() {
        Test.startTest();
        // Call the method being tested
        MetadataService.MetadataPort result = MetaDataExtractController.createService();
        Test.stopTest();
 }

   /* @isTest
    static void testProfileOverview() {
        // Test data setup
        String selectedProfile = 'Test';

        // Mock the MetadataService response
        Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));

        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataProfileOverViewWrapper> result = MetaDataExtractController.profileOverview(selectedProfile);
        Test.stopTest();

            }
	*/
    
    @isTest
    static void testGetLoginIpRanges() {
        // Test data setup
        String selectedProfile = 'Test';

        // Mock the MetadataService response
        //Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataLoginIpRangeWrapper> result = MetaDataExtractController.getLoginIpRanges(selectedProfile);
        Test.stopTest();

        
    }

    @isTest
    static void testGetTabVisibility() {
        // Test data setup
        String selectedProfile = 'Test';

        // Mock the MetadataService response
        //Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataTabVisibilityWrapper> result = MetaDataExtractController.getTabVisibility(selectedProfile);
        Test.stopTest();

           }

    @isTest
    static void testGetAppVisibility() {
        // Test data setup
        String selectedProfile = 'Test';

        // Mock the MetadataService response
        //Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataApplicationVisibilityWrapper> result = MetaDataExtractController.getAppVisibility(selectedProfile);
        Test.stopTest();

        
    }

    @isTest
    static void testGetUserPrmsn() {
        // Test data setup
        String selectedProfile = 'Test';
  Boolean enabled;
        // Mock the MetadataService response
        //Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataUserPermissionWrapper> result = MetaDataExtractController.getUserPrmsn(selectedProfile);
        Test.stopTest();

        
    }

    @isTest
    static void testGetRcrdTypVisble() {
        // Test data setup
        String selectedProfile = 'Test';

        // Mock the MetadataService response
        //Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataRecordTypeVisibilityWrapper> result = MetaDataExtractController.getRcrdTypVisble(selectedProfile);
        Test.stopTest();

        
    }

    @isTest
    static void testGetLayoutAsign() {
        // Test data setup
        String selectedProfile = 'Test';

        // Mock the MetadataService response
        //Test.setMock(WebServiceMock.class, new MockMetadataService(selectedProfile));
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.startTest();
        // Call the method being tested
        List<MetaDataExtractController.MetadataLayoutAssignmentWrapper> result = MetaDataExtractController.getLayoutAsign(selectedProfile);
        Test.stopTest();

       
    }
    
      @isTest
    static void testMetadataProfileWrapperConstructor() {
        // Create test data
        String fullName = 'Test Profile';
        String description = 'This is a test profile';
        Boolean custom = true;
        String userLicense = 'Standard';

        // Instantiate MetadataProfileOverViewWrapper
        MetaDataExtractController.MetadataProfileOverViewWrapper wrapper = new MetaDataExtractController.MetadataProfileOverViewWrapper(fullName, description, custom, userLicense);

        // Verify that the instance variables were set correctly
        System.assertEquals(fullName, wrapper.fullName);
        System.assertEquals(description, wrapper.description);
        System.assertEquals(custom, wrapper.custom);
        System.assertEquals(userLicense, wrapper.userLicense);
    }
    
    @isTest
    static void testMethod1(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        MetaDataExtractController.profileOverview('System Administrator');
        Test.stopTest();
    }

    // Mock MetadataService class for web service mock
    private class MockMetadataService implements WebServiceMock {
        String selectedProfile;

        MockMetadataService(String selectedProfile) {
            this.selectedProfile = selectedProfile;
        }

        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            // Implement mock responses here based on the method called
            if (requestName == 'readMetadata') {
                
                MetadataService.readMetadata_element readMetaData = new MetadataService.readMetadata_element();
                List<String> profileNames = new List<String>();
                profileNames.add('System Administrator');
                readMetaData.fullNames = profileNames;
                readMetaData.type_x = 'Profile';
                
                /*MetadataService.Profile[] profiles = new List<MetadataService.Profile>();
                MetadataService.Profile profile = new MetadataService.Profile();
                profile.fullName = selectedProfile;
                profile.description = 'Test Description';
                profile.custom = false;
                profile.userLicense = 'Salesforce';
                profiles.add(profile);*/

                //response.put('response_x', new MetadataService.ReadResponse_element());
                //response.get('response_x').result = new MetadataService.Metadata[] { profile };
            } else if (requestName == 'readMetadata' && responseName == 'LoginIpRange') {
                MetadataService.ProfileLoginIpRange loginIpRange = new MetadataService.ProfileLoginIpRange();
                loginIpRange.description = 'Test Login IP';
                loginIpRange.endAddress = '192.168.0.1';
                loginIpRange.startAddress = '192.168.0.0';

                MetadataService.Profile profile = new MetadataService.Profile();
                profile.loginIpRanges = new List<MetadataService.ProfileLoginIpRange>();
                profile.loginIpRanges.add(loginIpRange);

                //response.put('response_x', new MetadataService.ReadResponse_element());
                //response.get('response_x').result = new MetadataService.Metadata[] { profile };
            } else if (requestName == 'readMetadata' && responseName == 'TabVisibility') {
                // Implement mock response for TabVisibility
            }else if(request instanceof MetadataService.readMetadata_element){
                
            }
        }
    }
}