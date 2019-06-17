public class Fon_MembershipStagingTriggerHandler{
    /*
        @Description: Filtering "Membership Stage" records based on "Staging Status" = "Approved",
                        This is base function to perform further logic.
        @Author: RSI
    */
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
        List<Fon_Membership_Staging__c> lstErrorReasonMembershipStage = new List<Fon_Membership_Staging__c>();
        Map<Id,Set<String>> mapMemberShipIdToSetItemName = new Map<Id,Set<String>>();
        Set<Id> contactIdSet = new Set<Id>();
        Set<String> subscriptionPlanSet = new Set<String>();
        //Configuring base line data for further logic
        for(Fon_Membership_Staging__c eachMemberStaging : lstApprovedMembershipStage){
            contactIdSet.add(eachMemberStaging.Fon_Contact__c);
            Set<String> itemNameSet = new Set<String>();
            itemNameSet.add(''+eachMemberStaging.Fon_Year__c+' - '+eachMemberStaging.Fon_Membership_Type__c+' Membership');
            itemNameSet.add(''+eachMemberStaging.Fon_Year__c+' - '+'Main Membership Type - Membership State/Chapter');
            itemNameSet.add(''+eachMemberStaging.Fon_Year__c+' - '+'Main Membership Type - Membership State/Chapter - Membership Local');
            mapMemberShipIdToSetItemName.put(eachMemberStaging.Id,itemNameSet);
            subscriptionPlanSet.add(eachMemberStaging.Fon_Subscription_Plan__c);
            if(String.isBlank(eachMemberStaging.Fon_ContactID__c) && String.isBlank(eachMemberStaging.Fon_Membership_Type__c)){
                eachMemberStaging.Fon_Error_Reason__c = 'Need to ask about Error Reason';
                lstErrorReasonMembershipStage.add(eachMemberStaging);
            }
        }
        if(!lstErrorReasonMembershipStage.isEmpty()){
            update lstErrorReasonMembershipStage;   //This line of code will be updated by FD Sevice
        }
        Map<Id,Contact> mapKeyToObjContact = new Map<Id,Contact>([SELECT Id FROM Contact WHERE Id IN :contactIdSet]);
        List<String> lstItemName = new List<String>();
        for(Set<String> eachSetItem : mapMemberShipIdToSetItemName.values()){
            lstItemName.addAll(eachSetItem);
        }
        Map<String,OrderApi__Item__c> mapItemNameToObjItem = new Map<String,OrderApi__Item__c>();
        for(OrderApi__Item__c eachItem : [SELECT Id,Name FROM OrderApi__Item__c WHERE Name IN:lstItemName]){
            mapItemNameToObjItem.put(eachItem.Name,eachItem);
        }
        Map<String,OrderApi__Subscription_Plan__c> mapNameToObjSubscriptionPlan = new Map<String,OrderApi__Subscription_Plan__c>();
        for(OrderApi__Subscription_Plan__c eachSubscription : [SELECT Id,Name FROM OrderApi__Subscription_Plan__c WHERE Name IN:subscriptionPlanSet ]){
            mapNameToObjSubscriptionPlan.put(eachSubscription.Name,eachSubscription);
        }
        Map<OrderApi__Sales_Order__c,OrderApi__Sales_Order__c> mapNewSOToInsertedSO = new Map<OrderApi__Sales_Order__c,OrderApi__Sales_Order__c>();
        Map<OrderApi__Sales_Order__c,List<OrderApi__Sales_Order_Line__c>> mapSOTolstSOLI = new Map<OrderApi__Sales_Order__c,List<OrderApi__Sales_Order_Line__c>>();
        List<OrderApi__Sales_Order__c> lstNewSalesOrder = new List<OrderApi__Sales_Order__c>();
        for(Fon_Membership_Staging__c eachMemberStaging : lstApprovedMembershipStage){
            mapSOTolstSOLI.put(instanceSalesOrder(eachMemberStaging),
                                                    instanceOfALLSalesOrderLineItem(eachMemberStaging,mapItemNameToObjItem,mapMemberShipIdToSetItemName,mapNameToObjSubscriptionPlan));
            mapNewSOToInsertedSO.put(instanceSalesOrder(eachMemberStaging), instanceSalesOrder(eachMemberStaging));
        }
        if(!lstNewSalesOrder.isEmpty()){
            insert lstNewSalesOrder;        //This line of code will be updated by FD Sevice
        }
        if(!mapSOTolstSOLI.keySet().isEmpty()){
            List<OrderApi__Sales_Order__c> lstNewSO = new List<OrderApi__Sales_Order__c>();
            lstNewSO.addALL(mapSOTolstSOLI.keySet());
            insert mapNewSOToInsertedSO.values();                //This line of code will be updated by FD Sevice
            List<OrderApi__Sales_Order_Line__c> lstNewSOLI = new List<OrderApi__Sales_Order_Line__c>();
            for(OrderApi__Sales_Order__c objSalesOrder : mapSOTolstSOLI.keySet()){
                if(mapSOTolstSOLI.get(objSalesOrder) != null){
                    for(OrderApi__Sales_Order_Line__c eachSOLI : mapSOTolstSOLI.get(objSalesOrder)){
                        eachSOLI.OrderApi__Sales_Order__c = mapNewSOToInsertedSO.get(objSalesOrder).Id;
                        lstNewSOLI.add(eachSOLI);
                    }
                }
            }
            insert lstNewSOLI;              //This line of code will be updated by FD Sevice
        }
    }
    
    //Instantiating Sales Order Here
    public OrderApi__Sales_Order__c instanceSalesOrder(Fon_Membership_Staging__c objMemberStage){
        OrderApi__Sales_Order__c objSO = new OrderApi__Sales_Order__c();                            //This line of code will be updated by FD Sevice
        objSO.OrderApi__Contact__c = objMemberStage.Fon_Contact__c;
        objSO.OrderApi__Payment_Method__c = objMemberStage.Fon_Payment_Method_Id__c;
        objSO.OrderApi__Posting_Entity__c = 'Receipt';
        if(!String.isBlank(objMemberStage.Fon_Payment_Method_Id__c)){
            objSO.Fon_Process_Payment__c = true;
        }
        return objSO;
    }
    //Instantiating Sales Order Line Item Here
    public List<OrderApi__Sales_Order_Line__c> instanceOfALLSalesOrderLineItem(Fon_Membership_Staging__c objMemberStage, 
                                                                    Map<String,OrderApi__Item__c> mapItemNameToObjItem, 
                                                                        Map<Id,Set<String>> mapMemberShipIdToSetItemName,
                                                                            Map<String,OrderApi__Subscription_Plan__c> mapNameToObjSubscriptionPlan){
        List<OrderApi__Sales_Order_Line__c> lstSalesOrderLineItem = new List<OrderApi__Sales_Order_Line__c>();
        for(String strItemName : mapMemberShipIdToSetItemName.get(objMemberStage.Id)){
            if(mapItemNameToObjItem.containsKey(strItemName)){
                //ADDING THE ITEM FOR  2018 - Active Membership, Year - Main Membership Type - Membership State/Chapter, Year - Main Membership Type - Membership State/Chapter - Membership Local
                lstSalesOrderLineItem.add(fetchSalesOrderLineItemObj(mapItemNameToObjItem.get(strItemName), objMemberStage, mapNameToObjSubscriptionPlan));
            }
        }
        for(OrderApi__Item__c eachItem : fetchFoundationItem()){
            //ADDING THE ITEM FOR PAC Contribution, Foundation Contribution
            lstSalesOrderLineItem.add(fetchSalesOrderLineItemObj(eachItem, objMemberStage, mapNameToObjSubscriptionPlan));
        }
        return lstSalesOrderLineItem;
    }
    //Instantiating Sales Order Line Item Here
    public OrderApi__Sales_Order_Line__c fetchSalesOrderLineItemObj(OrderApi__Item__c objItem, Fon_Membership_Staging__c objMemberStage, 
                                            Map<String,OrderApi__Subscription_Plan__c> mapNameToObjSubscriptionPlan){
        OrderApi__Sales_Order_Line__c objLineItem = new OrderApi__Sales_Order_Line__c();    //This line of code will be updated by FD Sevice
        objLineItem.OrderApi__Item__c = objItem.Id;
        objLineItem.OrderApi__Activation_Date__c = objMemberStage.Fon_Membership_Activation_Date__c;
        objLineItem.OrderApi__Auto_Calculate_Activation_Date__c = false;
        objLineItem.OrderApi__Subscription_Start_Date__c = objMemberStage.Fon_Join_Date__c;
        if(mapNameToObjSubscriptionPlan.containsKey(objMemberStage.Fon_Subscription_Plan__c)){
            objLineItem.OrderApi__Subscription_Plan__c = mapNameToObjSubscriptionPlan.get(objMemberStage.Fon_Subscription_Plan__c).Id;
        }
        if(objItem.Fon_Is_PAC_Item__c){
            objLineItem.OrderApi__Price_Override__c = true;
            objLineItem.OrderApi__Sale_Price__c = objMemberStage.Fon_PAC_Contribution_Information__c;
        }
        objLineItem.OrderApi__Is_Subscription__c = true;
        return objLineItem;
    }
    
    public List<OrderApi__Item__c> fetchFoundationItem(){
        return [SELECT Id,Name FROM OrderApi__Item__c WHERE Is_Foundation_Donation__c = true OR Fon_Is_PAC_Item__c = true];
    }
    
}