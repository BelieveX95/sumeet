({
    init: function(component, event, helper) {
        var objectName = component.get("v.objectName");
        var fieldNames = component.get("v.fieldName");

        var action = component.get("c.getRecord");
        action.setParams({
            objectName: objectName,
            fieldNames: fieldNames
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var tableRows = response.getReturnValue();
                var tableData = [];

                tableRows.forEach(function(row) {
                    tableData.push(row.values);
                });

                component.set("v.recordData", tableData);
                component.set("v.tableColumns", fieldNames.split(','));
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error("Error occurred: " + errors[0].message);
            }
        });

        $A.enqueueAction(action);
    }
})