public class Fon_CommonUtilityCtrl{
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
    
    
    
    public static List<OrderApi__Subscription__c> fetchSubscriptionBycontactIdSet(Set<Id> contactIdSet){
        List<OrderApi__Subscription__c> lstSubscription = [SELECT Id,OrderApi__Status__c,
                                                           OrderApi__Cancelled_Reason__c,
                                                           OrderApi__Sales_Order_Line__c,
                                                           OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c,
                                                           OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c 
                                                           FROM OrderApi__Subscription__c 
                                                           WHERE OrderApi__Contact__c IN :contactIdSet
                                                           AND OrderApi__Status__c =:strActive 
                                                           AND OrderApi__Subscription_Plan__c != null 
                                                           AND OrderApi__Item__r.OrderApi__Item_Class__r.Fon_Is_Main_Membership__c =:true];
        return lstSubscription;
    }
    
    // Is Financial = true: this function will be used for financial Membership
    public static void updatingInvoiceAndScheduledPayment(List<OrderApi__Subscription__c> lstSubscription){
        Set<Id> salesOrderIdSet = new Set<Id>();
        List<OrderApi__Invoice__c> lstInvoice = new List<OrderApi__Invoice__c>();
        List<OrderApi__Scheduled_Payment__c> updateschedulePaymentList = new  List<OrderApi__Scheduled_Payment__c>();
        for(OrderApi__Subscription__c eachSubscription : lstSubscription){           
            if(eachSubscription.OrderApi__Sales_Order_Line__c != null){
                salesOrderIdSet.add(eachSubscription.OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c);
            }
        }
        if(!salesOrderIdSet.isEmpty()){
            List<OrderApi__Sales_Order__c> lstSO = [SELECT Id,(SELECT Id,OrderApi__Is_Voided__c,OrderApi__Is_Posted__c,OrderApi__Is_Cancelled__c, 
                                                    OrderApi__Is_Paid__c FROM OrderApi__Invoices__r WHERE OrderApi__Status__c IN :lstDraftInvoice) 
                                                    FROM OrderApi__Sales_Order__c 
                                                    WHERE Id IN :salesOrderIdSet 
                                                    AND OrderApi__Posting_Entity__c =:strPostedEntity 
                                                    AND OrderApi__Schedule_Type__c = 'Installment'];
            if(lstSO.size()>0){
                for(OrderApi__Sales_Order__c eachSO : lstSO){
                    for(OrderApi__Invoice__c eachInvoice : eachSO.OrderApi__Invoices__r){
                        if(eachInvoice.OrderApi__Is_Posted__c && !eachInvoice.OrderApi__Is_Paid__c){
                            eachInvoice.OrderApi__Is_Voided__c = true;
                            lstInvoice.add(eachInvoice);
                        }else if(!eachInvoice.OrderApi__Is_Posted__c && !eachInvoice.OrderApi__Is_Paid__c){
                            eachInvoice.OrderApi__Is_Cancelled__c = true;
                            lstInvoice.add(eachInvoice);
                        }
                    }
                }
            }
        }
        if(!lstInvoice.isEmpty()){
            Set<Id> invoiceIds= (new Map<Id,sObject>(lstInvoice)).keySet(); 
            if(!invoiceIds.isEmpty()){
                List<OrderApi__Scheduled_Payment__c> schedulePaymentList = [select OrderApi__Is_Cancelled__c from OrderApi__Scheduled_Payment__c where OrderApi__Invoice__c IN :invoiceIds];
                if(schedulePaymentList.size()>0){
                    for(OrderApi__Scheduled_Payment__c sp:schedulePaymentList){
                        sp.OrderApi__Is_Cancelled__c=true;         
                        updateschedulePaymentList.add(sp);
                    }
                }
            }
            update lstInvoice;
            if(updateschedulePaymentList.size()>0){
                update updateschedulePaymentList;
            }
        }
    }
    // Is Financial = false :: this function will be used for Non financial Membership
    public static void updateSubscription(List<OrderApi__Subscription__c> lstSubscription, String strStatus){
        for(OrderApi__Subscription__c eachSubscription : lstSubscription){
            eachSubscription.OrderApi__Status__c = strStatus;
        }
        if(!lstSubscription.isEmpty()){
            update lstSubscription;
        }
    }
    
    public static void updatingContactStatus(Set<Id> contactIdSet, String strStatus){
        List<Contact> lstContact = new List<Contact>();
        for(Id eachId : contactIdSet){
            lstContact.add(new Contact(id=eachId,Fon_Current_Membership_Status__c=strStatus));
        }
        update lstContact;
        
    }
    
}