trigger SH_AccountTrigger on Account (after insert, after update) {
    set<Id> accSetId = new set<Id>();
    for (Account acc : Trigger.new) {
        if (acc.Name != null) {
            accSetId.add(acc.Id);
        }
    }
   
    if (accSetId.size() > 0) {
        if (Trigger.isInsert) {
           // SH_AccountCreateAPI.createAccountMethod(accSetId);
        }
        else if (Trigger.isUpdate) {
            SH_AccountUpdateAPI.updateAccountMethod(accSetId);
        }
    }
}