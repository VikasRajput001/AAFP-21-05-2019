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
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
         // cons.apexClass = Fon_ReceiptDomain.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'Fon_Membership_Staging__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);               
            
            isInstalled = true;
            
        }
    }
@isTest
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
        insert member;
            
        OrderApi__Sales_Order__c salesOrder =new OrderApi__Sales_Order__c();
        salesOrder.OrderApi__Contact__c=con.Id;
        salesOrder.OrderApi__Posting_Entity__c='Invoice';
        insert salesOrder;
        
        salesOrder.OrderApi__Status__c='Closed';
        update salesOrder;
        
        OrderApi__Invoice__c inv =new OrderApi__Invoice__c();
        inv.OrderApi__Status__c='Cancelled';
        inv.OrderApi__Sales_Order__c=salesOrder.Id;
        inv.OrderApi__Invoice_Date__c=system.today();
        insert inv;
        
       Test.startTest();
       Fon_MembershipManagementInterfaceCtrl.cancellingMembership(con.Id, 'Demo');
       Fon_MembershipManagementInterfaceCtrl.updateSubsAndSalesOrder(con.Id, 'Demo');
       Fon_MembershipManagementInterfaceCtrl.fetchingActiveMembership(con.Id);
       Test.stopTest();          
  }

}