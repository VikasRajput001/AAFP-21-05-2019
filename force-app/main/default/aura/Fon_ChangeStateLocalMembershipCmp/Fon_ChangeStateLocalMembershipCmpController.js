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
    
                }
            }
            else {
                helper.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
        });
        $A.enqueueAction(action);
        
        //component.find('membershipStateLocalForm').submit(fields);
        
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