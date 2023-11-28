/*public class MetadataHelper {
@AuraEnabled

public static Integer getApexClassCount(String objectName) {
List<ApexTrigger> triggers = [SELECT Id FROM ApexTrigger WHERE TableEnumOrId = :objectName];
List<ApexClass> classes = [SELECT Id FROM ApexClass WHERE Name LIKE :objectName + '%'];
return triggers.size() + classes.size();
}
}*/
public class MetadataHelper {
    
    public class FieldMetadata {
        @AuraEnabled public String fieldName;
        @AuraEnabled public String apiName;
        @AuraEnabled public Boolean isEncrypted;
        @AuraEnabled public Integer length;
        @AuraEnabled public Object defaultValue;
        @AuraEnabled public Boolean isMandatory;
        @AuraEnabled public Boolean isExternalId;
        @AuraEnabled public Boolean isUnique;
        @AuraEnabled public Boolean isCaseSensitive;
        @AuraEnabled public String customDataType;
        @AuraEnabled public String fieldManageability;
        @AuraEnabled public String displayFormat;
        @AuraEnabled public String maskChar;
        @AuraEnabled public String maskType;
        @AuraEnabled public Boolean isDeprecated;
        @AuraEnabled public String description;
        @AuraEnabled public String inlineHelpText;
        @AuraEnabled public Boolean isEscapeMarkup;
        @AuraEnabled public Boolean isFilteringDisabled;
        @AuraEnabled public Boolean isSortingDisabled;
        @AuraEnabled public Boolean isRestrictedAdminField;
        @AuraEnabled public Boolean isStripMarkup;
        @AuraEnabled public Boolean isTrackFeedHistory;
        @AuraEnabled public Boolean isTrackHistory;
        @AuraEnabled public Boolean isTrackTrending;
        @AuraEnabled public Boolean isWriteRequiresMasterRead;
        @AuraEnabled public String displayLocationInDecimal;
    }
    
    @AuraEnabled
    public static List<FieldMetadata> getObjectFieldData(String objectApiName) {
        List<FieldMetadata> fieldMetadataList = new List<FieldMetadata>();
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = objectDescribe.fields.getMap();
        
        for (Schema.SObjectField field : fieldsMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            FieldMetadata metadata = new FieldMetadata();
            metadata.fieldName = fieldDescribe.getName();
            metadata.apiName = fieldDescribe.getName();
            metadata.isEncrypted = fieldDescribe.isEncrypted();
            metadata.length = fieldDescribe.getLength();
            metadata.defaultValue = fieldDescribe.getDefaultValue();
            metadata.isMandatory = !fieldDescribe.isNillable();
            metadata.isExternalId = fieldDescribe.isExternalId();
            metadata.isUnique = fieldDescribe.isUnique();
            metadata.isCaseSensitive = fieldDescribe.isCaseSensitive();
            metadata.customDataType = fieldDescribe.getType().name();
            metadata.fieldManageability = fieldDescribe.isCustom() ? 'Custom' : 'Standard';
            metadata.maskType = fieldDescribe.getMaskType();
            metadata.isDeprecated = fieldDescribe.isDeprecatedAndHidden();
            metadata.description = fieldDescribe.getLabel();
            metadata.inlineHelpText = fieldDescribe.getInlineHelpText();
            metadata.isWriteRequiresMasterRead = fieldDescribe.isWriteRequiresMasterRead();
            
            fieldMetadataList.add(metadata);
        }
        
        system.debug('Field Metadata List: ' + fieldMetadataList);
        return fieldMetadataList;
    }
    
    
    @AuraEnabled
    public static List<FieldData> getNonConfigurableFields(String objectApiName) {
        List<FieldData> nonConfigurableFields = new List<FieldData>();
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = objectDescribe.fields.getMap();
        
        for (Schema.SObjectField field : fieldsMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (!fieldDescribe.isCreateable() || !fieldDescribe.isUpdateable()) {
                FieldData data = new FieldData();
                data.name = fieldDescribe.getLabel();
                data.apiName = fieldDescribe.getName();
                data.dataType = fieldDescribe.getType().name();
                data.required = fieldDescribe.isNillable() ? 'No' : 'Yes';
                nonConfigurableFields.add(data);
            }
        }
        
        // Other methods or additional field data retrieval
        //	getWebLinks(objectApiName);
        retrievePicklistData(objectApiName);
        getFormulaFields(objectApiName);
        system.debug('result::>' + nonConfigurableFields);
        return nonConfigurableFields;
    }
    
