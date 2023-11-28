public class SampleClassW {
    
    public static List<SampleWrapper> SampleWrapp(){
        List<SampleWrapper> smplw = New List<SampleWrapper>();
        
        List<Account> accList = [SELECT id,Name,(SELECT Id, Name FROM Contacts)FROM Account];
             System.debug('accList: ' + accList);
        
        if(accList !=null){
            for(Account acc : accList){
               smplw.add(new SampleWrapper(acc, acc.Contacts)); 
            }
        }
        return smplw;
    }
    
    
    public class SampleWrapper{
        public Account accRecord{get;set;}
        public List<Contact> conList{get;set;}
        
        public SampleWrapper(Account accR , List<Contact> conL){
            this.accRecord = accR;
            this.conList = conL;
        }                        
    }
    
}