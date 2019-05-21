@isTest
public class SaleOrderLineServiceTest {
    @testSetup
    public static void setData() {
        
    }    
    @isTest
    public static void method1(){
        OrderApi__Item__c op = new OrderApi__Item__c();
        op.Name='Convenience fee';
        op.OrderApi__Is_Active__c=true;
        op.OrderApi__Price__c=15;
        insert op;
        
        OrderApi__Sales_Order__c so= new OrderApi__Sales_Order__c();
        insert so;
        
        OrderApi__Sales_Order_Line__c soli= new OrderApi__Sales_Order_Line__c();
        soli.OrderApi__Sales_Order__c=so.Id;
        soli.OrderApi__Item__c=op.Id;
        insert soli;
        
      //  soli.OrderApi__Is_Renewal__c=true;
        //soli.OrderApi__Subscription__c=;
        //update soli;
        
    }
}