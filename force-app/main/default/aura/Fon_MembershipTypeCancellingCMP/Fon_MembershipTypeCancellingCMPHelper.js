({
    showToastMessage : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type,
            mode: 'dismissible',
            duration:'5000',
            title: title,
            message: message
        });
        toastEvent.fire();
    },
    cancelMembershipHelper : function(component, event, helper) {
		var action = component.get("c.cancellingMembership");
        action.setParams({
            recordId : component.get("v.contactId"),
            reason : component.get("v.reasonForCancelling")
        });
        action.setCallback(this,function(result){            
            if (result.getState() == 'SUCCESS') {
                var isContactUpdate = result.getReturnValue();
                this.showToastMessage("success", "Success!", "The Membership has been cancelled successfully.");
                this.newMembership(component, event, helper);
            }else {
                this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
            $A.get("e.force:closeQuickAction").fire();
        });
		$A.enqueueAction(action);
    },
    newMembership : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Fon_NewMembershipCmp",
            componentAttributes: {
                contactId : component.get("v.contactId")
            }
        });
        evt.fire();
    }
})