({  
    handleFileClick:function(component, event, helper){
        component.set("v.fileName", 'No File Selected..');
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = '';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            component.set("v.disable","false");
            component.set("v.fileName", fileName);
        }
    },
    handleClick: function(component, event, helper) {
        component.set("v.Spinner", true); 
        if (component.find("fileId").get("v.files").length > 0) {
            
            var filename = component.find("fileId").get("v.files");
            var textdata;
            var reader = new FileReader();
            var infolst = [];
            reader.onload = function() {
                
                var text = reader.result; /*Get the data stored in file*/
                textdata = text;
                var rows = textdata.split('\n'); /*Spilt based on new line to get each row*/
                /* Ignore the first row (header)  and start from second*/
                console.log('rows.length-->' + rows.length);
                for (var i = 1; i < rows.length-1; i++) {
                    /*Spilt based on the comma*/
                    var cells = rows[i].split(',');
                     console.log('One row-->' + i);
                    //  var sports=cells[28].split('\r');
                    var cellinfo = {
                        'Id': cells[0],
                        'Fon_Cancelled_Reason__c':  cells[1],
                        'Fon_Staging_Status__c':  cells[2],
                    };
                    infolst.push(cellinfo);
                }
                component.set("v.data",infolst);
                console.log('jmd data--->'+infolst);
                component.set("v.Spinner", false); 
                
               /* var action = component.get("c.updateRecords");
                action.setParams({
                    msList: component.get("v.data"),
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        if(response.getReturnValue()){
                            helper.showToastMessage("success", "Success!", "The Membership has been updated successfully.");
                        }
                        else{
                            helper.showToastMessage("error", "error!", "Something went wrong. Please contact to your admin.");
                        }
                    }
                    else{
                        helper.showToastMessage("error", "error!", "Something went wrong. Please contact to your admin.");
                    }
                });
                $A.enqueueAction(action);*/
            };
            
            if (filename[0] !== undefined && filename[0] !== null && filename[0] !== '') {
                reader.readAsText(filename[0]);
            }
            else{
                alert('Please Select a Valid File');
            }
        } else {
            alert('Please Select a Valid File');
        }
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
})