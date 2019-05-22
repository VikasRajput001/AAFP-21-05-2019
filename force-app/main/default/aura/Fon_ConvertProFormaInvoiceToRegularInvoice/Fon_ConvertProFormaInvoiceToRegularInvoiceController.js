({
    testabc : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.convertProformaInvoice");
        action.setParams({
            salesOrderId: recordId
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
            var ReturnValue= response.getReturnValue();
                component.set("v.myMap",ReturnValue);
                var mp=component.get("v.myMap");
                var msg = mp['true'];
               
                if(msg){
                    //error
                     
                    console.log(msg);
                    component.set("v.showError",true);
                    component.set("v.msg",msg);
                    
                    
                }
                else{
                    //redirect url
                    console.log(msg);
                     helper.onSuccess(component, event, helper);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                          "url": "/lightning/r/OrderApi__Sales_Order__c/"+component.get("v.recordId")+"/view?0.source=alohaHeader"
                      //  "url": '/'+component.get("v.recordId")
                    });
                    urlEvent.fire();
                }
            }
           
        });            
        $A.enqueueAction(action);      
    },
    navigateBackToHomePage:function(component, event, helper) {
        component.get("v.showError",false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
              "url": "/lightning/r/OrderApi__Sales_Order__c/"+component.get("v.recordId")+"/view?0.source=alohaHeader"
          //  "url": '/'+component.get("v.recordId")
        });
        urlEvent.fire();
    },
    
    closeClick:function(component, event, helper) {
        component.get("v.showError",false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
              "url": "/lightning/r/OrderApi__Sales_Order__c/"+component.get("v.recordId")+"/view?0.source=alohaHeader"
            //"url": '/'+component.get("v.recordId")
        });
        urlEvent.fire();
    }
    
    
})