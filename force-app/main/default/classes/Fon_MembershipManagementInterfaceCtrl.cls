/*
@Description:  Managing membership related action such as Cancelled Membership, Chnage Member Type and Change State etc.
@Author: RSI
*/
public with sharing class Fon_MembershipManagementInterfaceCtrl{
    Static String membershipStateChapter;
    Static String membershipLocal;
    
    //final static Boolean strInvoiceStatus = true;
    final static String strActive = 'Active';
    final static String strInactive = 'Inactive';
    final static String strPostedEntity = 'Invoice';
    //final static String strPostingStatus = 'Posted';
    final static String strCancelled = 'Cancelled';
    final static String strExpired = 'Expired';
    final static List<String> lstDraftInvoice = new List<String>{'Draft','Posted'};
        final static Boolean isVoid = false;
    public static Map<String,String> mapKeyToMSG = new Map<String,String>();
    /*
@Description: This function will be used to cancell membership staging
@Lightning Component: Fon_MembershipManagementInterface
*/
    @AuraEnabled
    public static Map<String,String> cancellingMembership(String recordId, String reason, String source){
        List<Fon_Membership_Staging__c> lstMember = [SELECT Id,Fon_Staging_Status__c,Fon_Cancelled_Reason__c FROM Fon_Membership_Staging__c 
                                                     WHERE Fon_Staging_Status__c =:strActive AND Fon_Contact__c =:recordId];
        for(Fon_Membership_Staging__c eachMember : lstMember){
            eachMember.Fon_Staging_Status__c = strInactive;
            //eachMember.Fon_Cancelled_Reason__c = reason;
        }
        if(!lstMember.isEmpty()){
            update lstMember;
            update new Contact(id=recordId,Fon_Current_Membership_Status__c=strInactive);
            updateSubsAndSalesOrder(recordId, reason, source); //Updating invoice
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
    public static void updateSubsAndSalesOrder(Id contactId, String reason, String source){
        Set<Id> salesOrderIdSet = new Set<Id>();
        List<OrderApi__Subscription__c> lstSubscription = [SELECT Id,OrderApi__Status__c,OrderApi__Cancelled_Reason__c,OrderApi__Sales_Order_Line__c,
                                                           OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c,
                                                           OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c FROM OrderApi__Subscription__c 
                                                           WHERE OrderApi__Contact__c =:contactId AND OrderApi__Status__c =:strActive AND 
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
            for(OrderApi__Subscription__c eachSubscribe : lstSubscription){
                if('membershiptype'.equals(source)){ //Changing Membership type
                    eachSubscribe.OrderApi__Status__c = strExpired;
                }
            }
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
@Description: Fetching active subscription id
@Param: String recordId => Passing the id of the contact.
@Return: Active subscription record id.
@Author: RSI
*/
    @AuraEnabled
    public static OrderApi__Subscription__c fetchingActiveSubscription(String recordId){
        OrderApi__Subscription__c subscriptionRecId;
        List<OrderApi__Subscription__c > lstSubscription = [SELECT Id,OrderApi__Subscription_Plan__c FROM OrderApi__Subscription__c WHERE OrderApi__Contact__c=:recordId AND OrderApi__Status__c =:strActive AND Fon_Is_Main_Membership__c =:true];
        for(OrderApi__Subscription__c  eachSubscribe : lstSubscription){
            subscriptionRecId = eachSubscribe;
            break;
        }
        return subscriptionRecId;
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
    public static Boolean updateRecords(String contactId,String activeMembershipId,String State,String Local){
        Set<Id> itemIds = new Set<Id>();
        Set<Id> soIds = new Set<Id>();
        Map<Id,Id> subscriptionVsItem = new Map<Id,Id>();
        Map<Id,Id> ItemVsSubscription = new Map<Id,Id>();
        List<OrderApi__Item__c> stateItem = new List<OrderApi__Item__c>();
        List<OrderApi__Item__c> localItem = new List<OrderApi__Item__c>();
        List<OrderApi__Badge__c> updateBadgeList = new List<OrderApi__Badge__c>();
        List<OrderApi__Subscription_Line__c> updateSubscriptionLine = new List<OrderApi__Subscription_Line__c>();
        String temp;
        if(String.isNotBlank(State)){
            temp='Active Membership - '+State+'%';
            stateItem = [select id from OrderApi__Item__c where Name LIKE:temp];
        }
        if(String.isNotBlank(Local)){          
            temp='Active Membership - '+Local+'%';
            localItem = [select id from OrderApi__Item__c where Name LIKE:temp];
        }
        else{
            Local='--None--'; 
        }
        Map<Id,Id> stVSbadgeType = new Map<Id,Id>();
        Map<Id,Id> stVSbadgeWorkflow = new Map<Id,Id>();
        if(stateItem.size()>0){
            List<OrderApi__Badge_Workflow__c> stateBadge=[select id,OrderApi__Badge_Type__c from OrderApi__Badge_Workflow__c where OrderApi__Item__c=:stateItem[0].Id];
            if(stateBadge.size()>0){
                stVSbadgeType.put(stateItem[0].Id,stateBadge[0].OrderApi__Badge_Type__c);
                stVSbadgeWorkflow.put(stateItem[0].Id,stateBadge[0].Id);
            }
        }
        if(localItem.size()>0){
            List<OrderApi__Badge_Workflow__c> localBadge=[select id,OrderApi__Badge_Type__c from OrderApi__Badge_Workflow__c where OrderApi__Item__c=:localItem[0].Id];
            if(localBadge.size()>0){
                stVSbadgeType.put(localItem[0].Id,localBadge[0].OrderApi__Badge_Type__c);
                stVSbadgeWorkflow.put(localItem[0].Id,localBadge[0].Id);
            }
        }
        List<Fon_Membership_Staging__c> lstMemberShipStage = [SELECT Fon_Membership_State__c,Fon_Membership_Local__c FROM Fon_Membership_Staging__c WHERE id =:activeMembershipId AND Fon_Staging_Status__c ='Active' Limit 1];
        if(lstMemberShipStage.size()>0){
            if(State!=lstMemberShipStage[0].Fon_Membership_State__c || Local!=lstMemberShipStage[0].Fon_Membership_Local__c){
                if(stateItem.size()>0 || localItem.size()>0){
                    List<OrderApi__Subscription__c> subscriptions = [select id from OrderApi__Subscription__c 
                                                                     where OrderApi__Contact__c=:contactId 
                                                                     And OrderApi__Is_Active__c=true  
                                                                     And OrderApi__Item__r.OrderApi__Is_Active__c=true 
                                                                     And OrderApi__Item__r.OrderApi__Item_Class__r.OrderApi__Is_Active__c=true
                                                                     And OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c=true];
                    if(subscriptions.size()>0){
                        List<OrderApi__Subscription_Line__c> subscriptionLines = [select OrderApi__Item__c,OrderApi__Sales_Order_Line__c from OrderApi__Subscription_Line__c where OrderApi__Subscription__c=:subscriptions[0].id And OrderApi__Item__c!=Null];
                        if(subscriptionLines.size()>0){
                            for(OrderApi__Subscription_Line__c SL:subscriptionLines){
                                itemIds.add(SL.OrderApi__Item__c);
                                soIds.add(SL.OrderApi__Sales_Order_Line__c);
                                ItemVsSubscription.put(SL.OrderApi__Item__c,SL.Id);
                            }    
                        }
                        if(!itemIds.isEmpty()){
                            List<OrderApi__Item__c> itmList=[select OrderApi__Item_Class__r.Fon_Is_State_Membership__c,OrderApi__Item_Class__r.Fon_Is_Local_Membership__c from OrderApi__Item__c where OrderApi__Is_Active__c=true And id in :itemIds And (OrderApi__Item_Class__r.Fon_Is_State_Membership__c=true OR OrderApi__Item_Class__r.Fon_Is_Local_Membership__c=true)];
                            if(itmList.size()>0){
                                for(OrderApi__Item__c itm:itmList){
                                    for(OrderApi__Subscription_Line__c SL:subscriptionLines){
                                        if(itm.Id==SL.OrderApi__Item__c){
                                            if(itm.OrderApi__Item_Class__r.Fon_Is_State_Membership__c){
                                                SL.OrderApi__Item__c=stateItem[0].Id;
                                                subscriptionVsItem.put(SL.Id,stateItem[0].Id);
                                                updateSubscriptionLine.add(SL);
                                            }
                                            else if(itm.OrderApi__Item_Class__r.Fon_Is_Local_Membership__c){
                                                SL.OrderApi__Item__c=localItem[0].Id;
                                                subscriptionVsItem.put(SL.Id,localItem[0].Id);
                                                updateSubscriptionLine.add(SL);
                                            }
                                        }
                                    }  
                                }
                            }
                        }
                        if(!soIds.isEmpty()){
                            List<OrderApi__Badge__c> badgeList=[select OrderApi__Item__c from OrderApi__Badge__c where OrderApi__Is_Active__c=true And OrderApi__Sales_Order_Line__c in:soIds];
                            if(badgeList.size()>0){
                                for(OrderApi__Badge__c bdg:badgeList){
                                    if(!subscriptionVsItem.isEmpty()){                                       
                                        system.debug('jmd--stVSbadgeType--'+stVSbadgeType);
                                        system.debug('jmd--stVSbadgeWorkflow--'+stVSbadgeWorkflow);
                                        system.debug('jmd--subscriptionVsItem--'+subscriptionVsItem);
                                        system.debug('jmd--ItemVsSubscription--'+ItemVsSubscription);
                                        system.debug('jmd--bdg.OrderApi__Item__c--'+bdg.OrderApi__Item__c);
                                        system.debug('jmd123----'+subscriptionVsItem.get(ItemVsSubscription.get(bdg.OrderApi__Item__c)));
                                        
                                        bdg.OrderApi__Badge_Type__c=stVSbadgeType.get(subscriptionVsItem.get(ItemVsSubscription.get(bdg.OrderApi__Item__c)));
                                        bdg.OrderApi__Badge_Workflow__c=stVSbadgeWorkflow.get(subscriptionVsItem.get(ItemVsSubscription.get(bdg.OrderApi__Item__c)));
                                        bdg.OrderApi__Item__c=subscriptionVsItem.get(ItemVsSubscription.get(bdg.OrderApi__Item__c)); 
                                        
                                        updateBadgeList.add(bdg);
                                    }
                                }
                            }
                        }
                    }
                    List<Contact> conList=[select Fon_Chapter_Change_Needed__c,Fon_Membership_State__c,Fon_Membership_Local__c from Contact where id=:contactId];          
                    
                    system.debug('jmd updateSubscriptionLine--'+updateSubscriptionLine);
                    
                    if(updateSubscriptionLine.size()>0){
                        update updateSubscriptionLine; 
                        if(updateBadgeList.size()>0){
                            update updateBadgeList;
                        }
                        conList[0].Fon_Chapter_Change_Needed__c=false;
                        conList[0].Fon_Membership_State__c=State;
                        conList[0].Fon_Membership_Local__c=Local;
                        update conList;
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    /*
@Description: When we click Cancel membership button Management Interface - Ask if they want to Revert the Financial also(Custom label). 
If they yes than ONLY Void all invoices and schedule Payment.
@Param: String contactId.
@Return: 
@Author: RSI*/
    @AuraEnabled
    public static Boolean updateInvoice_SchedulePayment(String contactId){
        List<OrderApi__Invoice__c> updateInvoiceList = new  List<OrderApi__Invoice__c>();
        List<OrderApi__Scheduled_Payment__c> updateschedulePaymentList = new  List<OrderApi__Scheduled_Payment__c>();
        if(String.isNotBlank(contactId)){
            List<OrderApi__Sales_Order__c> salesOrderList=[select id,(select id,OrderApi__Status__c from OrderApi__Invoices__r where OrderApi__Status__c='Draft') from OrderApi__Sales_Order__c where OrderApi__Contact__c=:contactId];
            if(salesOrderList.size()>0){
                for(OrderApi__Sales_Order__c so:salesOrderList){
                    if(so.OrderApi__Invoices__r.size()>0){
                        for(OrderApi__Invoice__c inv:so.OrderApi__Invoices__r){
                            inv.OrderApi__Status__c='Voided';
                            updateInvoiceList.add(inv);
                        } 
                    }
                }
            }
            if(updateInvoiceList.size()>0){
                Set<Id> invoiceIds= (new Map<Id,sObject>(updateInvoiceList)).keySet(); 
                if(!invoiceIds.isEmpty()){
                    List<OrderApi__Scheduled_Payment__c> schedulePaymentList = [select OrderApi__Is_Cancelled__c from OrderApi__Scheduled_Payment__c where OrderApi__Invoice__c in:invoiceIds];
                    if(schedulePaymentList.size()>0){
                        for(OrderApi__Scheduled_Payment__c sp:schedulePaymentList){
                            sp.OrderApi__Is_Cancelled__c=true;         
                            updateschedulePaymentList.add(sp);
                        }
                    }
                }
                update updateInvoiceList;
                if(updateschedulePaymentList.size()>0){
                    update updateschedulePaymentList;
                }
            }
        }
        return true;
    }
    
}