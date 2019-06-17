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
        var reasonForCancelling = component.find("reasonForCancelling");
        var reasonForCancellingValue = reasonForCancelling.get("v.value"); 
        var fields = event.getParam('fields');
        var conId= component.get("v.contactId");
        var action = component.get("c.cancelMembership");
        action.setParams({
            recordId : conId,
            reason : reasonForCancellingValue,
            isRevertFinancial: component.get("v.isRevertFinancial")
        });
        action.setCallback(this,function(result){            
            if (result.getState() == 'SUCCESS') {
                component.set("v.dynamicMsgMAP",result.getReturnValue());
                var resultMap = component.get("v.dynamicMsgMAP");
                var strMessage = resultMap['isEmptyMember'];
                if(strMessage != 'true'){
                    component.find('membershipCanselForm').submit(fields);
                }else{
                    this.showToastMessage("warning", "Warning!", "No active membership is found.");
                }
            }
            else {
                this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
        });
        $A.enqueueAction(action);
    },
})