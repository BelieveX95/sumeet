global class SampleFutureClass {
  /*  @Future
    public static void getAccounts(){
       List<Account> acList = [SELECT id,Name FROM Account];
        system.debug('acList'+acList);
    }*/
    
    global static List<String> getAllCustomSObjects()
{
    List<String> sObjectList = new List<String>();
    for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
    {
        Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
       
            String name = objTyp.getDescribe().getName();
          
                SobjectList.add(name);
            
        
    }
    system.debug('SObjectList****' + SObjectList);
        system.debug('SObjectList****' + SObjectList.size());

    return sObjectList;
}


}