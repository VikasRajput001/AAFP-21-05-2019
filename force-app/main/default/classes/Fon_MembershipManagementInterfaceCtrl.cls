/*
    @Description:  Managing membership related action such as Cancelled Membership, Chnage Member Type and Change State etc.
    @Author: RSI
*/
public with sharing class Fon_MembershipManagementInterfaceCtrl{
    final static String strInvoiceStatus = 'Voided';
    final static String strActive = 'Active';
    final static String strInactive = 'Inactive';
    final static String strPostedEntity = 'Invoice';
    final static Boolean isVoid = false;
    public static Map<String,String> mapKeyToMSG = new Map<String,String>();
    /*
        @Description: This function will be used to cancell membership staging
        @Lightning Component: Fon_MembershipManagementInterface
    */
    @AuraEnabled
    public static Map<String,String> cancellingMembership(String recordId){
        List<Fon_Membership_Staging__c> lstMember = [SELECT Id,Fon_Staging_Status__c,Fon_Cancelled_Reason__c FROM Fon_Membership_Staging__c 
                                                        WHERE Fon_Staging_Status__c =:strActive AND Fon_Contact__c =:recordId];
        for(Fon_Membership_Staging__c eachMember : lstMember){
            eachMember.Fon_Staging_Status__c = strInactive;
            eachMember.Fon_Cancelled_Reason__c = Label.Fon_Cancelled_Reason;
        }
        if(!lstMember.isEmpty()){
            update lstMember;
            update new Contact(id=recordId,Fon_Current_Membership_Status__c=strInactive);
            updateSalesOrder(recordId); //Updating invoice
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
    public static void updateSalesOrder(Id contactId){
        List<OrderApi__Invoice__c> lstInvoice = new List<OrderApi__Invoice__c>();
        List<OrderApi__Sales_Order__c> lstSO = [SELECT Id,(SELECT Id,OrderApi__Is_Voided__c,OrderApi__Is_Posted__c,OrderApi__Is_Cancelled__c, 
                                                    OrderApi__Is_Paid__c FROM OrderApi__Invoices__r WHERE OrderApi__Status__c !=:strInvoiceStatus) 
                                                        FROM OrderApi__Sales_Order__c WHERE OrderApi__Contact__c =:contactId AND OrderApi__Posting_Entity__c =:strPostedEntity];
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
}