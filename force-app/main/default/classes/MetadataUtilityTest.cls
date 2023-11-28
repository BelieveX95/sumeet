@isTest
public class MetadataUtilityTest {
    @isTest
    static void testGenerateField() {
        String objectAPIName = 'Contact';
        String fieldAPIName = 'Test_Field__c';
        String fieldDescription = 'Test Field Description';
        String fieldLabel = 'Test_Field';
        String fieldType = 'TEXT';
        
        Test.startTest();
        MetadataUtility.generateField(objectAPIName, fieldAPIName, fieldDescription, fieldLabel, fieldType);
        Test.stopTest();
        
    }
    
    @isTest
    static void testGenerateFormulaField() {
        String objectAPIName = 'Contact';
        String fieldAPIName = 'Test_Field__c';
        String fieldDescription = 'Formula Field Description';
        String fieldLabel = 'Test_Field';
        String returnType = 'TEXT';
        String validFormula = 'TEXT(Field__c)';
        
        Test.startTest();
        MetadataUtility.generateFormulaField(objectAPIName, fieldAPIName, fieldDescription, fieldLabel, returnType, validFormula);
        Test.stopTest();
        
    }
}