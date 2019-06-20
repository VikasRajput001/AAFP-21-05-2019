@isTest
public class Fon_batchTest {
    public static Boolean isInstalled = false;
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            isInstalled = true;
        }
    }
    
    @isTest
    public static void method1(){
        install();
        Framework.Dispatcher.disableTriggerInContext.put('Account',true);
        Framework.Dispatcher.disableTriggerInContext.put('Contact',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Item_Class__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Item__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Subscription_Plan__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Subscription__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Business_Group__c',true); 
        
        Account acct = new Account();
        acct.Name = 'Test Account';
        insert acct;
        
        Contact con = new Contact();
        con.LastName = 'LASTNAME';
        con.AccountId = acct.Id;
        con.Email ='testemail@testemail.com';
        con.MailingPostalCode = '22209';
        con.Fon_AAFP_ID__c= 111;
        con.Fon_Total_Months_of_Membership__c=10;
        con.Fon_Current_Membership_Status__c='Active';
        insert con;
        
        OrderApi__Credit_Memo__c cm = new OrderApi__Credit_Memo__c();
        cm.OrderApi__Contact__c = con.Id;
        cm.Fon_Suggested_Usage__c='Memberships';
        cm.Fon_Required__c=true;
        cm.OrderApi__Amount__c=500;
        insert cm;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Test BG';
        insert bg;
        
        OrderApi__GL_Account__c glAcc = new OrderApi__GL_Account__c(OrderApi__Business_Group__c = bg.id);
        insert glAcc ;
        
       
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Account__c = acct.id;
        so.OrderApi__Contact__c = con.id;
        so.OrderApi__Status__c='Open';
        so.OrderApi__Posting_Entity__c='Receipt';
        so.OrderApi__Is_Posted__c=false;
        so.Fon_Auto_Apply_Credit__c=true;
        insert so;
        
        OrderApi__Subscription_Plan__c  subPlan = new OrderApi__Subscription_Plan__c();
        subPlan.Name = 'test subscription plan';
        subPlan.OrderApi__Type__c = 'Termed';
        subPlan.OrderApi__Initial_Term_Months__c = 12;
        subPlan.OrderApi__Renewal_Term_Months__c = 12;
        subPlan.OrderApi__Bill_Cycle__c = 'AUTO';
        subPlan.OrderApi__Auto_Renew_Option__c = 'Enabled';
        subPlan.OrderApi__Enable_Proration__c = false;
        subPlan.OrderApi__Is_Active__c = true;
        subPlan.OrderApi__Business_Group__c = bg.Id;
        subPlan.OrderApi__Enable_Schedule__c=false;
        subPlan.OrderApi__Schedule_Frequency__c='Monthly';
        insert subPlan;
        
        
        
        OrderApi__Item_Class__c itmClass = new OrderApi__Item_Class__c();
        itmClass.Name = 'Test Class';
        itmClass.OrderApi__Enable_Assignments__c = false;
        itmClass.OrderApi__Is_Subscription__c = true;
        itmClass.OrderApi__Assignment_SObject__c = 'TEST__C';
        itmClass.OrderApi__Is_Active__c = false;
        itmClass.OrderApi__Business_Group__c = bg.Id;
        itmClass.OrderApi__Is_Active__c = true;
        insert itmClass;
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'Convenience fee';
        itm.OrderApi__Is_Subscription__c = true;
        itm.OrderApi__Business_Group__c = bg.Id;
        itm.OrderApi__Item_Class__c = itmClass.Id;
        itm.OrderApi__Is_Active__c = false;
        itm.OrderApi__Price__c = 15;
        itm.OrderApi__Income_Account__c = glAcc.id;
        itm.OrderApi__Adjustment_Account__c = glAcc.id;
        itm.OrderApi__Refund_Account__c = glAcc.id;
        insert itm;
        
        OrderApi__Sales_Order_Line__c sol1 = new OrderApi__Sales_Order_Line__c();
        sol1.OrderApi__Sales_Order__c = so.id;
        sol1.OrderApi__Account__c = acct.id;
        sol1.OrderApi__Contact__c = con.id;
        sol1.OrderApi__Item_Class__c = itm.OrderApi__Item_Class__c;
        sol1.OrderApi__Item__c = itm.id;
        sol1.OrderApi__Is_Subscription__c = true;
        sol1.OrderApi__Subscription_Plan__c = subPlan.id;
        sol1.OrderApi__Is_Renewal__c= False;
        insert sol1;
        
        
        
        so.OrderApi__Status__c='Closed';
        update so;
        
        
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.Fon_batch')); 
        System.currentPageReference().getParameters().put('soIds', so.id);
        Fon_batch obj = new Fon_batch();
        obj.process();
        Test.stopTest();
    }
    
    @isTest
    public static void method2(){
        install();
        Framework.Dispatcher.disableTriggerInContext.put('Account',true);
        Framework.Dispatcher.disableTriggerInContext.put('Contact',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Item_Class__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Item__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Subscription_Plan__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Subscription__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Business_Group__c',true); 
        
        Account acct = new Account();
        acct.Name = 'Test Account';
        insert acct;
        
        Contact con = new Contact();
        con.LastName = 'LASTNAME';
        con.AccountId = acct.Id;
        con.Email ='testemail@testemail.com';
        con.MailingPostalCode = '22209';
        con.Fon_AAFP_ID__c= 111;
        con.Fon_Total_Months_of_Membership__c=10;
        con.Fon_Current_Membership_Status__c='Active';
        insert con;
        
        OrderApi__Credit_Memo__c cm = new OrderApi__Credit_Memo__c();
        cm.OrderApi__Contact__c = con.Id;
        cm.Fon_Suggested_Usage__c='Memberships';
        cm.Fon_Required__c=true;
        cm.OrderApi__Amount__c=10;
        insert cm;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Test BG';
        insert bg;
        
        OrderApi__GL_Account__c glAcc = new OrderApi__GL_Account__c(OrderApi__Business_Group__c = bg.id);
        insert glAcc ;
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Account__c = acct.id;
        so.OrderApi__Contact__c = con.id;
        so.OrderApi__Status__c='Open';
        so.OrderApi__Posting_Entity__c='Receipt';
        so.OrderApi__Is_Posted__c=false;
        so.Fon_Auto_Apply_Credit__c=true;
        insert so;
        
        OrderApi__Subscription_Plan__c  subPlan = new OrderApi__Subscription_Plan__c();
        subPlan.Name = 'test subscription plan';
        subPlan.OrderApi__Type__c = 'Termed';
        subPlan.OrderApi__Initial_Term_Months__c = 12;
        subPlan.OrderApi__Renewal_Term_Months__c = 12;
        subPlan.OrderApi__Bill_Cycle__c = 'AUTO';
        subPlan.OrderApi__Auto_Renew_Option__c = 'Enabled';
        subPlan.OrderApi__Enable_Proration__c = false;
        subPlan.OrderApi__Is_Active__c = true;
        subPlan.OrderApi__Business_Group__c = bg.Id;
        subPlan.OrderApi__Enable_Schedule__c=false;
        subPlan.OrderApi__Schedule_Frequency__c='Monthly';
        insert subPlan;
        
        
        
        OrderApi__Item_Class__c itmClass = new OrderApi__Item_Class__c();
        itmClass.Name = 'Test Class';
        itmClass.OrderApi__Enable_Assignments__c = false;
        itmClass.OrderApi__Is_Subscription__c = true;
        itmClass.OrderApi__Assignment_SObject__c = 'TEST__C';
        itmClass.OrderApi__Is_Active__c = false;
        itmClass.OrderApi__Business_Group__c = bg.Id;
        itmClass.OrderApi__Is_Active__c = true;
        insert itmClass;
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'Convenience fee';
        itm.OrderApi__Is_Subscription__c = true;
        itm.OrderApi__Business_Group__c = bg.Id;
        itm.OrderApi__Item_Class__c = itmClass.Id;
        itm.OrderApi__Is_Active__c = false;
        itm.OrderApi__Price__c = 15;
        itm.OrderApi__Income_Account__c = glAcc.id;
        itm.OrderApi__Adjustment_Account__c = glAcc.id;
        itm.OrderApi__Refund_Account__c = glAcc.id;
        insert itm;
        
        OrderApi__Sales_Order_Line__c sol1 = new OrderApi__Sales_Order_Line__c();
        sol1.OrderApi__Sales_Order__c = so.id;
        sol1.OrderApi__Account__c = acct.id;
        sol1.OrderApi__Contact__c = con.id;
        sol1.OrderApi__Item_Class__c = itm.OrderApi__Item_Class__c;
        sol1.OrderApi__Item__c = itm.id;
        sol1.OrderApi__Is_Subscription__c = true;
        sol1.OrderApi__Subscription_Plan__c = subPlan.id;
        sol1.OrderApi__Is_Renewal__c= False;
        insert sol1;
        
        
        
        so.OrderApi__Status__c='Closed';
        update so;
        
        
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.Fon_batch')); 
        System.currentPageReference().getParameters().put('soIds', so.id);
        Fon_batch obj = new Fon_batch();
        obj.process();
        Test.stopTest();
    }
    @isTest
    public static void method3(){
        install();
        Framework.Dispatcher.disableTriggerInContext.put('Account',true);
        Framework.Dispatcher.disableTriggerInContext.put('Contact',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Item_Class__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Item__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Subscription_Plan__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Subscription__c',true);
        Framework.Dispatcher.disableTriggerInContext.put('OrderApi__Business_Group__c',true); 
        
        Account acct = new Account();
        acct.Name = 'Test Account';
        insert acct;
        
        Contact con = new Contact();
        con.LastName = 'LASTNAME';
        con.AccountId = acct.Id;
        con.Email ='testemail@testemail.com';
        con.MailingPostalCode = '22209';
        con.Fon_AAFP_ID__c= 111;
        con.Fon_Total_Months_of_Membership__c=10;
        con.Fon_Current_Membership_Status__c='Active';
        insert con;
        
        OrderApi__Credit_Memo__c cm = new OrderApi__Credit_Memo__c();
        cm.OrderApi__Contact__c = con.Id;
        cm.Fon_Suggested_Usage__c='Memberships';
        cm.Fon_Required__c=true;
        cm.OrderApi__Amount__c=15;
        insert cm;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Test BG';
        insert bg;
        
        OrderApi__GL_Account__c glAcc = new OrderApi__GL_Account__c(OrderApi__Business_Group__c = bg.id);
        insert glAcc ;
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Account__c = acct.id;
        so.OrderApi__Contact__c = con.id;
        so.OrderApi__Status__c='Open';
        so.OrderApi__Posting_Entity__c='Receipt';
        so.OrderApi__Is_Posted__c=false;
        so.Fon_Auto_Apply_Credit__c=true;
        insert so;
        
        OrderApi__Subscription_Plan__c  subPlan = new OrderApi__Subscription_Plan__c();
        subPlan.Name = 'test subscription plan';
        subPlan.OrderApi__Type__c = 'Termed';
        subPlan.OrderApi__Initial_Term_Months__c = 12;
        subPlan.OrderApi__Renewal_Term_Months__c = 12;
        subPlan.OrderApi__Bill_Cycle__c = 'AUTO';
        subPlan.OrderApi__Auto_Renew_Option__c = 'Enabled';
        subPlan.OrderApi__Enable_Proration__c = false;
        subPlan.OrderApi__Is_Active__c = true;
        subPlan.OrderApi__Business_Group__c = bg.Id;
        subPlan.OrderApi__Enable_Schedule__c=false;
        subPlan.OrderApi__Schedule_Frequency__c='Monthly';
        insert subPlan;
        
        
        
        OrderApi__Item_Class__c itmClass = new OrderApi__Item_Class__c();
        itmClass.Name = 'Test Class';
        itmClass.OrderApi__Enable_Assignments__c = false;
        itmClass.OrderApi__Is_Subscription__c = true;
        itmClass.OrderApi__Assignment_SObject__c = 'TEST__C';
        itmClass.OrderApi__Is_Active__c = false;
        itmClass.OrderApi__Business_Group__c = bg.Id;
        itmClass.OrderApi__Is_Active__c = true;
        insert itmClass;
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = 'Convenience fee';
        itm.OrderApi__Is_Subscription__c = true;
        itm.OrderApi__Business_Group__c = bg.Id;
        itm.OrderApi__Item_Class__c = itmClass.Id;
        itm.OrderApi__Is_Active__c = false;
        itm.OrderApi__Price__c = 15;
        itm.OrderApi__Income_Account__c = glAcc.id;
        itm.OrderApi__Adjustment_Account__c = glAcc.id;
        itm.OrderApi__Refund_Account__c = glAcc.id;
        insert itm;
        
        OrderApi__Sales_Order_Line__c sol1 = new OrderApi__Sales_Order_Line__c();
        sol1.OrderApi__Sales_Order__c = so.id;
        sol1.OrderApi__Account__c = acct.id;
        sol1.OrderApi__Contact__c = con.id;
        sol1.OrderApi__Item_Class__c = itm.OrderApi__Item_Class__c;
        sol1.OrderApi__Item__c = itm.id;
        sol1.OrderApi__Is_Subscription__c = true;
        sol1.OrderApi__Subscription_Plan__c = subPlan.id;
        sol1.OrderApi__Is_Renewal__c= False;
        insert sol1;
        
        
        
        so.OrderApi__Status__c='Closed';
        update so;
        
        
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.Fon_batch')); 
        System.currentPageReference().getParameters().put('soIds', so.id);
        Fon_batch obj = new Fon_batch();
        obj.process();
        Test.stopTest();
    }
    
}