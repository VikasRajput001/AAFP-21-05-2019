@isTest
public class Fon_proformaInvoiceServiceTest {
    
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
            cons.sObjectName = 'OrderApi__Sales_Order__c';
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
        
        OrderApi__Sales_Order__c salesOrder = new OrderApi__Sales_Order__c();
		salesOrder.OrderApi__Status__c='Open';
		insert salesOrder;
        
        salesOrder.OrderApi__Status__c='Closed';
        update salesOrder;
		
		OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c();
		itemClass.Name = 'Test Item Class';
		insert itemClass;
        
		OrderApi__Item__c itemdata = new OrderApi__Item__c();
		itemdata.Name='Test Item';
		itemdata.OrderApi__Is_Subscription__c = true;
		itemdata.OrderApi__Item_Class__c = itemClass.Id;
		insert itemdata;
		
		OrderApi__Subscription_Plan__c subPlan = new OrderApi__Subscription_Plan__c();
		subPlan.Name = 'test subscription plan';
        subPlan.OrderApi__Type__c = 'Termed';
        subPlan.OrderApi__Initial_Term_Months__c = 12;
		subPlan.OrderApi__Enable_Schedule__c=true;
		subPlan.OrderApi__Schedule_Frequency__c='Monthly';
		insert subPlan;
        
        OrderApi__Sales_Order_Line__c SOLI = new OrderApi__Sales_Order_Line__c();
		SOLI.OrderApi__Item__c=itemdata.Id;
        SOLI.OrderApi__Subscription_Plan__c = subPlan.Id;
        SOLI.OrderApi__Sales_Order__c=salesOrder.Id;
		insert SOLI;
        
       Test.startTest();
       Fon_proformaInvoiceToRegularInvoice.convertProformaInvoice(salesOrder.Id);
       Test.stopTest();          
     }
    }