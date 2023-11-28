/*({
    init: function(component, event, helper) {
        var opportunityId = component.get("v.recordId");
        alert(opportunityId);
        console.log('opportunityId', opportunityId);
        
        var action = component.get("c.getAccountDetails");
        action.setParams({
         //   opportunityId: opportunityId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunity = response.getReturnValue();
                var accountId = opportunity.AccountId;
              //  component.set("v.accountId", accountId);
                if (accountId) {
              //      helper.getAccountDetails(component, accountId);
                }
            }
        });

        $A.enqueueAction(action);
    },
    
})*/

({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        alert(recordId);
    }
})