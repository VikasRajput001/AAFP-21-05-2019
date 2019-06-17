({
    closeModal : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
        });
        urlEvent.fire();
    },
    recordSubmitted : function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam("fields");
        fields["Fon_Staging_Status__c"] = 'Inactive';
        component.set("v.ShowModule",false); 
        helper.continuetoCancel(component, event, helper);
    },
    actionOnSuccess : function(component, event, helper) {
        component.set("v.ShowModule",false); 
        helper.cancelMembershipHelper(component, event, helper)
    },
    continueToSubmit : function(component, event, helper) {
        component.find('membershipStageId').submit(fields);
        
    },
    closeCancelModalView : function(component, event, helper) {
        component.set("v.showCancelReasonModal",false); 
        component.set("v.ShowModule",true); 
    },
    closeModalView : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})