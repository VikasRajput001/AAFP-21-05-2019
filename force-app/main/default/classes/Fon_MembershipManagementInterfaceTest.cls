@isTest
public class Fon_MembershipManagementInterfaceTest {
    
    public static Boolean isInstalled = false;
    static OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            // Create a routing rule for OrderApi__Sales_Order__c
            // Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            //  Framework.RoutingRule cons = new Framework.RoutingRule();
            // cons.apexClass = Fon_ReceiptDomain.class.getName();
            // cons.namespace = '';
            // cons.isEnabled = true;
            // cons.sObjectName = 'Fon_Membership_Staging__c';
            // cons.executionOrder = 0;
            //  rules.add(cons);
            // Framework.Config.push(rules);               
            
            isInstalled = true;
            
        }
    }
    /*  @isTest
public static void method1(){
install();

Contact con=new Contact();
con.Fon_AAFP_ID__c=1234;
con.Fon_Total_Months_of_Membership__c=12;
con.Fon_Current_Membership_Status__c ='Active';
con.LastName='Test Contact';
insert con;

Fon_Membership_Staging__c member = new Fon_Membership_Staging__c();
member.Fon_Staging_Status__c = 'Active';
member.Fon_Membership_Activation_Date__c =system.today();
member.Fon_Membership_Type__c ='Student';
member.Fon_Membership_State_Chapter__c ='Virginia';
member.Fon_Dues_Paid_by_Chapter__c = 20;
member.Fon_Dues_Paid_by_Residency_Program__c =18;
member.Fon_Join_Date__c = system.today();
member.Fon_Chapter_Join_Date__c =system.today();

member.Fon_Contact__c=con.Id;
member.Fon_Subscription_Plan__c='1/1-12/31,single paymt';
// insert member;

OrderApi__Sales_Order__c salesOrder =new OrderApi__Sales_Order__c();
salesOrder.OrderApi__Contact__c=con.Id;
salesOrder.OrderApi__Posting_Entity__c='Invoice';
// insert salesOrder;

salesOrder.OrderApi__Status__c='Closed';
// update salesOrder;

OrderApi__Invoice__c inv =new OrderApi__Invoice__c();
inv.OrderApi__Status__c='Cancelled';
inv.OrderApi__Sales_Order__c=salesOrder.Id;
inv.OrderApi__Invoice_Date__c=system.today();
//insert inv;

Test.startTest();
// Fon_MembershipManagementInterfaceCtrl.cancellingMembership(con.Id, 'Demo');
// Fon_MembershipManagementInterfaceCtrl.updateSubsAndSalesOrder(con.Id, 'Demo');
Fon_MembershipManagementInterfaceCtrl.fetchingActiveMembership(con.Id);
Test.stopTest();          
}*/
    
    @isTest
    public static void testMethodForUpdateRecords(){
         List<OrderApi__Item_Class__c> itemClassList = new List<OrderApi__Item_Class__c>();
         List<OrderApi__Item__c> itemList = new List<OrderApi__Item__c>();
        
        install();
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
        
        Fon_Membership_Staging__c ms = new Fon_Membership_Staging__c();
        ms.Fon_Contact__c=con.Id;
        ms.Fon_Staging_Status__c='Active';
        ms.Fon_Membership_Type__c='Resident';
        ms.Fon_Membership_State__c = 'Virginia';
        ms.Fon_Membership_Local__c= 'VA Northern Virginia';
        ms.Fon_Dues_Paid_by_Chapter__c=5;
        ms.Fon_Dues_Paid_by_Residency_Program__c=4;
        ms.Fon_Membership_Activation_Date__c=system.today();
        ms.Fon_Join_Date__c=system.today();
        ms.Fon_Chapter_Join_Date__c=system.today();
        ms.Fon_Residency_Program_Graduation_Date__c=system.today();
        insert ms;
        
       
        
        OrderApi__Item_Class__c itmClassMain= new OrderApi__Item_Class__c();
        itmClassMain.Fon_Is_Main_Membership__c=true;
        itmClassMain.OrderApi__Is_Active__c=true;
        itemClassList.add(itmClassMain);
        
        OrderApi__Item_Class__c itmClassState= new OrderApi__Item_Class__c();
        itmClassState.Fon_Is_Main_Membership__c=true;
        itmClassState.Fon_Is_State_Membership__c=true;
        itemClassList.add(itmClassState);       
        
        OrderApi__Item_Class__c itmClass= new OrderApi__Item_Class__c();
        itemClassList.add(itmClass);
        
        Insert itemClassList;
        
        OrderApi__Item__c itm = new OrderApi__Item__c();
        itm.Name='Membership California Dues';
        itm.OrderApi__Item_Class__c=itmClass.Id;
        itemList.add(itm);
        
        OrderApi__Item__c itm1 = new OrderApi__Item__c();
        itm1.Name='Membership testLocal Dues';
        itm1.OrderApi__Item_Class__c=itmClass.Id;
        itemList.add(itm1);
        
        OrderApi__Item__c itm2 = new OrderApi__Item__c();
        itm2.Name='state item';
        itm2.OrderApi__Item_Class__c=itmClassMain.Id;
        itm2.OrderApi__Is_Active__c=true;
        itemList.add(itm2);
        
        OrderApi__Item__c itm3 = new OrderApi__Item__c();
        itm3.Name='state item';
        itm3.OrderApi__Item_Class__c=itmClassState.Id;
        itm3.OrderApi__Is_Active__c=true;
        itemList.add(itm3);
        
        Insert itemList;      
        
        OrderApi__Badge_Type__c bt = new OrderApi__Badge_Type__c();
        bt.Name='testType';
        insert bt;
        
        OrderApi__Badge_Workflow__c bw= new OrderApi__Badge_Workflow__c();
        bw.OrderApi__Item__c=itm.Id;
        bw.OrderApi__Badge_Type__c=bt.Id;
        insert bw;
        
        OrderApi__Badge_Workflow__c bw1= new OrderApi__Badge_Workflow__c();
        bw1.OrderApi__Item__c=itm1.Id;
        bw1.OrderApi__Badge_Type__c=bt.Id;
        insert bw1;
        
        OrderApi__Subscription_Plan__c plan= new OrderApi__Subscription_Plan__c();
        plan.OrderApi__Type__c='Lifetime';
        plan.OrderApi__Is_Active__c=true;
        insert plan;
        
        OrderApi__Subscription__c sub = new OrderApi__Subscription__c();
        sub.OrderApi__Contact__c=con.Id;
        sub.OrderApi__Is_Active__c=true;
        sub.OrderApi__Item__c=itm2.Id;
        sub.OrderApi__Status__c='Active';
        sub.OrderApi__Subscription_Plan__c=plan.Id;
        insert sub;
        
        OrderApi__Subscription_Line__c sl= new OrderApi__Subscription_Line__c();
        sl.OrderApi__Subscription__c=sub.Id;
        sl.OrderApi__Item__c=itm3.Id;
        sl.OrderApi__Is_Amendment__c=true;
        Insert sl;
        
        Test.startTest();
        //Fon_MembershipManagementInterfaceCtrl.updateRecords(con.Id,ms.Id,'California','testLocal');
        Fon_MembershipManagementInterfaceCtrl.updateRecords(con.Id,ms.Id,'California','');  
        Fon_MembershipManagementInterfaceCtrl.cancellingMembership(con.Id,'test','');  
        Fon_MembershipManagementInterfaceCtrl.updateSubsAndSalesOrder(con.Id,'test',''); 
        Fon_MembershipManagementInterfaceCtrl.changeStateLocal(con.Id);
        Fon_MembershipManagementInterfaceCtrl.fetchingActiveMembership(con.Id);
        Test.stopTest();
        
    }
    
}