({
	init: function(cmp, event, helper) {
        
        console.log('FieldSetFormController.init');
        var sectionfieldSetName = cmp.get('v.sectionfieldSetName');
        var recordId = cmp.get('v.recordId');
        
        var getFormAction = cmp.get('c.getForm');

        getFormAction.setParams({
            "fieldSetName": sectionfieldSetName,
            "objectName": "Fon_Membership_Staging__c",
            "recordId": recordId
        });

        getFormAction.setCallback(this, function(response) {
            	var state = response.getState();
            	console.log('FieldSetFormController getFormAction callback');
            	console.log("callback state: " + state);
            
            	if (cmp.isValid() && state === "SUCCESS") {
	                var form = response.getReturnValue();
                    console.log("form: " , form);
	                cmp.set('v.sectionFields', form);
                    
                }
                
            }
        );
        $A.enqueueAction(getFormAction);
    },
    
   HideMe: function(component, event, helper) {
      //component.set("v.ShowModule", false);
      var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
       });
       urlEvent.fire();
   },
   ShowModuleBox: function(component, event, helper) {
      component.set("v.ShowModule", true);
   },
   savedSuccessfully: function(component, event, helper) {
       component.set("v.ShowModule",false);
       helper.onSuccess(component, event, helper);
       var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
       });
       urlEvent.fire();
   },
    pageError: function(component, event, helper) {
      alert('Please contact to your admin.');
   },
    handleOnSubmit: function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam("fields");
        fields["Fon_Contact__c"] = component.get("v.contactId");
        component.find('MemStag').submit(fields);
	}

})