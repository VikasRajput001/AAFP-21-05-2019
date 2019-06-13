@isTest
public class MembershipStagingTriggerHandlerTest {
   public static Boolean isInstalled = false;
    static OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            // Create a routing rule for Fon_Membership_Staging__c
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
     list<Fon_Membership_Staging__c> mslist = new list<Fon_Membership_Staging__c>();
        Fon_Membership_Staging__c ms=new Fon_Membership_Staging__c();
        //ms.Fon_Contact__c=con.Id;
        ms.Fon_Staging_Status__c='Approved';
        ms.Fon_Membership_Type__c='Resident';
       
        ms.Fon_Dues_Paid_by_Chapter__c=5;
        ms.Fon_Dues_Paid_by_Residency_Program__c=4;
        ms.Fon_Membership_Activation_Date__c=system.today();
        ms.Fon_Join_Date__c=system.today();
        ms.Fon_Chapter_Join_Date__c=system.today();
        ms.Fon_Residency_Program_Graduation_Date__c=system.today();
        mslist.add(ms);
        
         Fon_Membership_Staging__c ms1=new Fon_Membership_Staging__c();
        //ms.Fon_Contact__c=con.Id;
        ms1.Fon_Staging_Status__c='Approved';
        ms1.Fon_Membership_Type__c='Resident';
       
        ms1.Fon_Dues_Paid_by_Chapter__c=5;
        ms1.Fon_Dues_Paid_by_Residency_Program__c=4;
        ms1.Fon_Membership_Activation_Date__c=system.today();
        ms1.Fon_Join_Date__c=system.today();
        ms1.Fon_Chapter_Join_Date__c=system.today();
        ms1.Fon_Residency_Program_Graduation_Date__c=system.today();
         mslist.add(ms1);
        
      
       
        
        
        Test.startTest();
       insert mslist;
        //m.createSalesOrderByMemberStaging(mslist);
        Test.stopTest();
    }   
}