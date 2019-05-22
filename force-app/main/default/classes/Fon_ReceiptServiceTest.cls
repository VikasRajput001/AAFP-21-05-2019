@isTest
public class Fon_ReceiptServiceTest {
    
    public static Boolean isInstalled = false;
    static OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
    private static void install() {
        if (!isInstalled) {
            //Fon_PackageScripts.install();
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            
            // Create a routing rule for OrderApi__Receipt__c
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = Fon_ReceiptDomain.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'OrderApi__Receipt__c';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);               
            
            isInstalled = true;
            
        }
    }
    
    
    @isTest
    public static void method1(){
        install();
        bg = new OrderApi__Business_Group__c();
        bg.Name = 'Test BG';
        insert bg;
        
        OrderApi__GL_Account__c glAcc = new OrderApi__GL_Account__c(OrderApi__Business_Group__c = bg.id);
        insert glAcc ;
        
        bg.Accounts_Payable_Account__c=glAcc.Id;
        update bg;
        
        List<OrderApi__Receipt__c> insertReceipt= new List<OrderApi__Receipt__c>();
        OrderApi__Receipt__c rec= new OrderApi__Receipt__c();
        rec.OrderApi__Type__c='Refund';
        rec.OrderApi__Payment_Type__c='Check';
        rec.OrderApi__Business_Group__c=bg.Id;
        
        Test.startTest();
        insert rec;
        
        List<OrderApi__Receipt__c> recp=[select OrderApi__Deposit_Account__c from OrderApi__Receipt__c where id=:rec.Id];
        system.assertEquals(bg.Accounts_Payable_Account__c, recp[0].OrderApi__Deposit_Account__c);
        Test.stopTest();       
    }
}