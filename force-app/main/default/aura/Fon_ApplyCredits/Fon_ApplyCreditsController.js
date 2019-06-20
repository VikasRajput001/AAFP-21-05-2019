({
	init : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var recordId = component.get("v.recordId");
       // var action = component.get("c.convertProformaInvoice");
        action.setParams({
            
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.showSpinner",false);    
                var ReturnValue= response.getReturnValue();
               // component.set("v.myMap",ReturnValue);
               // var mp=component.get("v.myMap");
                //var msg = mp['true'];
                

            }else if(state == "ERROR"){
                 alert('error');
            }
        });  
        
        $A.enqueueAction(action); 
        
    },
    closeClick:function(component, event, helper) {
        component.get("v.showError",false);
        helper.navigateBackToHomePage(component, event, helper);
    }
    
})