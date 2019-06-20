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
    handleClick : function(component, event, helper) {
        //component.set("v.Spinner", true); 
        if (component.find("fileId").get("v.files").length > 0) {
            
            var filename = component.find("fileId").get("v.files");
            var textdata;
            var reader = new FileReader();
            var infolst = [];
            var isExtraCommafound = false;
            reader.onload = function() {
                var text = reader.result; 
                textdata = text;
                var rows = textdata.split('\n'); 
                helper.addingColumnNameToKey(component, event, helper, rows);                
                var keyToColumnName = component.get("v.mapKeyToColumnName");
                
                try{
                    var baseRowCells = rows[0].split(',');
                    for (var i = 1; i < rows.length; i++) {
                        if(rows[i].split(',').length > 1 && baseRowCells.length != rows[i].split(',').length){
                            alert("Row No: "+i+" CSV file contains extra comma in its data. Please contact to administrator or remove extra comma from csv file.");
                        	component.set("v.Spinner", false); 
                            isExtraCommafound = true;
                        }
                    }
                    
                    for (var i = 1; i < rows.length; i++) {
                        var columns = rows[i].split(',');
                        helper.fetchMemberShipStageInstance(component, event, helper);
                        var objMembershipStage = component.get("v.objMembershipStage"); 
                        for(var j = 0; j < columns.length; j++){
                            //alert(columns[j]);
                            if(keyToColumnName[j].trim().toLowerCase() == 'Id'.toLowerCase()){
                                 objMembershipStage.Id = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Name'.toLowerCase()){
                                objMembershipStage.Name = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Contact__c'.toLowerCase()){
                                objMembershipStage.Fon_Contact__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Cancelled_Reason__c'.toLowerCase()){
                                objMembershipStage.Fon_Cancelled_Reason__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Chapter_Id__c'.toLowerCase()){
                                objMembershipStage.Fon_Chapter_Id__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Chapter_Join_Date__c'.toLowerCase()){
                                var CurDate = "14-05-2019";
                                objMembershipStage.Fon_Chapter_Join_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_ContactID__c'.toLowerCase()){
                                objMembershipStage.Fon_ContactID__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Dues_Paid_by_Chapter__c'.toLowerCase()){
                                objMembershipStage.Fon_Dues_Paid_by_Chapter__c = 45454545; //columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Dues_Paid_by_Residency_Program__c'.toLowerCase()){
                                objMembershipStage.Fon_Dues_Paid_by_Residency_Program__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Dues_Waived__c'.toLowerCase() && columns[j] != ''){
                                objMembershipStage.Fon_Dues_Waived__c = JSON.parse(columns[j].toLowerCase());
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Error_Reason__c'.toLowerCase()){
                                objMembershipStage.Fon_Error_Reason__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Expiration_Date__c'.toLowerCase()){
                                objMembershipStage.Fon_Expiration_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Extended_Training_Date__c'.toLowerCase()){
                                objMembershipStage.Fon_Extended_Training_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Foundation_Contribution_Information__c'.toLowerCase()){
                                objMembershipStage.Fon_Foundation_Contribution_Information__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Join_Date__c'.toLowerCase()){
                                objMembershipStage.Fon_Join_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Life_Approved_Flag__c'.toLowerCase() && columns[j] != ''){
                                objMembershipStage.Fon_Life_Approved_Flag__c = JSON.parse(columns[j].toLowerCase());
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Main_Membership__c'.toLowerCase()){
                                objMembershipStage.Fon_Main_Membership__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Medical_School_Graduation_Date__c'.toLowerCase()){
                                objMembershipStage.Fon_Medical_School_Graduation_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Membership_Activation_Date__c'.toLowerCase()){
                                objMembershipStage.Fon_Membership_Activation_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Membership_Local__c'.toLowerCase()){
                                objMembershipStage.Fon_Membership_Local__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Membership_State__c'.toLowerCase()){
                                objMembershipStage.Fon_Membership_State__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Membership_Type__c'.toLowerCase()){
                                objMembershipStage.Fon_Membership_Type__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Other_Price_Override__c'.toLowerCase()){
                                objMembershipStage.Fon_Other_Price_Override__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_PAC_Contribution_Account_Type__c'.toLowerCase()){
                                objMembershipStage.Fon_PAC_Contribution_Account_Type__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_PAC_Contribution_Employer__c'.toLowerCase()){
                                objMembershipStage.Fon_PAC_Contribution_Employer__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_PAC_Contribution_Information__c'.toLowerCase()){
                                objMembershipStage.Fon_PAC_Contribution_Information__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_PAC_Contribution_Occupation__c'.toLowerCase()){
                                objMembershipStage.Fon_PAC_Contribution_Occupation__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Payment_Method_Id__c'.toLowerCase()){
                                objMembershipStage.Fon_Payment_Method_Id__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Residency_Program_Graduation_Date__c'.toLowerCase()){
                                objMembershipStage.Fon_Residency_Program_Graduation_Date__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Residency_Training_Status__c'.toLowerCase()){
                                objMembershipStage.Fon_Residency_Training_Status__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Staging_Status__c'.toLowerCase()){
                                objMembershipStage.Fon_Staging_Status__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Subscription_Plan__c'.toLowerCase()){
                                objMembershipStage.Fon_Subscription_Plan__c = columns[j];
                            }
                            if(keyToColumnName[j].trim().toLowerCase() == 'Fon_Year__c'.toLowerCase()){
                                objMembershipStage.Fon_Year__c = columns[j];
                            }
                        }
                        //alert(objMembershipStage.ID);break;
                        infolst.push(objMembershipStage);
                    }
                }catch(e){
                    alert('EXCEPTION='+e);
                }
                component.set("v.data",infolst);
                //alert(isExtraCommafound);
                if(isExtraCommafound){
                    //alert(isExtraCommafound);
                    return;
                }else{
                    //alert(isExtraCommafound);
                    //helper.processCSVFile(component, event, helper); 
                }
                helper.csvFileUploader(component, event, helper, text); 
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
    
    onCheckedBox: function(component, event, helper) {
        alert('onCheckedBox');
    }
})