({
    init: function(component, event, helper) {
        var opportunityId = component.get("v.recordId");
        console.log('opportunityId',opportunityId);
        var action = component.get("c.getAccountDetails");
        action.setParams({
            opportunityId: opportunityId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accounts = response.getReturnValue();
                console.log('accounts',accounts);
                
                component.set("v.Acclist", accounts);
            } else {
                console.log("Error retrieving account details");
            }
        });
        
        $A.enqueueAction(action);
    },
    
    searchAccounts: function(component, event, helper) {
        var searchKey = component.get("v.SearchKey");
        var accountList = component.get("v.Acclist");
        
        var action = component.get("c.searchAccountsInDetails");
        if (searchKey == "") {
            action.setParams({
                searchKey: "",
                accountList: accountList
            });
        } else {
            action.setParams({
                searchKey: searchKey,
                accountList: accountList
            });
        }
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accounts = response.getReturnValue();
                component.set("v.Acclist", accounts);
            } else {
                console.log("Error searching accounts");
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    handleSelection: function(component, event, helper) {
        var selectedAccountId = event.target.value;
        component.set("v.Submit", true);
        
        console.log(selectedAccountId);
        component.set("v.selectedAccountId", selectedAccountId);
    },
    
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        console.log('clicked');
        var selectedAccountId = component.get("v.selectedAccountId");
        var opportunityId = component.get("v.recordId");
        
        var action = component.get("c.updateOpportunityAccount");
        action.setParams({
            opportunityId: opportunityId,
            accountId: selectedAccountId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Opportunity Account updated");
                $A.get("e.force:closeQuickAction").fire();
                
            } else {
                console.log("Error updating Opportunity Account");
            }
        });
        
        $A.enqueueAction(action);
        component.set("v.isModalOpen", false);
    },
    
    createAccount: function(component, event, helper) {
        component.set("v.showCreateAccount", true);
        component.set("v.HideComp", false);
    },
    
    
})