    public class FieldData {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public String dataType;
        @AuraEnabled
        public String required;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<PicklistField> retrievePicklistData(String objectName) {
        List<PicklistField> picklistFields = new List<PicklistField>();
        
        // Get the SObject describe result for the object
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        // Get all the fields for the object
        Map<String, Schema.SObjectField> fieldsMap = objectDescribe.fields.getMap();
        
        // Iterate over the fields and retrieve picklist data
        for (String fieldName : fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            // Check if the field is a picklist field
            if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                // Retrieve the picklist values
                List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
                
                // Create a PicklistField object and add it to the list
                picklistFields.add(new PicklistField(fieldName, fieldDescribe, picklistEntries));
            }
        }
        System.debug('Result::>'+ picklistFields);
        return picklistFields;
    }
    
    public class PicklistField {
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public List<PicklistValue> picklistValues;
        
        public PicklistField(String fieldName, Schema.DescribeFieldResult fieldDescribe, List<Schema.PicklistEntry> picklistEntries) {
            this.fieldName = fieldName;
            this.picklistValues = new List<PicklistValue>();
            
            // Iterate over the picklist values and extract the desired information
            for (Schema.PicklistEntry picklistEntry : picklistEntries) {
                String label = picklistEntry.getLabel();
                String value = picklistEntry.getValue();
                Boolean isDefaultValue = picklistEntry.isDefaultValue();
                Boolean isRestricted = fieldDescribe.isRestrictedPicklist();
                String controllingField = fieldDescribe.getController() != null ? fieldDescribe.getController().getDescribe().getName() : null;
                String description = fieldDescribe.getLabel();
                String color = fieldDescribe.getInlineHelpText();
                Boolean allowEmail = fieldDescribe.externalid;
                Boolean isClosed = fieldDescribe.isCaseSensitive();
                Boolean isConverted = fieldDescribe.isUnique();
                Boolean isHighPriority = fieldDescribe.isUpdateable();
                
                // Create a PicklistValue object and add it to the picklistValues list
                picklistValues.add(new PicklistValue(label, value, isRestricted, controllingField, description, color, allowEmail, isClosed, isConverted, isHighPriority, isDefaultValue));
            }
        }
    }
    
    public class PicklistValue {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public Boolean isRestricted;
        @AuraEnabled
        public String controllingField;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String color;
        @AuraEnabled
        public Boolean allowEmail;
        @AuraEnabled
        public Boolean isClosed;
        @AuraEnabled
        public Boolean isConverted;
        @AuraEnabled
        public Boolean isHighPriority;
        @AuraEnabled
        public Boolean isDefaultValue;
        
        public PicklistValue(String label, String value, Boolean isRestricted, String controllingField, String description, String color, Boolean allowEmail, Boolean isClosed, Boolean isConverted, Boolean isHighPriority, Boolean isDefaultValue) {
            this.label = label;
            this.value = value;
            this.isRestricted = isRestricted;
            this.controllingField = controllingField;
            this.description = description;
            this.color = color;
            this.allowEmail = allowEmail;
            this.isClosed = isClosed;
            this.isConverted = isConverted;
            this.isHighPriority = isHighPriority;
            this.isDefaultValue = isDefaultValue;
        }
    }
    
    public class FormulaFieldMetadata {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String formulaTreatBlankAs;
        @AuraEnabled
        public String formula;
        
