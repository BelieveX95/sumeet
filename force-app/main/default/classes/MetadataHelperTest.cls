@isTest
public class MetadataHelperTest {
    @isTest
    public static void getObjectFieldData() { 
        test.startTest();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        MetadataHelper.ObjectInfo objectInfoResult = MetadataHelper.getObjectInfo('Account');
        test.stopTest();
        System.assertNotEquals(null, objectInfoResult, 'ObjectInfo should not be null');
        
    }
    @isTest
    static void testGetNonConfigurableFields() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<MetadataHelper.FieldData> result = MetadataHelper.getNonConfigurableFields('Account');
        
        System.assertNotEquals(null, result);
        
    }
    
    @isTest
    public static void  getRecordTypesData(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<MetadataHelper.RecordTypeData> recordTypesData = MetadataHelper.getRecordTypesData('Account');
        
        System.assertNotEquals(null, recordTypesData);
        
        System.assertNotEquals(0, recordTypesData.size());
        
        for (MetadataHelper.RecordTypeData recordTypeData : recordTypesData) {
            System.assertNotEquals(null, recordTypeData.recordTypeName);
            System.assertNotEquals(null, recordTypeData.isActive);
        }
    }
    
    @isTest
    static void testExceptionHandling() {
        List<MetadataHelper.RecordTypeData> recordTypesData = MetadataHelper.getRecordTypesData('InvalidObjectLabel');
        
        System.assertEquals(0, recordTypesData.size());
    }
    
    @isTest
    public static void  isObjectSupportsBulkApi(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Boolean supportsBulkApi = MetadataHelper.isObjectSupportsBulkApi(Account.sObjectType);
        System.assertEquals(true, supportsBulkApi, 'Account should support Bulk API');
        
        MetadataHelper.ObjectInfo objectInfoResult = MetadataHelper.getObjectInfo('Account');
        System.assertNotEquals(null, objectInfoResult, 'ObjectInfo should not be null');
        System.assertEquals('Account', objectInfoResult.objectName, 'ObjectName should match');
        // System.assertEquals('Test Account', objectInfoResult.customHelp, 'Custom Help should match');
        
    }
    
    
    
    
    
    @isTest
    public static void getObjectNameData(){        
        String testObjectApiName = 'Account'; // Replace with the object API name you want to test

        List<MetadataHelper.FieldInfo> result = MetadataHelper.FieldInfo.getObjectNameData(testObjectApiName);

        System.assertEquals(false, result.isEmpty(), 'FieldInfo list should not be empty');
        
            System.assertNotEquals(null, result[0].fieldName, 'Field name should not be null');
            System.assertNotEquals(null, result[0].apiName, 'API name should not be null');
            System.assertNotEquals(null, result[0].dataType, 'Data type should not be null');
        
    }    
    
    
    
    @isTest
    public static void getWebLinks() {
        MetadataHelper.getWebLinks('Account');
        
        // Create a test WebLink record
        WebLink testWebLink = new WebLink(
            Name = 'Test WebLink',
            PageOrSobjectType = 'Account', // Assuming you're testing with the 'Account' object
            DisplayType = 'DetailPageButton',
            Url = 'https://www.example.com',
            LinkType = 'WebUrl',
            OpenType = 'NewWindow'
        );
        //  insert testWebLink;
        
        // Call the method under test
        //     List<WebLinkWrapper> result = MetadataHelper.getWebLinks('Account'); 
        // Assert the results
        //  System.assertEquals(1, result.size(), 'Expected one WebLinkWrapper record');
        //System.assertEquals('Weblink', result[0].name, 'Name should be "Weblink"');
        //System.assertEquals(testWebLink.Id, result[0].weblink.Id, 'WebLink Id should match');
        
        // Additional assertions on other properties can be added here
    }
    
    @isTest
    public static void getObjectInfo(){
        String testObjectApiName = 'Account'; 
        
        MetadataHelper.ObjectInfo objectInfoResult = MetadataHelper.getObjectInfo(testObjectApiName);
        
        System.assertNotEquals(null, objectInfoResult, 'Object info should not be null');
        System.assertEquals('Account', objectInfoResult.objectName, 'Object name should match');
    }
    
    @isTest
    public static void testListViewData() {
        String label = 'Sample Label';
        String name = 'Sample Name';
        String filter = 'Sample Filter';
        String filterScope = 'Sample Scope';
        List<String> columns = new List<String>{'Column 1', 'Column 2', 'Column 3'};
            
            MetadataHelper.ListViewData listViewData = new MetadataHelper.ListViewData(label, name, filter, filterScope, columns);
        
        System.assertEquals(label, listViewData.label);
        System.assertEquals(name, listViewData.name);
        System.assertEquals(filter, listViewData.filter);
        System.assertEquals(filterScope, listViewData.filterScope);
        System.assertEquals(columns, listViewData.columns);
        System.assertEquals(false, listViewData.allCustomerPortalUsers);
        System.assertEquals(false, listViewData.allInternalUsers);
        listViewData.allCustomerPortalUsers = true;
        System.assertEquals(true, listViewData.allCustomerPortalUsers);
    }
    
    
    @isTest
    static void getListViewDataByObject() {
        
        
        System.debug('Setting mock implementation.');
        
        Test.setMock(WebServiceMock.class, new MockMetadataService());
        System.debug('Calling getListViewDataByObject method.');
        MetadataService.ListView mockListView = new MetadataService.ListView();
        mockListView.fullName = 'TestListView';
        mockListView.booleanFilter = 'TestBooleanFilter';
        mockListView.filterScope = 'TestFilterScope';
        mockListView.columns = new List<String>{'Column1', 'Column2'};
            
            String objectAPIName = 'Account'; 
        String label = 'Sample Label';
        String name = 'Sample Name';
        String filter = 'Sample Filter';
        String filterScope = 'Sample Scope';
        List<String> columns = new List<String>{'Column 1', 'Column 2', 'Column 3'};
            
            MetadataHelper.ListViewData listView = new MetadataHelper.ListViewData(label, name, filter, filterScope, columns);
        
        
        List<MetadataHelper.ListViewData> listViewDataList = MetadataHelper.getListViewDataByObject(objectAPIName);
        System.debug('List called');
        
        /*   System.assertEquals(1, listViewDataList.size());
MetadataHelper.ListViewData listViewData = listViewDataList[0];
System.assertEquals('TestListView', listViewData.label);
System.assertEquals('TestListView', listViewData.name);
System.assertEquals('TestBooleanFilter', listViewData.filter);
System.assertEquals('TestFilterScope', listViewData.filterScope);
System.assertEquals(2, listViewData.columns.size());
System.assertEquals('Column1', listViewData.columns[0]);
System.assertEquals('Column2', listViewData.columns[1]);
*/
        
    }
    
    @isTest
    static void FormulaFieldMetadata() {
        String label = 'Test Label';
        String name = 'Test_Name__c';
        String formulaTreatBlankAs = 'BlankAsZero';
        String formula = 'IF(ISNULL(Test_Field__c), 0, Test_Field__c * 2)';
        
        MetadataHelper.FormulaFieldMetadata metadata = new MetadataHelper.FormulaFieldMetadata(label, name, formulaTreatBlankAs, formula);
        
        System.assertEquals(label, metadata.label);
        System.assertEquals(name, metadata.name);
        System.assertEquals(formulaTreatBlankAs, metadata.formulaTreatBlankAs);
        System.assertEquals(formula, metadata.formula);
    }
    
   
    
    @isTest
    static void testCompactLayoutWrapper() {
        List<String> fields = new List<String>{'Field1', 'Field2', 'Field3'};
            
            MetadataHelper.CompactLayoutWrapper compactLayout = new MetadataHelper.CompactLayoutWrapper('Test Label', 'Test Name', fields);
        
        System.assertEquals('Test Label', compactLayout.label);
        System.assertEquals('Test Name', compactLayout.name);
        System.assertEquals(fields, compactLayout.fields);
    }
    
  
    @isTest
    static void getCompactLayoutsDataTest(){
        Test.setMock(WebServiceMock.class, new MockMetadataService());
        Test.startTest();
        MetadataHelper.getCompactLayoutsData('Account');
        Test.stopTest();
    }
    
    @isTest  
    static void getActionOverrideDataTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMockForGetMtdCmpDependency());
        Test.stopTest();
    }
    
    @isTest
    static void getCompactLayoutsDataTest1(){
        Test.setMock(WebServiceMock.class, new MetadataMock1());
        Test.startTest();
        MetadataHelper.getCompactLayoutsData('Account');
        Test.stopTest();
    }    
    
    
    // Mock implementation of MetadataService
    public class MetadataServiceMockImpl {
        MetadataService.CompactLayout mockLayout;
        
        public MetadataServiceMockImpl(MetadataService.CompactLayout mockLayout) {
            this.mockLayout = mockLayout;
        }
        
        
    } 
    public class MockMetadataService implements WebServiceMock {
        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {
                // Create a mock ListView response here
                System.debug('Mock service invoked.');
                
                MetadataService.ListView mockListView = new MetadataService.ListView();
                mockListView.fullName = 'TestListView';
                mockListView.booleanFilter = 'TestBooleanFilter';
                mockListView.filterScope = 'TestFilterScope';
                mockListView.columns = new List<String>{'Column1', 'Column2'};
                    
                    // Set the mock response
                    response.put('response_x', mockListView);
                
                if (request instanceof MetadataService.readMetadata_element) {
                    response.put('response_x', readResponse(request));
                }
            }
        // Implements couple of requests
        private MetadataService.IReadResponseElement readResponse(Object request) {
            
            MetadataService.readMetadata_element r = (MetadataService.readMetadata_element) request;
            
            if (r.type_x == 'RecordType') {
                
                MetadataService.PicklistValue picklistValue = new MetadataService.PicklistValue();
                picklistValue.fullName = 'Pending';
                
                MetadataService.RecordTypePicklistValue recordTypePicklistValue = new MetadataService.RecordTypePicklistValue();
                recordTypePicklistValue.picklist = 'cve__Status__c';
                recordTypePicklistValue.values = new MetadataService.PicklistValue[] {picklistValue};
                    
                    MetadataService.RecordType recordType = new MetadataService.RecordType();
                //recordType.fullName = RECORD_TYPE_FULL_NAMES[0];
                recordType.picklistValues = new MetadataService.RecordTypePicklistValue[] {
                    recordTypePicklistValue
                        };
                            
                            MetadataService.ReadRecordTypeResult result = new MetadataService.ReadRecordTypeResult();
                result.records = new MetadataService.RecordType[] {
                    recordType
                        };
                            
                            MetadataService.readRecordTypeResponse_element responseElement = new MetadataService.readRecordTypeResponse_element();
                responseElement.result = result;
                
                return responseElement;
                
            } else if (r.type_x == 'Pro') {
                
                MetadataService.ReadCustomFieldResult result = new MetadataService.ReadCustomFieldResult();
                /*result.records = new MetadataService.CustomField[] {
                    createContactEmailField(),
                        createBenefitClaimedDateOfDiagnosisField()
                        };*/
                            
                            MetadataService.readCustomFieldResponse_element responseElement = new MetadataService.readCustomFieldResponse_element();
                responseElement.result = result;
                
                return responseElement;
                
            }else if(r.type_x == 'customObject'){
                
                MetadataService.ReadCustomObjectResult result = new MetadataService.ReadCustomObjectResult();
                MetadataService.CustomObject customObject = new MetadataService.CustomObject();
                customObject.label = 'Test';
                customObject.pluralLabel = 'Tests';
                customObject.nameField = new MetadataService.CustomField();
                customObject.nameField.type_x = 'Text';
                customObject.nameField.label = 'Test Record';
                customObject.deploymentStatus = 'Deployed';
                customObject.sharingModel = 'ReadWrite';
                MetadataService.CustomObject[] customObjects = new MetadataService.CustomObject[]{};
                customObjects.add(customObject);
                result.records = customObjects;
                
                MetadataService.readCustomObjectResponse_element responseElement = new MetadataService.readCustomObjectResponse_element();
                responseElement.result = result;
                return responseElement;
            }
            else {
                System.assert(false, 'Unexpected read type ' + r.type_x);
                return null;
            }
        }
    }
    
   public class WebServiceMockForGetMtdCmpDependency implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        
        // Create a fake response body
        String responseBody = JSON.serialize(
            new Map<String, Object>{
                'attributes' => new Map<String, Object>{
                    'type' => 'MetadataComponentDependency',
                    'url' => '/services/data/v56.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA'
                },
                'MetadataComponentName' => 'test',
                'MetadataComponentType' => 'Appointment__mdt',
                'RefMetadataComponentName' => 'Appointment',
                'RefMetadataComponentType' => 'CustomObject'
            }
        );
        
        res.setStatusCode(200);
        res.setBody(responseBody);
        
        return res;
    }
}

 @isTest
    static void testGetObjectFieldData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        List<MetadataHelper.FieldMetadata> fieldMetadataList = MetadataHelper.FieldMetadata.getObjectFieldData('Account');

        System.assertNotEquals(null, fieldMetadataList);
        System.assertNotEquals(0, fieldMetadataList.size());
       
    }
 
        public class MetadataMock1 implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            if (request instanceof MetadataService.createMetadata_element) {
                // Mock response for createMetadata method
                MetadataService.createMetadataResponse_element metadataResponse = new MetadataService.createMetadataResponse_element();
                MetadataService.SaveResult saveresult = new MetadataService.SaveResult();
                saveresult.errors = new List<MetadataService.Error>();
                saveresult.fullName = 'TestApp';
                saveresult.success = true;
                metadataResponse.result = new List<MetadataService.SaveResult>();
                metadataResponse.result.add(saveresult);
                response.put('response_x', metadataResponse);
            } else if (request instanceof MetadataService.listMetadata_element) {
                // Mock response for listMetadata method
                MetadataService.FileProperties fileProperties = new MetadataService.FileProperties();
                fileProperties.fullName = 'Account.Test';
                fileProperties.type_x = 'CustomObject';
                
                MetadataService.listMetadataResponse_element listMetadataResponse = new MetadataService.listMetadataResponse_element();
                listMetadataResponse.result = new List<MetadataService.FileProperties>();
                listMetadataResponse.result.add(fileProperties);
                
                MetadataService.CompactLayout[] compactLayout = new MetadataService.CompactLayout[]{};
                MetadataService.IReadResponseElement response_x = new MetadataService.readCompactLayoutResponse_element();
                
                Map<String, MetadataService.IReadResponseElement> response_map_x = new Map<String, MetadataService.IReadResponseElement>();
                response_map_x.put('response_x', response_x);

                //compactLayouts
                response.put('response_x', listMetadataResponse);
            }
        }
    }


    
}