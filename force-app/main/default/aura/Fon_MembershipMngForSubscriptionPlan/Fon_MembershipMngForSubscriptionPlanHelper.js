({
    fetchAllSuscription : function(component, event, helper) {
        var action = component.get("c.fetchAllSuscriptionPlan");
        action.setParams({
            subscriptionId : component.get("v.objActiveSubscription").Id
        });
        action.setCallback(this,function(result){            
            if (result.getState() == 'SUCCESS') {
                var lstPlan = result.getReturnValue();
                component.set("v.lstSubscriptionPlan",lstPlan);
                component.set("v.isComponentLoading",false);
                
            }else {
                this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
            $A.get("e.force:closeQuickAction").fire();
            var serverStatusSpinner = component.find("serverStatusSpinner");
            $A.util.toggleClass(serverStatusSpinner, "slds-hide");
            
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
    changeSubscriptionPlan : function(component, event, helper) {
        var action = component.get("c.changePlan2");
        action.setParams({
            ContactId : component.get("v.contactId"),
            subPlanId : component.get("v.selectedSuscribePlanId")
        });
        action.setCallback(this,function(result){            
            if (result.getState() == 'SUCCESS') {
                this.showToastMessage("success", "SUCCESS!", "Subscription plan has been updated.");
                
            }else {
                this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
            }
            $A.get("e.force:closeQuickAction").fire();
            var serverStatusSpinner = component.find("serverStatusSpinner");
            $A.util.toggleClass(serverStatusSpinner, "slds-hide");
            component.set("v.isComponentLoading",false);
        });
		$A.enqueueAction(action);
    }
})