        public FormulaFieldMetadata(String label, String name, String formulaTreatBlankAs, String formula) {
            this.label = label;
            this.name = name;
            this.formulaTreatBlankAs = formulaTreatBlankAs;
            this.formula = formula;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<FormulaFieldMetadata> getFormulaFields(String objectApiName) {
        List<FormulaFieldMetadata> formulaFields = new List<FormulaFieldMetadata>();
        
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = globalDescribe.get(objectApiName);
        
        if (objectType != null) {
            Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
            
            for (String fieldName : fieldsMap.keySet()) {
                Schema.SObjectField field = fieldsMap.get(fieldName);
                
                if (field.getDescribe().isCalculated()) {
                    FormulaFieldMetadata metadata = new FormulaFieldMetadata(
                        field.getDescribe().getLabel(),
                        field.getDescribe().getName(),
                        field.getDescribe().getInlineHelpText(),
                        field.getDescribe().getCalculatedFormula()
                    );
                    
                    formulaFields.add(metadata);
                }
            }
        }
        system.debug('Formula::>'+formulaFields);
        return formulaFields;
    }
    public class WebLinkWrapper {
        @AuraEnabled
        public WebLink weblink;
        @AuraEnabled
        public String name;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<WebLinkWrapper> getWebLinks(String objectApiName) {
        List<WebLinkWrapper> webLinkWrappers = new List<WebLinkWrapper>();
        
        List<WebLink> webLinks = [SELECT Id, Name, DisplayType, Url, LinkType, OpenType, PageOrSobjectType, Height, Width, IsResizable, HasMenubar, HasScrollbars, HasToolbar, Position, IsProtected, RequireRowSelection, 
                                  ScontrolId, ShowsLocation, ShowsStatus, Description FROM WebLink WHERE PageOrSobjectType = :objectApiName ];
        
        for (WebLink webLink : webLinks) {
            WebLinkWrapper webLinkWrapper = new WebLinkWrapper();
            webLinkWrapper.weblink = webLink;
            webLinkWrapper.name = 'Weblink';
            webLinkWrappers.add(webLinkWrapper);
        }
        System.debug('Weblink::>'+webLinkWrappers);
        return webLinkWrappers;
    }
    public class RecordTypeData {
        @AuraEnabled
        public String recordTypeName { get; set; }
        @AuraEnabled
        public Boolean isActive { get; set; }
        @AuraEnabled
        public String businessProcess { get; set; }
        @AuraEnabled
        public String compactLayoutAssignment { get; set; }
        @AuraEnabled
        public String description { get; set; }
        @AuraEnabled
        public String picklistName { get; set; }
        @AuraEnabled
        public List<String> picklistValues { get; set; }
        
        // Constructor for RecordTypeData
        public RecordTypeData(String recordTypeName, Boolean isActive, String businessProcess,
                              String compactLayoutAssignment, String description,
                              String picklistName, List<String> picklistValues) {
                                  this.recordTypeName = recordTypeName;
                                  this.isActive = isActive;
                                  this.businessProcess = businessProcess;
                                  this.compactLayoutAssignment = compactLayoutAssignment;
                                  this.description = description;
                                  this.picklistName = picklistName;
                                  this.picklistValues = picklistValues;
                              }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<RecordTypeData> getRecordTypesData(String objectLabel) {
        List<RecordTypeData> recordTypesData = new List<RecordTypeData>();
        
        try {
            Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectLabel).getDescribe();
            Map<String, Schema.RecordTypeInfo> recordTypes = objectDescribe.getRecordTypeInfosByName();
            
            for (Schema.RecordTypeInfo recordType : recordTypes.values()) {
                RecordTypeData recordTypeData = new RecordTypeData(
                    recordType.getName(),
                    recordType.isActive(),
                    getBusinessProcess(recordType.getRecordTypeId()),
                    getCompactLayoutAssignment(recordType.getRecordTypeId()),
                    recordType.getName(), // Replace with the actual description retrieval logic
                    getPicklistName(objectLabel),
                    getPicklistValues(objectLabel)
                );
                
                recordTypesData.add(recordTypeData);
            }
        } catch (Exception e) {
            // Handle any exceptions here
        }
        
        System.debug('RecordTypes::>' + recordTypesData);
        return recordTypesData;
    }
    
    private static String getBusinessProcess(Id recordTypeId) {
        // Implement your logic to determine the business process based on the record type
        // Replace the following line with your actual implementation
        return 'Sample Business Process';
    }
    
    private static String getCompactLayoutAssignment(Id recordTypeId) {
        // Implement your logic to determine the compact layout assignment based on the record type
        // Replace the following line with your actual implementation
        return 'Sample Compact Layout Assignment';
    }
    
    private static String getPicklistName(String objectLabel) {
        String picklistName = '';
        
        // Retrieve the picklist name associated with the object
        // Implement your logic to determine the picklist name based on the object
        // Replace the following line with your actual implementation
        
        // Example implementation:
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectLabel).getDescribe().fields.getMap();
        for (Schema.SObjectField field : fieldsMap.values()) {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            if (fieldResult.isCreateable() && fieldResult.isUpdateable() && fieldResult.getType() == Schema.DisplayType.PICKLIST) {
                picklistName = fieldResult.getName();
                break;
            }
        }
        
        return picklistName;
    }
    
    private static List<String> getPicklistValues(String objectLabel) {
        List<String> values = new List<String>();
        
        // Retrieve the picklist values associated with the object
        // Implement your logic to determine the picklist values based on the object and picklist field name
        // Replace the following line with your actual implementation
        
        // Example implementation:
        String picklistName = getPicklistName(objectLabel);
        if (!String.isEmpty(picklistName)) {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectLabel);
            Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
            Schema.DescribeFieldResult fieldResult = objectDescribe.fields.getMap().get(picklistName).getDescribe();
            
            if (fieldResult.isCreateable() && fieldResult.isUpdateable() && fieldResult.getType() == Schema.DisplayType.PICKLIST) {
                List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
                for (Schema.PicklistEntry picklistEntry : picklistEntries) {
                    values.add(picklistEntry.getValue());
                }
            }
        }
        
        return values;
    }
    
    
    // Custom wrapper class to hold object data
    public class ObjectInfo {
        @AuraEnabled public String objectName { get; set; }
        @AuraEnabled public String objectLabel { get; set; }
        @AuraEnabled public String objectDescription { get; set; }
        @AuraEnabled public String customHelp { get; set; }
        @AuraEnabled public String sharingModel { get; set; }
        @AuraEnabled public String deploymentStatus { get; set; }
        @AuraEnabled public Boolean enableActivities { get; set; }
        @AuraEnabled public Boolean enableBulkApi { get; set; }
        @AuraEnabled public Boolean enableDivisions { get; set; }
        @AuraEnabled public Boolean enableEnhancedLookup { get; set; }
        @AuraEnabled public Boolean enableFeeds { get; set; }
        @AuraEnabled public Boolean enableHistory { get; set; }
        @AuraEnabled public Boolean enableReports { get; set; }
        @AuraEnabled public Boolean enableSharing { get; set; }
        @AuraEnabled public Boolean enableStreamingApi { get; set; }
        @AuraEnabled public String externalDataSource { get; set; }
        @AuraEnabled public String externalName { get; set; }
        @AuraEnabled public String externalRepository { get; set; }
        @AuraEnabled public String externalSharingModel { get; set; }
        @AuraEnabled public Boolean hasGenderField { get; set; }
        @AuraEnabled public Boolean hasHouseholdField { get; set; }
        @AuraEnabled public Boolean recordTypeTrackFeedHistory { get; set; }
        @AuraEnabled public Boolean recordTypeTrackHistory { get; set; }
        
        
    }
    
    
    // Method to check if the object supports Bulk API
    public static Boolean isObjectSupportsBulkApi(Schema.SObjectType objectType) {
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        return objectDescribe.isCreateable() && objectDescribe.isUpdateable();
    }
    
