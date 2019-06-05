({
    navigateNext : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/custompaymentmethod?returl=https://www.aafp.org/membership-application/application/thank-you%3Fmethod%3D"
        });
        urlEvent.fire();
    }
})