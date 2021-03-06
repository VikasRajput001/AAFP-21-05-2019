({
    init : function(component, event, helper) {
        helper.fetchActiveMembership(component, event, helper);
        helper.fetchActiveSubscription(component, event, helper);
    },
    newMembership : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Fon_NewMembershipCmp",
            componentAttributes: {
                contactId : component.get("v.recordId")
            }
        });
        evt.fire();
    },
    cancelConfirmMembership : function(component, event, helper) {
        var activeMembershipId = component.get("v.activeMembershipId");
        if(activeMembershipId == ''){
            helper.showToastMessage("warning", "Warning!", "No active membership exist.");
            return;
        }
        component.set("v.enableMainFrame",false);
        component.set("v.showCancelReasonModal",true);
    },
    
    closeCancelModalView : function(component, event, helper) {
        component.set("v.showCancelReasonModal",false); 
        component.set("v.enableMainFrame",true); 
    },
    closeModalView : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    changeTypeMembership : function(component, event, helper) {
        var activeMembershipId = component.get("v.activeMembershipId");
        if(activeMembershipId != ''){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Fon_MembershipTypeCancellingCMP",
                componentAttributes: {
                    contactId : component.get("v.recordId"),
                    activeMembershipId : component.get("v.activeMembershipId")
                }
            });
            evt.fire();
        }else{
            helper.showToastMessage("warning", "Warning!", "No active membership exist.");
        }
    },
    
    cancelMembershipButtonClick : function(component, event, helper) {
        var activeMembershipId = component.get("v.activeMembershipId");
        if(activeMembershipId == ''){
            helper.showToastMessage("warning", "Warning!", "No active membership exist.");
            return;
        }
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Fon_CancelMembershipCmp",
            componentAttributes: {
                contactId : component.get("v.recordId"),
                activeMembershipId : component.get("v.activeMembershipId")
            }
        });
        evt.fire();
        
        /*  var cancelingReason = component.get("v.reasonForCancelling");
       
        var serverStatusSpinner = component.find("serverStatusSpinner");
        $A.util.toggleClass(serverStatusSpinner, "slds-hide");
        var mainFrameDiv = component.find("mainFrameDiv");
        $A.util.addClass(mainFrameDiv, "slds-hide");
        helper.cancelMembershipHelper(component, event, helper)*/
    },
    
    changeState_LocalType : function(component, event, helper){
        var activeMembershipId = component.get("v.activeMembershipId");
        if(activeMembershipId != ''){
            var action = component.get("c.changeStateLocal");
            action.setParams({
                recordId : component.get("v.recordId"),
            });
            action.setCallback(this,function(result){
                if(result.getState() == 'SUCCESS'){
                    if(result.getReturnValue()){
                        var evt = $A.get("e.force:navigateToComponent");
                        evt.setParams({
                            componentDef : "c:Fon_ChangeStateLocalMembershipCmp",
                            componentAttributes: {
                                contactId : component.get("v.recordId"),
                                activeMembershipId : component.get("v.activeMembershipId")
                            }
                        });
                        evt.fire();
                    }
                    else{
                        helper.showToastMessage("warning", "Warning!", "Contact's chapter change needed is not set.");
                        return;
                    }
                }
                else {
                    this.showToastMessage("error", "Error!", "Something went wrong. Please contact to your admin.");
                }
            });
            $A.enqueueAction(action);
        }
        else{
            helper.showToastMessage("warning", "Warning!", "No active membership exist.");
        }
    },
    changeSubscriptionPlan : function(component, event, helper) {
        var activeMembershipId = component.get("v.activeMembershipId");
        if(activeMembershipId != '' && activeMembershipId != undefined){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Fon_MembershipMngForSubscriptionPlan",
                componentAttributes: {
                    contactId : component.get("v.recordId"),
                    activeMembershipId : component.get("v.activeMembershipId"),
                    objActiveSubscription : component.get("v.objActiveSubscription")
                }
            });
            evt.fire();
        }else{
            helper.showToastMessage("warning", "Warning!", "No active membership exist.");
        }
    }
})