    @AuraEnabled(cacheable=true)
    public static ObjectInfo getObjectInfo(String objectApiName) {
        ObjectInfo objectInfo = new ObjectInfo();
        
        try {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
            
            if (objectType != null) {
                objectInfo.objectName = String.valueOf(objectType);
                objectInfo.objectLabel = objectType.getDescribe().getLabel();
                objectInfo.objectDescription = objectType.getDescribe().getKeyPrefix(); // For demonstration purposes, use getKeyPrefix() instead of getDescription()
                
                // Retrieve custom help text by fetching any field's custom help
                Map<String, Schema.SObjectField> fieldsMap = objectType.getDescribe().fields.getMap();
                if (!fieldsMap.isEmpty()) {
                    Schema.SObjectField firstField = fieldsMap.values()[0];
                    objectInfo.customHelp = firstField.getDescribe().getInlineHelpText();
                }
                
                objectInfo.sharingModel = objectType.getDescribe().isQueryable() ? 'ReadWrite' : 'NoSharing';
                objectInfo.deploymentStatus = objectType.getDescribe().isCustom() ? 'Deployed' : 'InDevelopment';
                
                // Retrieve additional properties
                Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
                objectInfo.enableActivities = objectDescribe.isQueryable() && objectDescribe.isMruEnabled();
                objectInfo.enableBulkApi = isObjectSupportsBulkApi(objectType);
                
                // Retrieve field information for isDivisible() and isEnhancedLookupEnabled()
                Schema.SObjectField divisibleField = fieldsMap.get('IsDivisible');
                objectInfo.enableDivisions = divisibleField != null && divisibleField.getDescribe().isCreateable() && divisibleField.getDescribe().isUpdateable();
                
                Schema.SObjectField enhancedLookupField = fieldsMap.get('EnhancedLookupEnabled');
                objectInfo.enableEnhancedLookup = enhancedLookupField != null && enhancedLookupField.getDescribe().isCreateable() && enhancedLookupField.getDescribe().isUpdateable();
                
                objectInfo.enableFeeds = objectDescribe.isQueryable() && objectDescribe.isFeedEnabled();
                
                // Check history tracking and reporting capabilities
                objectInfo.enableHistory = fieldsMap.containsKey('IsDeleted'); // Check if the object has the 'IsDeleted' field for history tracking
                
                objectInfo.enableReports = false; // Initialize to false, check if any field is 'aggregatable'
                for (Schema.SObjectField field : fieldsMap.values()) {
                    if (field.getDescribe().isAggregatable()) {
                        objectInfo.enableReports = true;
                        break;
                    }
                }
                
                // Retrieve external object properties (if applicable)
                objectInfo.enableStreamingApi = fieldsMap.containsKey('StreamingChannel'); // Check if the object has the 'StreamingChannel' field for streaming API
                
                objectInfo.externalDataSource = ''; // Initialize to empty, as standard and custom objects don't have an external data source
                objectInfo.externalName = ''; // Initialize to empty, as standard and custom objects don't have an external name
                objectInfo.externalRepository = ''; // Initialize to empty, as standard and custom objects don't have an external repository
                objectInfo.externalSharingModel = ''; // Initialize to empty, as standard and custom objects don't have an external sharing model
                
                if (fieldsMap.containsKey('ExternalDataSource')) {
                    // If the object has the 'ExternalDataSource' field, it is an external object
                    objectInfo.externalDataSource = String.valueOf(fieldsMap.get('ExternalDataSource').getDescribe().getReferenceTo()[0]);
                }
                if (fieldsMap.containsKey('ExternalName')) {
                    // If the object has the 'ExternalName' field, it is an external object
                    objectInfo.externalName = String.valueOf(fieldsMap.get('ExternalName').getDescribe().getReferenceTo()[0]);
                }
                if (fieldsMap.containsKey('ExternalRepository')) {
                    // If the object has the 'ExternalRepository' field, it is an external object
                    objectInfo.externalRepository = String.valueOf(fieldsMap.get('ExternalRepository').getDescribe().getReferenceTo()[0]);
                }
                if (fieldsMap.containsKey('ExternalSharingModel')) {
                    // If the object has the 'ExternalSharingModel' field, it is an external object
                    objectInfo.externalSharingModel = String.valueOf(fieldsMap.get('ExternalSharingModel').getDescribe().getReferenceTo()[0]);
                }
                
                // Check if the object has Gender and Household fields
                objectInfo.hasGenderField = fieldsMap.containsKey('Gender__c');
                objectInfo.hasHouseholdField = fieldsMap.containsKey('Household__c');
                
                // Check if the object has RecordType fields for Feed History and History Tracking
                objectInfo.recordTypeTrackFeedHistory = fieldsMap.containsKey('RecordTypeId') && fieldsMap.containsKey('FeedItemId');
                objectInfo.recordTypeTrackHistory = fieldsMap.containsKey('RecordTypeId') && fieldsMap.containsKey('HistoryId');
            } else {
                System.debug('Object API name "' + objectApiName + '" not found.');
            }
        } catch (Exception e) {
            System.debug('Error while fetching object data: ' + e.getMessage());
        }
        System.debug('Data::>' + objectInfo);
        return objectInfo;
    }  
    
