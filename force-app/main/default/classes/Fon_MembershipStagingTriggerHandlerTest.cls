@isTest
public class Fon_MembershipStagingTriggerHandlerTest {
public static Boolean isInstalled = false;
    
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            /* Create a routing rule for SalesOrderLine
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = Fon_SalesOrderLineDomain.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'OrderApi__Sales_Order_Line__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);    */           
            
            isInstalled = true;
            
        }
    }
    @istest
    static void method1() {
        Account ac= new Account();
        ac.Name='testAccount';
        Insert ac;
        
        Contact con= new Contact();
        con.AccountId= ac.Id;
        con.LastName= 'testLast';
        con.Fon_AAFP_ID__c=1;
        con.Fon_Total_Months_of_Membership__c=10;
        con.Fon_Chapter_Change_Needed__c=true;
        con.Fon_Current_Membership_Status__c='Inactive';
        insert con;
        
        OrderApi__Item_Class__c itmClass = new OrderApi__Item_Class__c();
        itmClass.Name = 'Test Class';
        itmClass.OrderApi__Is_Active__c = true;
        insert itmClass; 
       
         OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name = '2019-Resident Membership';
        insert itm;
        
        list<Fon_Membership_Staging__c> mslist=new  list<Fon_Membership_Staging__c>();
        Fon_Membership_Staging__c ms = new Fon_Membership_Staging__c();
        ms.Fon_Contact__c=con.Id;
        ms.Fon_Staging_Status__c='Approved';
        ms.Fon_Membership_Type__c='Resident';
        ms.Fon_Membership_State__c = 'Virginia';
        ms.Fon_Membership_Local__c= 'VA Northern Virginia';
        ms.Fon_Dues_Paid_by_Chapter__c=5;
        ms.Fon_Dues_Paid_by_Residency_Program__c=4;
        ms.Fon_Membership_Activation_Date__c=system.today();
        ms.Fon_Join_Date__c=system.today();
        ms.Fon_Chapter_Join_Date__c=system.today();
        ms.Fon_Residency_Program_Graduation_Date__c=system.today();
        ms.Fon_Subscription_Plan__c='1/1 – 12/31, single paymt + autorenew';
        ms.Fon_Year__c='2019';
        mslist.add(ms);
        insert mslist; 
        
        
       Test.startTest();
        Fon_MembershipStagingTriggerHandler MembershipStagingTrigger=new Fon_MembershipStagingTriggerHandler();
        MembershipStagingTrigger.initializeMembershipStage(mslist);
        Test.stopTest();
    }
}