@IsTest
private class OrderFormControllerTest {
    @IsTest
    static void testSearchAccounts() {
        // Test data setup
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            accounts.add(acc);
        }
        insert accounts;

        Test.startTest();
        List<Account> result = OrderFormController.searchAccounts('Test');
        Test.stopTest();

        // Assertions
        System.assertEquals(10, result.size(), 'Incorrect number of accounts returned');

        // Additional assertion for specific account name
        System.assertEquals('Test Account 0', result[0].Name, 'Incorrect account name');
        

    }

    @IsTest
    static void testGetProductTypePicklistValues() {
        Test.startTest();
        List<String> result = OrderFormController.getProductTypePicklistValues();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(0, result.size(), 'Product type picklist values not retrieved');

        // Additional assertion for specific picklist value
        // Modify the assertion based on your picklist values
        System.assert(result.contains('Value 1'), 'Expected picklist value not found');
    }

    @IsTest
    static void testGetRoundSectionPicklistValues() {
        Test.startTest();
        List<String> result = OrderFormController.getRoundSectionPicklistValues();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(0, result.size(), 'Round section picklist values not retrieved');

        // Additional assertion for specific picklist value
        // Modify the assertion based on your picklist values
        System.assert(result.contains('Value 2'), 'Expected picklist value not found');
    }

    @IsTest
    static void testGetProductName() {
        // Test data setup
        Product2 product = new Product2(
            Name = 'Test Product',
            Product_Type__c = 'Type',
            Round_Section__c = 'Section'
        );
        insert product;

        Test.startTest();
        OrderFormController.ProductInfo result = OrderFormController.getProductName('Type', 'Section');
        Test.stopTest();

        // Assertions
        System.assertEquals(product.Name, result.productName, 'Incorrect product name');
        System.assertEquals(product.Id, result.productId, 'Incorrect product ID');
    }

    @IsTest
    static void testCreateOrder() {
        // Test data setup
        Account account = new Account(Name = 'Test Account');
        insert account;

        Pricebook2 pricebook = new Pricebook2(
            Name = 'Standard Price Book',
            IsActive = true
        );
        insert pricebook;

        Product2 product = new Product2(Name = 'Test Product');
        insert product;

        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebook.Id,
            Product2Id = product.Id,
            UnitPrice = 100
        );
        insert pricebookEntry;

        Test.startTest();
        Id orderId = OrderFormController.createOrder(account.Id, Date.today(), 'Draft',
                                                     product.Id, 1, account.Name);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, orderId, 'Order not created');

        // Additional assertions for order status and contract start date
        Order createdOrder = [SELECT Status, ContractId FROM Order WHERE Id = :orderId];
        System.assertEquals('Draft', createdOrder.Status, 'Incorrect order status');
        Contract createdContract = [SELECT StartDate FROM Contract WHERE Id = :createdOrder.ContractId];
        System.assertEquals(Date.today(), createdContract.StartDate, 'Incorrect contract start date');
    }
}