    public class ActionOverrideInfo {
        @AuraEnabled public String actionName { get; set; }
        @AuraEnabled public String actionType { get; set; }
        @AuraEnabled public Boolean skipRecordTypeSelect { get; set; }
        @AuraEnabled public String content { get; set; }
        @AuraEnabled public String comment { get; set; }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ActionOverrideInfo> getActionOverrideData(String objectApiName) {
        List<ActionOverrideInfo> actionOverrideDataList = new List<ActionOverrideInfo>();
        
        // Create the MetadataService.MetadataPort instance
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = fetchUserSessionId();
        
        String fullName = objectApiName + '.ActionOverride';
        
        // Call the readMetadata method on the service instance
        MetadataService.IReadResult readResult = service.readMetadata('CustomObject', new String[] { fullName });
        
        // Check if the readResult is not null before accessing records
        if (readResult != null && readResult.getRecords() != null) {
            MetadataService.Metadata[] metadata = readResult.getRecords();
            
            // Debugging statement: Check the size of the metadata array
            System.debug('Metadata Array Size: ' + metadata.size());
            
            for (MetadataService.Metadata md : metadata) {
                if (md instanceof MetadataService.CustomObject) {
                    MetadataService.CustomObject customObject = (MetadataService.CustomObject) md;
                    
                    // Check if actionOverrides is not null before accessing its elements
                    if (customObject.actionOverrides != null) {
                        MetadataService.ActionOverride[] actionOverrides = customObject.actionOverrides;
                        
                        for (MetadataService.ActionOverride actionOverride : actionOverrides) {
                            ActionOverrideInfo actionOverrideInfo = new ActionOverrideInfo();
                            
                            actionOverrideInfo.actionName = actionOverride.actionName;
                            actionOverrideInfo.actionType = actionOverride.type_x;
                            actionOverrideInfo.skipRecordTypeSelect = actionOverride.skipRecordTypeSelect;
                            actionOverrideInfo.content = actionOverride.content;
                            actionOverrideInfo.comment = actionOverride.comment;
                            
                            actionOverrideDataList.add(actionOverrideInfo);
                        }
                    }
                }
            }
        }
        
        // Debugging statement: Check the size of the actionOverrideDataList
        System.debug('Action Override Data List Size: ' + actionOverrideDataList.size());
        System.debug('Test::>' + actionOverrideDataList);
        return actionOverrideDataList;
    }
    
    
    
