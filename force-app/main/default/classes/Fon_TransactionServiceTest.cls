@isTest
public class Fon_TransactionServiceTest {
    public static Boolean isInstalled = false;
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = Fon_TransactionServiceDomain.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'OrderApi__Transaction__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);        
            
            isInstalled = true;
            
        }
    }
    
    
    @isTest
    public static void method1(){
        install();
        
        OrderApi__Credit_Memo__c cm = new OrderApi__Credit_Memo__c();
        insert cm;
        
        OrderApi__Receipt__c receipt = new OrderApi__Receipt__c();
        receipt.Fon_Credit_Memo__c=cm.Id;
        insert receipt;
        
        OrderApi__Transaction__c tr = new OrderApi__Transaction__c();
        tr.OrderApi__Receipt__c=receipt.Id;
        
        Test.startTest();
        insert tr;
        sYSTEM.assertEquals(cm.Id, tr.OrderApi__Credit_Memo__c);
        Test.stopTest();
        
    }
}