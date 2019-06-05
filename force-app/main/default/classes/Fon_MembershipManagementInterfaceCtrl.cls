/*
    @Description:  Managing membership related action such as Cancelled Membership, Chnage Member Type and Change State etc.
    @Author: RSI
*/
public with sharing class Fon_MembershipManagementInterfaceCtrl{
    //final static Boolean strInvoiceStatus = true;
    final static String strActive = 'Active';
    final static String strInactive = 'Inactive';
    final static String strPostedEntity = 'Invoice';
    //final static String strPostingStatus = 'Posted';
    final static String strCancelled = 'Cancelled';
    final static List<String> lstDraftInvoice = new List<String>{'Draft','Posted'};
    final static Boolean isVoid = false;
    public static Map<String,String> mapKeyToMSG = new Map<String,String>();
    /*
        @Description: This function will be used to cancell membership staging
        @Lightning Component: Fon_MembershipManagementInterface
    */
    @AuraEnabled
    public static Map<String,String> cancellingMembership(String recordId, String reason){
        List<Fon_Membership_Staging__c> lstMember = [SELECT Id,Fon_Staging_Status__c,Fon_Cancelled_Reason__c FROM Fon_Membership_Staging__c 
                                                        WHERE Fon_Staging_Status__c =:strActive AND Fon_Contact__c =:recordId];
        for(Fon_Membership_Staging__c eachMember : lstMember){
            eachMember.Fon_Staging_Status__c = strInactive;
            //eachMember.Fon_Cancelled_Reason__c = reason;
        }
        if(!lstMember.isEmpty()){
            update lstMember;
            update new Contact(id=recordId,Fon_Current_Membership_Status__c=strInactive);
            updateSubsAndSalesOrder(recordId, reason); //Updating invoice
        }else{
            mapKeyToMSG.put('isEmptyMember','true');
        }
        return mapKeyToMSG;
    }
    /*
        @Description: Updating invoices status. It is a helper function for @cancellingMembership.
        @Param: Id contactId => Passing the id of the contact.
        @Author: RSI
    */
    public static void updateSubsAndSalesOrder(Id contactId, String reason){
        Set<Id> salesOrderIdSet = new Set<Id>();
        List<OrderApi__Subscription__c> lstSubscription = [SELECT Id,OrderApi__Status__c,OrderApi__Cancelled_Reason__c,OrderApi__Sales_Order_Line__c,
                                                            OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c,
                                                            OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c FROM OrderApi__Subscription__c 
                                                                WHERE OrderApi__Contact__c =: contactId AND OrderApi__Status__c =:strActive AND 
                                                                    OrderApi__Subscription_Plan__c != null AND OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c =:true];
        for(OrderApi__Subscription__c eachSubscription : lstSubscription){
            eachSubscription.OrderApi__Status__c = strCancelled;
            eachSubscription.OrderApi__Cancelled_Reason__c = reason;
            if(eachSubscription.OrderApi__Sales_Order_Line__c != null){
                salesOrderIdSet.add(eachSubscription.OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c);
            }
        }
        if(!lstSubscription.isEmpty()){
            update lstSubscription;
        }
        List<OrderApi__Invoice__c> lstInvoice = new List<OrderApi__Invoice__c>();
        List<OrderApi__Sales_Order__c> lstSO = [SELECT Id,(SELECT Id,OrderApi__Is_Voided__c,OrderApi__Is_Posted__c,OrderApi__Is_Cancelled__c, 
                                                    OrderApi__Is_Paid__c FROM OrderApi__Invoices__r WHERE OrderApi__Status__c IN :lstDraftInvoice) 
                                                        FROM OrderApi__Sales_Order__c WHERE Id IN :salesOrderIdSet AND OrderApi__Posting_Entity__c =:strPostedEntity ];
                                                            //AND OrderApi__Posting_Status__c =:strPostingStatus
        for(OrderApi__Sales_Order__c eachSO : lstSO){
            for(OrderApi__Invoice__c eachInvoice : eachSO.OrderApi__Invoices__r){
                if(eachInvoice.OrderApi__Is_Posted__c){
                    eachInvoice.OrderApi__Is_Voided__c = true;
                }else if(!eachInvoice.OrderApi__Is_Posted__c && !eachInvoice.OrderApi__Is_Paid__c){
                    eachInvoice.OrderApi__Is_Cancelled__c = true;
                }
                lstInvoice.add(eachInvoice);
            }
        }
        if(!lstInvoice.isEmpty()){
            update lstInvoice;
        }
    }
    /*
        @Description: Fetching active Membership record id
        @Param: String recordId => Passing the id of the contact.
        @Return: Active membership record id.
        @Author: RSI
    */
    @AuraEnabled
    public static String fetchingActiveMembership(String recordId){
        String membershipRecordId = '';
        List<Fon_Membership_Staging__c> lstMemberShipStage = [SELECT Id FROM Fon_Membership_Staging__c WHERE Fon_Contact__c =:recordId AND Fon_Staging_Status__c =:strActive];
        for(Fon_Membership_Staging__c eachMember : lstMemberShipStage){
            membershipRecordId = eachMember.Id;
            break;
        }
        return membershipRecordId;
    }
    /*
        @Description: Fetching active Membership record id
        @Param: String recordId => Passing the id of the contact.
        @Return: Active membership record id.
        @Author: RSI
    
    @AuraEnabled
    public static String updateContactByMembership(String recordId){
        if(!String.isBlank(recordId)){
            update new Contact(id=recordId,Fon_Current_Membership_Status__c=strInactive);
            return 'true';
        }
        return 'false';
    }
    */
    
    @AuraEnabled
    public static Boolean changeStateLocal(String recordId){
        List<Contact> conList=[select id from Contact Where id=:recordId And Fon_Chapter_Change_Needed__c=true];
        if(conList.size()>0){
            return true;
        }
        else{
            return false;
        }  
    }
    
    @AuraEnabled
    public static void updateRecords(String contactId,String activeMembershipId,String State,String Local){
        System.debug('jmd contactId-->'+contactId);
        System.debug('jmd activeMembershipId-->'+activeMembershipId);
        System.debug('jmd State-->'+State);
        System.debug('jmd Local-->'+Local);
       
        List<OrderApi__Item__c> stateItem = new List<OrderApi__Item__c>();
        List<OrderApi__Item__c> localItem = new List<OrderApi__Item__c>();
        if(String.isNotBlank(State)){
            
        }
        if(String.isNotBlank(Local)){
            
        }
        Set<Id> itemIds = new Set<Id>();
        if(String.isNotBlank(State) && String.isNotBlank(Local)){
            List<OrderApi__Subscription__c> subscriptions = [select id from OrderApi__Subscription__c 
                                                             where OrderApi__Contact__c=:contactId 
                                                             And OrderApi__Is_Active__c=true  
                                                             And OrderApi__Item__r.OrderApi__Is_Active__c=true 
                                                             And OrderApi__Item__r.OrderApi__Item_Class__r.OrderApi__Is_Active__c=true
                                                             And OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c=true];
            if(subscriptions.size()>0){
                List<OrderApi__Subscription_Line__c> subscriptionLines = [select OrderApi__Item__c from OrderApi__Subscription_Line__c where OrderApi__Subscription__c=:subscriptions[0].id And OrderApi__Item__c!=Null];
                if(subscriptionLines.size()>0){
                    for(OrderApi__Subscription_Line__c SL:subscriptionLines){
                       itemIds.add(SL.OrderApi__Item__c);
                    }    
                }
            }
        }
        else{
            
        }
    }
}