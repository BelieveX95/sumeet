trigger CountContatc on Contact (before insert, after insert, before update, after update) {
    if(trigger.isafter && trigger.isDelete){
        set<id> accids=New  set<id>(); 
        for(Contact Con:trigger.Old){
            accids.add(Con.AccountId);    
        }     
        List<Account> acclist=[Select id,(select id from contacts)from account where Id IN:accids];
        for(Account acc:acclist ){
            acc.NumberOfContacts__c=acc.contacts.size();        
        }    
        UPDATE acclist;
        
        system.debug('acclist'+acclist);
        
    }
    
    
    if(trigger.isafter && trigger.isInsert){
        set<id> accids=New  set<id>();     
        for(Contact Con:trigger.new){
            accids.add(Con.AccountId);        
        } 
        List<Account> acclist=[Select id,(select id from contacts)from account where Id IN:accids];
        for(Account acc:acclist ){
            acc.NumberOfContacts__c=acc.contacts.size();        
        }    
        UPDATE acclist;
                system.debug('acclist'+acclist);

        
    } 
}