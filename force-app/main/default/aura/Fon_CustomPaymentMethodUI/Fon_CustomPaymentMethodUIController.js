({
	doInit : function(cmp, event, helper) {
		helper.loadData(cmp, event, helper);
        var urlString = window.location.href;
		var res = urlString.split("returl=");
		cmp.set('v.returnURL', res[1]);
	},
    closeModel: function(cmp, event, helper) {
       // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
       cmp.set("v.isOpen", false);
    },
    handleClick: function (cmp, event, helper) {
        var action = cmp.get('c.getPaymentMethod');
        action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.pmID', response.getReturnValue());
                    helper.reloadLocation(cmp, event, helper);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                    cmp.set("v.isOpen", true);
                }
        }));
        $A.enqueueAction(action); 
    }
    
})