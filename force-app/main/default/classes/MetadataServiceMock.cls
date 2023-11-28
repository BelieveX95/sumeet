@isTest
public class MetadataServiceMock implements WebServiceMock{
   public static final String[] RECORD_TYPE_FULL_NAMES = new String[] {
        'cve__BenefitClaimed__c.cve__ShortTermDisability'
    };
    public static final String[] CUSTOM_FIELD_FULL_NAMES = new String[] {
        'Contact.Email',
        'cve__BenefitClaimed__c.cve__DateOfDiagnosis__c'
    };

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

        if (request instanceof MetadataService.readMetadata_element) {
            response.put('response_x', readResponse(request));
        } else if (request instanceof MetadataService.updateMetadata_element) {
            response.put('response_x', updateResponse(request));
        } else if (request instanceof MetadataService.upsertMetadata_element) {
            response.put('response_x', upsertResponse(request));
        } else {
            System.assert(false, 'Unexpected request ' + request);
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
            recordType.fullName = RECORD_TYPE_FULL_NAMES[0];
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
            result.records = new MetadataService.CustomField[] {
                createContactEmailField(),
                createBenefitClaimedDateOfDiagnosisField()
            };

            MetadataService.readCustomFieldResponse_element responseElement = new MetadataService.readCustomFieldResponse_element();
            responseElement.result = result;

            return responseElement;

        }else if(r.type_x == 'Profile'){
            MetadataService.ReadProfileResult result = new MetadataService.ReadProfileResult();
            String selectedProfile = 'Admin';
            MetadataService.Profile[] profiles = new List<MetadataService.Profile>();
            MetadataService.Profile profile = new MetadataService.Profile();
            profile.fullName = selectedProfile;
            profile.description = 'Test Description';
            profile.custom = false;
            profile.userLicense = 'Salesforce';
            profiles.add(profile);

            result.records = new MetadataService.Profile[] {};
            result.records = profiles;
            
            // Layout Assignments
            MetadataService.ProfileLayoutAssignment layoutAssignment = new MetadataService.ProfileLayoutAssignment();
            layoutAssignment.layout = 'Account-Account Layout';
            layoutAssignment.recordType = 'Master';
            profile.layoutAssignments = new MetadataService.ProfileLayoutAssignment[] { layoutAssignment };
            //profile.layoutAssignments = layoutAssignment;
            
            /*
            // Record Type Visibilities
            MetadataService.RecordTypeVisibility recordTypeVisibility = new MetadataService.RecordTypeVisibility();
            recordTypeVisibility.recordType = 'Account.MyRecordType';
            recordTypeVisibility.visible = true;
            profile.recordTypeVisibilities = new MetadataService.RecordTypeVisibility[] { recordTypeVisibility };
                */
            
            // User Permissions
            MetadataService.ProfileUserPermission userPermission = new MetadataService.ProfileUserPermission();
            userPermission.name = 'ViewAllData';
            userPermission.enabled = true;
            profile.userPermissions = new MetadataService.ProfileUserPermission[] { userPermission };
                
                // Application Visibilities
                MetadataService.ProfileApplicationVisibility appVisibility = new MetadataService.ProfileApplicationVisibility();
            appVisibility.application = 'standard__Sales';
            //appVisibility.default = true;
            profile.applicationVisibilities = new MetadataService.ProfileApplicationVisibility[] { appVisibility };
                
                // Tab Visibilities
                MetadataService.ProfileTabVisibility tabVisibility = new MetadataService.ProfileTabVisibility();
            tabVisibility.tab = 'standard-Account';
            tabVisibility.visibility = 'DefaultOn';
            profile.tabVisibilities = new MetadataService.ProfileTabVisibility[] { tabVisibility };
                
                // Login IP Ranges
                MetadataService.ProfileLoginIpRange ipRange = new MetadataService.ProfileLoginIpRange();
            ipRange.startAddress = '192.168.1.1';
            ipRange.endAddress = '192.168.1.10';
            profile.loginIpRanges = new MetadataService.ProfileLoginIpRange[] { ipRange };

            /*result.records = */
            MetadataService.readProfileResponse_element responseEmelement = new MetadataService.readProfileResponse_element();
            responseEmelement.result = result;
            return responseEmelement;
        }
        else {
            System.assert(false, 'Unexpected read type ' + r.type_x);
            return null;
        }
    }

    public static MetadataService.CustomField createContactEmailField() {

        MetadataService.CustomField f = new MetadataService.CustomField();
        f.type_x = String.valueOf(DisplayType.Email);
        f.fullName = CUSTOM_FIELD_FULL_NAMES[0];
        f.label = 'Email';
        f.length = 80;
        f.encrypted = false;

        return f;
    }

    public static MetadataService.CustomField createBenefitClaimedDateOfDiagnosisField() {

        MetadataService.CustomField f = new MetadataService.CustomField();
        f.type_x = String.valueOf(DisplayType.Date);
        f.fullName = CUSTOM_FIELD_FULL_NAMES[1];
        f.label = 'Date';
        f.encrypted = false;

        return f;
    }

    // Does nothing except return success
    private MetadataService.updateMetadataResponse_element updateResponse(Object request) {

        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.success = true;

        MetadataService.updateMetadataResponse_element responseElement = new MetadataService.updateMetadataResponse_element();
        responseElement.result = new MetadataService.SaveResult[] {result};

        return responseElement;
    }

    // Does nothing except return success
    private MetadataService.upsertMetadataResponse_element upsertResponse(Object request) {

        MetadataService.UpsertResult result = new MetadataService.UpsertResult();
        result.success = true;

        MetadataService.upsertMetadataResponse_element responseElement = new MetadataService.upsertMetadataResponse_element();
        responseElement.result = new MetadataService.UpsertResult[] {result};

        return responseElement;
    }
}