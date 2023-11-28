public with sharing class OrderFormController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchKey) {
        String searchQuery = '%' + searchKey + '%';
        List<Account> accounts = [SELECT Id, Name, BillingStreet, BillingCity, BillingCountry, BillingPostalCode
                                  FROM Account
                                  WHERE Name LIKE :searchQuery
                                  LIMIT 10];
        System.debug('searchAccounts: ' + accounts);
        return accounts;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getProductTypePicklistValues() {
        List<String> picklistValues = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Product2.Product_Type__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistEntries) {
            picklistValues.add(entry.getLabel());
        }
        
        return picklistValues;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getRoundSectionPicklistValues() {
        List<String> picklistValues = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Product2.Round_Section__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : picklistEntries) {
            picklistValues.add(entry.getLabel());
        }
        
        return picklistValues;
    }
    
    @AuraEnabled(cacheable=true)
    public static ProductInfo getProductName(String productType, String section) {
        ProductInfo productInfo = new ProductInfo();
        
        if (productType != null && section != null) {
            List<Product2> products = [SELECT Id, Name
                                       FROM Product2
                                       WHERE Product_Type__c = :productType
                                       AND Round_Section__c = :section
                                       LIMIT 1];
            if (!products.isEmpty()) {
                Product2 product = products[0];
                productInfo.productName = product.Name;
                productInfo.productId = product.Id;
            }
        }
        
        return productInfo;
    }

    public class ProductInfo {
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public String productId;
    }

    @AuraEnabled
    public static Id createOrder(String accountId, Date poDate, String status,
                                   String productId, Integer quantity, String accountName) {
                                       system.debug('accountId'+accountId);
                                        system.debug('checkkk  productId'+productId);

        try {
            
             List<PricebookEntry> pricebookEntries = [SELECT Id, UnitPrice, Pricebook2Id
                                                     FROM PricebookEntry
                                                     WHERE Product2Id = :productId
                                                     AND Pricebook2.Name = 'Standard Price Book'
                                                     LIMIT 1];
    
            System.debug('PricebookEntries: ' + pricebookEntries);
    
            Contract newCon = new Contract();
            newCon.AccountId = accountId;
            newCon.Status = 'Draft';
            newCon.StartDate = System.today();
            newCon.ContractTerm = 24;
            
            insert newCon;
            System.debug('NewCon: ' + newCon);
            
            
            Order newOrder = new Order();
            newOrder.AccountId = accountId;
            newOrder.EffectiveDate = System.today(); 
            newOrder.Status = status;
            newOrder.ContractId = newCon.Id;
            newOrder.Pricebook2Id =  pricebookEntries[0].Pricebook2Id;
    
            insert newOrder;
            System.debug('NewOrder: ' + newOrder);
    
           
            
    
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = newOrder.Id;
            orderItem.Product2Id = productId;
            orderItem.Quantity = quantity;       
            orderItem.PricebookEntryId = pricebookEntries[0].Id;
            orderItem.UnitPrice = pricebookEntries[0].UnitPrice;
            orderItem.ListPrice = pricebookEntries[0].UnitPrice;
    
            insert orderItem;
            
            System.debug('OrderItem: ' + orderItem);
        return newOrder.Id;
    } catch (Exception e) {
        throw new AuraHandledException('Error creating order: ' + e.getMessage());
    }
}
}