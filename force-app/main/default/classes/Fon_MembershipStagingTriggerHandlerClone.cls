public class Fon_MembershipStagingTriggerHandlerClone {
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
        for(OrderApi__Item__c eachItem : [SELECT Id,Name,OrderApi__Item_Class__r.Fon_Is_Main_Membership__c FROM OrderApi__Item__c WHERE Name IN:lstItemName]){
            mapItemNameToObjItem.put(eachItem.Name,eachItem);
        }
        Map<String,OrderApi__Subscription_Plan__c> mapNameToObjSubscriptionPlan = new Map<String,OrderApi__Subscription_Plan__c>();
        for(OrderApi__Subscription_Plan__c eachSubscription : [SELECT Id,Name FROM OrderApi__Subscription_Plan__c WHERE Name IN:subscriptionPlanSet ]){
            mapNameToObjSubscriptionPlan.put(eachSubscription.Name,eachSubscription);
        }
        Map<FDService.SalesOrder,FDService.SalesOrder> mapNewSOToInsertedSO = new Map<FDService.SalesOrder,FDService.SalesOrder>();
        Map<FDService.SalesOrder,List<FDService.SalesOrderLine>> mapSOTolstSOLI = new Map<FDService.SalesOrder,List<FDService.SalesOrderLine>>();
        for(Fon_Membership_Staging__c eachMemberStaging : lstApprovedMembershipStage){
            mapSOTolstSOLI.put(instanceSalesOrder(eachMemberStaging),
                                                    instanceOfALLSalesOrderLineItem(eachMemberStaging,mapItemNameToObjItem,mapMemberShipIdToSetItemName,mapNameToObjSubscriptionPlan));
            mapNewSOToInsertedSO.put(instanceSalesOrder(eachMemberStaging), instanceSalesOrder(eachMemberStaging));
        }
        insertingSalesOrderAndSOLI(mapSOTolstSOLI, mapNewSOToInsertedSO); //Implementing FD Service here
    }
    //Inserting Sales Order and Sales Order Line using FD Service
    public void insertingSalesOrderAndSOLI(Map<FDService.SalesOrder,List<FDService.SalesOrderLine>> mapSOTolstSOLI, Map<FDService.SalesOrder,FDService.SalesOrder> mapNewSOToInsertedSO){
        if(!mapSOTolstSOLI.keySet().isEmpty()){
            List<FDService.SalesOrder> lstNewSO = new List<FDService.SalesOrder>();
            lstNewSO.addALL(mapSOTolstSOLI.keySet());
           // insert mapNewSOToInsertedSO.values(); 
          //FDService.OrderService.getInstance().createOrder(lstNewSO);               //This line of code will be updated by FD Sevice
            List<FDService.SalesOrderLine> lstNewSOLI = new List<FDService.SalesOrderLine>();
            for(FDService.SalesOrder objSalesOrder : mapSOTolstSOLI.keySet()){
                if(mapSOTolstSOLI.get(objSalesOrder) != null){
                    for(FDService.SalesOrderLine eachSOLI : mapSOTolstSOLI.get(objSalesOrder)){
                        eachSOLI.salesOrder = mapNewSOToInsertedSO.get(objSalesOrder).Id;
                        lstNewSOLI.add(eachSOLI);
                    }
                }
            }
            //insert lstNewSOLI;              
            FDService.OrderService.getInstance().addItemsToOrder(lstNewSOLI); //FD Service Call
            //List<FDService.SalesOrder> lstCloseSO = new List<OrderApi__Sales_Order__c>(); Not in use
            //Close the Sales Order
            for(FDService.SalesOrder eachSO : mapNewSOToInsertedSO.values()){
                eachSO.status = 'Closed';
            }
            if(!mapNewSOToInsertedSO.values().isEmpty()){
                //update mapNewSOToInsertedSO.values();
            }
        }
    }
    //Instantiating Sales Order Here
    public FDService.SalesOrder instanceSalesOrder(Fon_Membership_Staging__c objMemberStage){
        //OrderApi__Sales_Order__c objSO = new OrderApi__Sales_Order__c();  
        //This line of code will be updated by FD Sevice
        FDService.SalesOrder objSO = new FDService.SalesOrder();
        objSO.contact = objMemberStage.Fon_Contact__c;
        //objSO.paymentMethod = objMemberStage.Fon_Payment_Method_Id__c;
        objSO.postingEntity = 'Receipt';
        if(!String.isBlank(objMemberStage.Fon_Payment_Method_Id__c)){
            //objSO.Fon_Process_Payment__c = true;
        }
        return objSO;
    }
    //Instantiating Sales Order Line Item Here
    public List<FDService.SalesOrderLine> instanceOfALLSalesOrderLineItem(Fon_Membership_Staging__c objMemberStage, 
                                                                    Map<String,OrderApi__Item__c> mapItemNameToObjItem, 
                                                                        Map<Id,Set<String>> mapMemberShipIdToSetItemName,
                                                                            Map<String,OrderApi__Subscription_Plan__c> mapNameToObjSubscriptionPlan){
        List<FDService.SalesOrderLine> lstSalesOrderLineItem = new List<FDService.SalesOrderLine>();
        FDService.SalesOrderLine nationalTypeSoli;
        for(String strItemName : mapMemberShipIdToSetItemName.get(objMemberStage.Id)){
            if(mapItemNameToObjItem.containsKey(strItemName)){
                FDService.SalesOrderLine objFDServiceSOLI = fetchSalesOrderLineItemFDService(mapItemNameToObjItem.get(strItemName), objMemberStage, mapNameToObjSubscriptionPlan);
                if(mapItemNameToObjItem.get(strItemName) != null && mapItemNameToObjItem.get(strItemName).OrderApi__Item_Class__r.Fon_Is_Main_Membership__c){
                    nationalTypeSoli = objFDServiceSOLI;
                }
                if(nationalTypeSoli != null && !mapItemNameToObjItem.get(strItemName).OrderApi__Item_Class__r.Fon_Is_Main_Membership__c){
                    objFDServiceSOLI.parentForeignKey = nationalTypeSoli.foreignKey;
                }
                //ADDING THE ITEM FOR  2018 - Active Membership, Year - Main Membership Type - Membership State/Chapter, Year - Main Membership Type - Membership State/Chapter - Membership Local
                lstSalesOrderLineItem.add(objFDServiceSOLI);
            }
        }
        for(OrderApi__Item__c eachItem : fetchFoundationItem()){
            FDService.SalesOrderLine objFDServiceSOLI = fetchSalesOrderLineItemFDService(eachItem, objMemberStage, mapNameToObjSubscriptionPlan);
            if(nationalTypeSoli != null && !eachItem.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c){
                objFDServiceSOLI.parentForeignKey = nationalTypeSoli.foreignKey;
            }
            //ADDING THE ITEM FOR PAC Contribution, Foundation Contribution
            lstSalesOrderLineItem.add(objFDServiceSOLI);
        }
        return lstSalesOrderLineItem;
    }
    //Instantiating Sales Order Line Item Here
    public FDService.SalesOrderLine fetchSalesOrderLineItemFDService(OrderApi__Item__c objItem, Fon_Membership_Staging__c objMemberStage, 
                                            Map<String,OrderApi__Subscription_Plan__c> mapNameToObjSubscriptionPlan){
        FDService.SalesOrderLine objLineItem = new FDService.SalesOrderLine();    //This line of code will be updated by FD Sevice
        objLineItem.item = objItem.Id;
        objLineItem.activationDate = objMemberStage.Fon_Membership_Activation_Date__c;
        objLineItem.autoCalculateActivationDate = false;
        objLineItem.subscriptionStartDate = objMemberStage.Fon_Join_Date__c;
        if(mapNameToObjSubscriptionPlan.containsKey(objMemberStage.Fon_Subscription_Plan__c)){
            objLineItem.subscriptionPlan = mapNameToObjSubscriptionPlan.get(objMemberStage.Fon_Subscription_Plan__c).Id;
        }
        if(objItem.Fon_Is_PAC_Item__c){
            objLineItem.priceOverride = true;
            objLineItem.salePrice = objMemberStage.Fon_PAC_Contribution_Information__c;
        }
        objLineItem.isSubscription = true;
        return objLineItem;
    }
    //Fetching foundation type item here
    public List<OrderApi__Item__c> fetchFoundationItem(){
        return [SELECT Id,Name,OrderApi__Item_Class__r.Fon_Is_Main_Membership__c FROM OrderApi__Item__c WHERE Is_Foundation_Donation__c = true OR Fon_Is_PAC_Item__c = true];
    }
    
}