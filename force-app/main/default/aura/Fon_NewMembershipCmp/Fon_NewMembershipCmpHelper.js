({
	helperMethod : function() {
		
	},
    onSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: 'success',
            mode: 'dismissible',
            duration:' 5000',
            title: "Success!",
            message: "The record has been saved successfully."
        });
        toastEvent.fire();
    }
})