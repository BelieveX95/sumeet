({
  handleFilesChange: function (component, event, helper) {
    var fileInput = document.getElementById("fuploader");
    var file = fileInput.files[0];
    
    if (file) {
        var reader = new FileReader();
        reader.onload = function (e) {
            var fileContents = e.target.result;
            var parentId = component.get("v.parentId");
            console.log('parentId', parentId);
            console.log('fileContents', fileContents);
            
            // Call the server-side controller to process the CSV file
            var action = component.get("c.processCSVFile");
            action.setParams({
                parentId: parentId,
                fileContents: fileContents
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var tableData = response.getReturnValue();
                    console.log('tableData==>', tableData);
                    // Set the csvData attribute with the processed data
                    component.set("v.csvData", tableData);
                    
                    // Define columns for the Lightning DataTable
                    var columns = [];
                    if (tableData.length > 0) {
                        for (var i = 0; i < tableData[0].length; i++) {
                            columns.push({
                                label: 'Column ' + (i + 1),
                                fieldName: 'column' + i,
                                type: 'text'
                            });
                        }
                    }
                    component.set("v.columns", columns);
                }
            });
            $A.enqueueAction(action);
        };
        reader.readAsText(file);
    }
},

})