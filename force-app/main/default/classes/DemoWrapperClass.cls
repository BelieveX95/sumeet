public class DemoWrapperClass {
    
    /*  @AuraEnabled
public static String empolyeeDetails(String employeeslist){
System.debug('employeeslist' + employeeslist);

List<Employees> employees = (List<Employees>) JSON.deserialize(employeeslist, List<Employees>.class);

System.debug('employees deserialize' + employees);
if (employees != null && !employees.isEmpty()) {
String Id = employees[0].Id;
String employeeName = employees[0].employeeName;
String employeeStatus = employees[0].employeeStatus;
String occupation = employees[0].occupation;
String industry = employees[0].industry;

System.debug('employeeId: ' + Id);
System.debug('Employee Name: ' + employeeName);
System.debug('Employee Status: ' + employeeStatus);
System.debug('Occupation: ' + occupation);
System.debug('Industry: ' + industry);

return 'Employee Details Submited on Apex';
} else {
System.debug('No employee data found.');
return 'No employee data found';

}
}

public class Employees{
@AuraEnabled public String Id;       
@AuraEnabled public String employeeName;
@AuraEnabled public String employeeStatus;
@AuraEnabled public String occupation;
@AuraEnabled public String industry;

}
*/
    
       public class Wrapper {
        @AuraEnabled public Account acc { get; set; }
        @AuraEnabled public List<Contact> contacts { get; set; }
        @AuraEnabled public List<Opportunity> opportunities { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getAccountContactOpportunityData() {
        List<Wrapper> result = new List<Wrapper>();

        // Query for Account, Contact, and Opportunity records
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts), (SELECT Id, Name FROM Opportunities) FROM Account LIMIT 10];

        // Iterate through the accounts and create a Wrapper for each
        for (Account acc : accounts) {
            Wrapper wrapper = new Wrapper();
            wrapper.acc = acc;
            wrapper.contacts = acc.Contacts;
            wrapper.opportunities = new List<Opportunity>();

            // Extract the opportunities from the account's related opportunities
            for (Opportunity opp : acc.Opportunities) {
                wrapper.opportunities.add(opp);
            }

            result.add(wrapper);
        }
system.debug('result List==>'+result);
        return result;
    }
}