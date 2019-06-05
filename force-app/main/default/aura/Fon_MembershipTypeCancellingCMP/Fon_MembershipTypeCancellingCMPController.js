({
    closeModal : function(component, event, helper) {
      var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": "/lightning/r/Contact/"+component.get("v.contactId")+"/view?0.source=alohaHeader"
       });
       urlEvent.fire();
   },
   recordSubmitted : function(component, event, helper) {
      	event.preventDefault();
        var fields = event.getParam("fields");
        fields["Fon_Staging_Status__c"] = 'Inactive';
        component.set("v.showCancelReasonModal",true); 
        component.set("v.ShowModule",false); 
   },
   actionOnSuccess : function(component, event, helper) {
       component.set("v.ShowModule",false); 
       helper.cancelMembershipHelper(component, event, helper)
   },
   continueToSubmit : function(component, event, helper) {
        component.find('membershipStageId').submit(fields);
       
   },
   continuetoCancel : function(component, event, helper) {
       var reasonForCancelling = component.get("v.reasonForCancelling");
       if(reasonForCancelling == '' || reasonForCancelling === undefined){
           helper.showToastMessage("warning", "Warning!", "Please add reason for Cancelling  .");
            return;
       }
       component.set("v.showCancelReasonModal",false); 
       var serverStatusSpinner = component.find("serverStatusSpinner");
       $A.util.toggleClass(serverStatusSpinner, "slds-hide");
       helper.cancelMembershipHelper(component, event, helper)
   },
   closeCancelModalView : function(component, event, helper) {
        component.set("v.showCancelReasonModal",false); 
        component.set("v.ShowModule",true); 
   },
   closeModalView : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
   }
})