@isTest
public class Fon_RefundCreditMemoTest {
    
    @istest
    static void method1() {
        OrderApi__Credit_Memo__c cm = new OrderApi__Credit_Memo__c();
        insert cm;
        
        OrderApi__Transaction__c tr = new OrderApi__Transaction__c();
        tr.OrderApi__Credit_Memo__c=cm.Id;
        insert tr;
        
        OrderApi__Receipt__c receipt = new OrderApi__Receipt__c();
        insert receipt;
        
        cm.Fon_Receipt__c=receipt.Id;
        update cm;
        
        OrderApi__Item_Class__c itmClass = new OrderApi__Item_Class__c();
        itmClass.Name = 'Test Class';
        itmClass.OrderApi__Enable_Assignments__c = false;
        itmClass.OrderApi__Is_Subscription__c = true;
        itmClass.OrderApi__Assignment_SObject__c = 'TEST__C';
        itmClass.OrderApi__Is_Active__c = false;
        itmClass.OrderApi__Is_Active__c = true;
        insert itmClass;       
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'Credit Memo Refund Item';
        insert itm;
        
        
        OrderApi__Subscription_Plan__c subPlan = new OrderApi__Subscription_Plan__c();
        subPlan.Name = 'test subscription plan';
        subPlan.OrderApi__Type__c = 'Termed';
        subPlan.OrderApi__Initial_Term_Months__c = 12;
        subPlan.OrderApi__Renewal_Term_Months__c = 12;
        subPlan.OrderApi__Bill_Cycle__c = 'AUTO';
        subPlan.OrderApi__Auto_Renew_Option__c = 'Enabled';
        subPlan.OrderApi__Enable_Proration__c = false;
        subPlan.OrderApi__Is_Active__c = true;
        subPlan.OrderApi__Enable_Schedule__c=true;
        subPlan.OrderApi__Schedule_Frequency__c='Monthly';
        insert subPlan;
        
        OrderApi__Item_Subscription_Plan__c sp = new OrderApi__Item_Subscription_Plan__c();
        sp.OrderApi__Is_Default__c=true;
        sp.OrderApi__Item__c=itm.Id;
        sp.OrderApi__Subscription_Plan__c=subPlan.Id;
        insert sp;
        
        itm.OrderApi__Is_Active__c=true;      
        update itm;
        
        
        Test.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController(cm);
        Fon_RefundCreditMemo rcm= new Fon_RefundCreditMemo(stdController);
        rcm.createCreditMemoline();     
        Test.stopTest();
    }
}