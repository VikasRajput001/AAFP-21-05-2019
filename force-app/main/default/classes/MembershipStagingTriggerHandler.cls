public class MembershipStagingTriggerHandler{
    
    public void initializeMembershipStage(List<Fon_Membership_Staging__c> lstAllStaging){
        List<Fon_Membership_Staging__c> lstApprovedMembershipStage = new List<Fon_Membership_Staging__c>();
        for(Fon_Membership_Staging__c objStage : lstAllStaging){
            if(objStage.Fon_Staging_Status__c == 'Approved'){
                lstApprovedMembershipStage.add(objStage);    //Getting the approved membership staging record here
            }
        }
        if(!lstApprovedMembershipStage.isEmpty()){
            createSalesOrderByMemberStaging(lstApprovedMembershipStage);  //Batch process will be called from here
        }
    }
    
    //This method will be passed/used in batch
    public void createSalesOrderByMemberStaging(List<Fon_Membership_Staging__c> lstApprovedMembershipStage){
        List<OrderApi__Sales_Order__c> lstNewSalesOrder = new List<OrderApi__Sales_Order__c>();
        for(Fon_Membership_Staging__c eachMemberStaging : lstApprovedMembershipStage){
            lstNewSalesOrder.add(instanceSalesOrder(eachMemberStaging));
        }
        if(!lstNewSalesOrder.isEmpty()){
            insert lstNewSalesOrder;        //This line of code will be updated by FD Sevice
        }
    }
    
    //This method will be passed/used in batch
    public OrderApi__Sales_Order__c instanceSalesOrder(Fon_Membership_Staging__c objMemberStage){
        OrderApi__Sales_Order__c objSO = new OrderApi__Sales_Order__c();                            //This line of code will be updated by FD Sevice
        objSO.OrderApi__Payment_Method__c = objMemberStage.Fon_Payment_Method_Id__c;
        objSO.OrderApi__Posting_Entity__c = 'Receipt';
        if(!String.isBlank(objMemberStage.Fon_Payment_Method_Id__c)){
            objSO.Fon_Process_Payment__c = true;
        }
        return objSO;
    }
}