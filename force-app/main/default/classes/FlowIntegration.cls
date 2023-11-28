public class FlowIntegration {
    @InvocableMethod(label='Get Account Names' description='Returns the list of account names corresponding to the specified account IDs.' category='Account')
    public static List<Account> getAccount(List<List<Id>> AccountSingle) {
        List<Account> acc = [SELECT Id, Name FROM Account WHERE Id = :AccountSingle[0]];
        System.debug('acc' + acc);
        
        // Build the JSON object with "accounts" as the key and an array of maps
        List<Map<String, Object>> accountMaps = new List<Map<String, Object>>();
        for (Account a : acc) {
            Map<String, Object> accountMap = new Map<String, Object>();
            accountMap.put('Id', a.Id);
            accountMap.put('Name', a.Name);
            accountMaps.add(accountMap);
        }
        Map<String, Object> requestBodyMap = new Map<String, Object>();
        requestBodyMap.put('accounts', accountMaps);
        
        String accountsJSON = JSON.serialize(requestBodyMap);
        
        // Rest of the code remains the same
        String destinationOrgEndpoint = 'callout:OrgConnection/services/apexrest/receiveAccounts';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(destinationOrgEndpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(accountsJSON);
        
        HttpResponse response = new Http().send(request);
        
        if (response.getStatusCode() == 200) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        return acc;
    }
}