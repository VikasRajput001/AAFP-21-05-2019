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
        }
})