    public class CompactLayoutWrapper {
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String name { get; set; }
        
        @AuraEnabled
        public List<String> fields { get; set; }
        
        public CompactLayoutWrapper(String label, String name, List<String> fields) {
            this.label = label;
            this.name = name;
            this.fields = fields;
        }
    }
    
    public static String fetchUserSessionId(){
        String sessionId = '';
        // Refer to the Page
        PageReference reportPage = Page.GetSessionIdVF;
        // Get the content of the VF page
        String vfContent;
        if(Test.isRunningTest()){
            blob pdfbody;
            pdfbody = blob.valueOf('Unit.Test');
        }else{
        	vfContent = reportPage.getContent().toString();
        }
        //System.debug('vfContent '+vfContent);
        // Find the position of Start_Of_Session_Id and End_Of_Session_Id
        if(vfContent != null){
            Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                endP = vfContent.indexOf('End_Of_Session_Id');
            // Get the Session Id
            sessionId = vfContent.substring(startP, endP);
        }
        //System.debug('sessionId from VF Page'+sessionId);
        // Return Session Id
        system.debug('SessionIIId ::>' + sessionId);
        return sessionId;
    }
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<CompactLayoutWrapper> getCompactLayoutsData(String objectAPIName) {
        List<CompactLayoutWrapper> compactLayoutsList = new List<CompactLayoutWrapper>();
        
        // Add a namespace prefix if needed
        String fullNamePrefix = objectAPIName + '.Test';
        System.debug('Test::1'+fullNamePrefix);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = fetchUserSessionId();
        
        try {
            MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
            query.type_x = 'CompactLayout';
            
            // Fetch all the Compact Layouts
            MetadataService.FileProperties[] fileProperties = service.listMetadata(new MetadataService.ListMetadataQuery[] { query }, 49);
            system.debug('Check:>'+fileProperties);
            
            if (fileProperties != null) {
                for (MetadataService.FileProperties fileProperty : fileProperties) {
                    // Check if the Compact Layout belongs to the specified objectAPIName
                    system.debug('Check:>'+fileProperty.fullName);
                    
                    system.debug('Check:>'+fileProperty.fullName.startsWith(fullNamePrefix));
                    
                    if (fileProperty.fullName.startsWith(fullNamePrefix)) {
                        system.debug('Check:>'+fileProperty.fullName.startsWith(fullNamePrefix));
                        // Read the metadata for the Compact Layout
                        MetadataService.IReadResult result = service.readMetadata('CompactLayout', new String[] { fileProperty.fullName });
                        
                        if (result != null && result.getRecords() != null && !result.getRecords().isEmpty()) {
                            MetadataService.CompactLayout layout = (MetadataService.CompactLayout) result.getRecords()[0];
                            compactLayoutsList.add(new CompactLayoutWrapper(layout.label, layout.fullName, layout.fields));
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        System.debug('data::>'+compactLayoutsList);
        return compactLayoutsList;
    }
    
    
    
    
    public class ListViewData {
        public String label;
        public String name;
        public String filter;
        public String filterScope;
        public List<String> columns;
        public Boolean allCustomerPortalUsers;
        public Boolean allInternalUsers;
        public Boolean allPartnerUsers;
        //    public Boolean group;
        public Boolean groups;
        public Boolean Managers;
        public Boolean ManagerSubordinates;
        public Boolean PortalRole;
        public Boolean PortalRoleandSubordinates;
        public Boolean Role;
        public Boolean roleAndSubordinates;
        public Boolean roleAndSubordinatesInternal;
        public Boolean roles;
        public Boolean rolesAndSubordinates;
        public Boolean Territories;
        public Boolean territory;
        public Boolean territoryAndSubordinates;
        public Boolean queue;
        
        public ListViewData(String label, String name, String filter, String filterScope, List<String> columns) {
            this.label = label;
            this.name = name;
            this.filter = filter;
            this.filterScope = filterScope;
            this.columns = columns;
            // Initialize predefined fields as false by default
            this.allCustomerPortalUsers = false;
            this.allInternalUsers = false;
            this.allPartnerUsers = false;
            //      this.group = false;
            this.groups = false;
            this.Managers = false;
            this.ManagerSubordinates = false;
            this.PortalRole = false;
            this.PortalRoleandSubordinates = false;
            this.Role = false;
            this.roleAndSubordinates = false;
            this.roleAndSubordinatesInternal = false;
            this.roles = false;
            this.rolesAndSubordinates = false;
            this.Territories = false;
            this.territory = false;
            this.territoryAndSubordinates = false;
            this.queue = false;
        }
    }
    
    public static List<ListViewData> getListViewDataByObject(String objectAPIName) {
        List<ListViewData> listViewDataList = new List<ListViewData>();
        
        try {
            // Initialize the MetadataService instance from apex-mdapi
            MetadataService.MetadataPort service = MetadataServiceExamples.createService();
            
            // Query for all ListViews related to the specified object
            List<MetadataService.ListView> listViews = (List<MetadataService.ListView>) service.readMetadata('ListView', new String[] { objectAPIName + '.*' }).getRecords();
            
            if (listViews != null) {
                for (MetadataService.ListView listView : listViews) {
                    // Check if listView.fullName is not null
                    if (listView.fullName != null) {
                        // Extract required data from the ListView
                        String label = listView.fullName;
                        String filter = listView.booleanFilter;
                        String filterScope = listView.filterScope;
                        List<String> columns = new List<String>(listView.columns);
                        
                        // Create the ListViewData instance with the retrieved data and add it to the list
                        ListViewData listViewData = new ListViewData(label, listView.fullName, filter, filterScope, columns);
                        
                        // Check for predefined fields and set them to true if found in the ListView name
                        listViewData.allCustomerPortalUsers = listView.fullName.containsIgnoreCase('allCustomerPortalUsers');
                        listViewData.allInternalUsers = listView.fullName.containsIgnoreCase('allInternalUsers');
                        listViewData.allPartnerUsers = listView.fullName.containsIgnoreCase('allPartnerUsers');
                        //  listViewData.group = listView.fullName.containsIgnoreCase('group');
                        listViewData.groups = listView.fullName.containsIgnoreCase('groups');
                        listViewData.Managers = listView.fullName.containsIgnoreCase('Managers');
                        listViewData.ManagerSubordinates = listView.fullName.containsIgnoreCase('ManagerSubordinates');
                        listViewData.PortalRole = listView.fullName.containsIgnoreCase('PortalRole');
                        listViewData.PortalRoleandSubordinates = listView.fullName.containsIgnoreCase('PortalRoleandSubordinates');
                        listViewData.Role = listView.fullName.containsIgnoreCase('Role');
                        listViewData.roleAndSubordinates = listView.fullName.containsIgnoreCase('roleAndSubordinates');
                        listViewData.roleAndSubordinatesInternal = listView.fullName.containsIgnoreCase('roleAndSubordinatesInternal');
                        listViewData.roles = listView.fullName.containsIgnoreCase('roles');
                        listViewData.rolesAndSubordinates = listView.fullName.containsIgnoreCase('rolesAndSubordinates');
                        listViewData.Territories = listView.fullName.containsIgnoreCase('Territories');
                        listViewData.territory = listView.fullName.containsIgnoreCase('territory');
                        listViewData.territoryAndSubordinates = listView.fullName.containsIgnoreCase('territoryAndSubordinates');
                        listViewData.queue = listView.fullName.containsIgnoreCase('queue');
                        
                        listViewDataList.add(listViewData);
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        System.debug('Data::>'+ listViewDataList );
        return listViewDataList;
    }
    
    
    
    public class FieldInfo {
        @AuraEnabled public String fieldName { get; set; }
        @AuraEnabled public String apiName { get; set; }
        @AuraEnabled public String dataType { get; set; }
        @AuraEnabled public String displayFormat { get; set; }
        @AuraEnabled public Integer startingNumber { get; set; }
    }
    
    
    @AuraEnabled
    public static List<FieldInfo> getObjectNameData(String objectApiName) {
        List<FieldInfo> fieldInfoList = new List<FieldInfo>();
        
        // Describe the object dynamically
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        if (objectType == null) {
            // Handle invalid object API name
            return fieldInfoList;
        }
        
        // Get the object's fields
        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
        
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            
            FieldInfo fieldInfo = new FieldInfo();
            fieldInfo.fieldName = fieldResult.getLabel();
            fieldInfo.apiName = fieldResult.getName();
            fieldInfo.dataType = String.valueOf(fieldResult.getType());
            fieldInfo.displayFormat = fieldResult.getInlineHelpText();
            //  fieldInfo.startingNumber = fieldResult.getStartingNumber();
            
            fieldInfoList.add(fieldInfo);
        }
        System.debug('Data::>' + fieldInfoList );
        return fieldInfoList;
    }
    
    
}