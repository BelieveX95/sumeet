({
    createAccount: function(component, event, helper) {
        var opportunityId = component.get("v.opportunityId");
        var newAccount = component.get("v.newAccount");
        
        var action = component.get("c.saveAccount");
        action.setParams({ account: newAccount });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var createdAccount = response.getReturnValue();
                if (createdAccount) {
                    var UpdateOpp  = component.get("c.updateOpportunity");
                    
                    UpdateOpp.setParams({
                        opportunityId: opportunityId,
                        accountId: createdAccount.Id
                    });
                    UpdateOpp.setCallback(this, function(response) {
                        var updateState = response.getState();
                        if (updateState === "SUCCESS") {
                            console.log("Account created and Opportunity updated successfully.");
                            $A.get("e.force:closeQuickAction").fire();
                            
                        } else {
                            console.log("Error updating Opportunity: ", response.getError());
                        }
                    });
                    $A.enqueueAction(UpdateOpp);
                }
            } else {
                console.log("Error creating account: ", response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})