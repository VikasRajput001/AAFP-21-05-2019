({
    closeModal : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
        });
        urlEvent.fire();
    },
    recordSubmitted : function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        var action = component.get("c.updateRecords");     
        action.setParams({
            contactId : component.get("v.contactId"),
            activeMembershipId : component.get("v.activeMembershipId"),
            State : fields["Fon_Membership_State_Chapter__c"],
            Local : fields["Fon_Membership_Local__c"]
        });
        action.setCallback(this,function(result){
            if(result.getState() == 'SUCCESS'){
                if(result.getReturnValue()){
                    component.find('membershipStateLocalForm').submit(fields);
                }
                else{
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
                    });
                    urlEvent.fire();
                }
            }
            else {
                helper.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
        });
        $A.enqueueAction(action);
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
    actionOnSuccess : function(component, event, helper){
        helper.showToastMessage("success", "Success!", "The Membership State/Local has been changed successfully.");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
        });
        urlEvent.fire();
    }
})