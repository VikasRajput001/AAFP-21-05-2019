({
    navigateNext : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Fon_NewMembershipCmp",
            componentAttributes: {
                contactId : component.get("v.recordId")
            }
        });
        evt.fire();
    },
    cancelMembership : function(component, event, helper) {
        var serverStatusSpinner = component.find("serverStatusSpinner");
        $A.util.toggleClass(serverStatusSpinner, "slds-hide");
        var mainFrameDiv = component.find("mainFrameDiv");
        $A.util.addClass(mainFrameDiv, "slds-hide");
        helper.cancelMembershipHelper(component, event, helper)
    }
})