public class ProductListController  {
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getProducts() {
        List<PricebookEntry> pricebookList = new List<PricebookEntry>();
        
        pricebookList = [select Name, UnitPrice from PricebookEntry LIMIT 3];
        return pricebookList;
    }
    
    
     @AuraEnabled
    public static void addToBasket(String productId, Integer count, Decimal totalPrice) {
        System.debug('productId==>'+productId);
                System.debug('count==>'+count);
        System.debug('totalPrice==>'+totalPrice);

    }
}