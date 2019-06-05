({
    cancelMembershipHelper : function(component, event, helper) {
		var action = component.get("c.cancellingMembership");
        action.setParams({
            recordId : component.get("v.recordId"),
            reason : component.get("v.reasonForCancelling")
        });
        action.setCallback(this,function(result){            
            if (result.getState() == 'SUCCESS') {
                component.set("v.dynamicMsgMAP",result.getReturnValue());
                var resultMap = component.get("v.dynamicMsgMAP");
                var strMessage = resultMap['isEmptyMember'];
                if(strMessage != 'true'){
                    //Show success message
                	this.showToastMessage("success", "Success!", "The Membership has been cancelled successfully.");
                }else{
                    this.showToastMessage("warning", "Warning!", "No active membership is found.");
                }
            }
            else {
                this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        });
		$A.enqueueAction(action);
    },
    showToastMessage : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type,
            mode: 'dismissible',
            duration:'2000',
            title: title,
            message: message
        });
        toastEvent.fire();
    },
    fetchActiveMembership : function(component, event, helper) {
        var action = component.get("c.fetchingActiveMembership");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this,function(result){            
            if (result.getState() == 'SUCCESS') {
                var membershipId = result.getReturnValue();
                component.set("v.activeMembershipId",membershipId);
            }else {
                this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
            //$A.get("e.force:closeQuickAction").fire();
        });
		$A.enqueueAction(action);
    }
    
})