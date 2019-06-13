public class Fon_ChangeSubscriptionPlan {
    @AuraEnabled
    public static sObject changePlan(Id ContactId, Id subPlanId){
        list<OrderApi__Sales_Order_Line__c> objSalesOrderLine = new list<OrderApi__Sales_Order_Line__c>();
        list<OrderApi__Sales_Order__c> objSalesOrder = new list<OrderApi__Sales_Order__c>();
        set<Id> salesOrderSet =new set<Id>();
        list<OrderApi__Sales_Order__c> SO=[select id,OrderApi__Status__c,(select id, OrderApi__Sales_Order__c,OrderApi__Subscription_Plan__c from OrderApi__Sales_Order_Lines__r Where OrderApi__Is_Renewal__c=true) from OrderApi__Sales_Order__c where 
                                           OrderApi__Contact__c=:ContactId AND OrderApi__Status__c='Open'];
        if(!SO.isEmpty()){
            for(OrderApi__Sales_Order__c salesOrder : SO){
                if(salesOrder.OrderApi__Sales_Order_Lines__r.size() > 0){
                    for(OrderApi__Sales_Order_Line__c SOLI : salesOrder.OrderApi__Sales_Order_Lines__r){
                        SOLI.OrderApi__Subscription_Plan__c='a1NZ0000001fj1N';
                        objSalesOrderLine.add(SOLI);
                        salesOrderSet.add(SOLI.OrderApi__Sales_Order__c);
                        if(salesOrderSet.contains(salesOrder.Id)){
                            salesOrder.OrderApi__Status__c='Closed';
                            objSalesOrder.add(salesOrder);
                        }
                    }
                }
            }
            
        }
        if(!objSalesOrderLine.isEmpty()){
            update objSalesOrderLine;
        }
        
        if(!objSalesOrder.isEmpty()){
            update objSalesOrder;
        }
        return null;
    }
    @AuraEnabled
    public static sObject changePlan2(Id ContactId, Id subPlanId){
    Id salesOrderId='';
    Decimal Total_Balance_Due=0;
    Set<Id> salesOrderIdSet = new Set<Id>();
    map<Id,Id> SalesOrderVSItem =new map<Id,Id>();
    list<OrderApi__Scheduled_Payment__c> listoFSchedulePaymnts =new  list<OrderApi__Scheduled_Payment__c>();
    list<OrderApi__Invoice__c> UpdatedinvoiceList=new list<OrderApi__Invoice__c>();
    list<OrderApi__Invoice__c> invoiceList=new list<OrderApi__Invoice__c>();
    list<OrderApi__Invoice_Line__c> invoiceLineList =new  list<OrderApi__Invoice_Line__c>();
    list<OrderApi__Subscription__c> subscriptions= [select OrderApi__Item__c,OrderApi__Subscription_Plan__r.Name, OrderApi__Subscription_Plan__r.OrderApi__Enable_Schedule__c, OrderApi__Sales_Order_Line__r.name, OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c 
                 from OrderApi__Subscription__c where OrderApi__Status__c='Active' AND  OrderApi__Contact__c=:ContactId];
     if(!subscriptions.isEmpty()){
        for(OrderApi__Subscription__c sub : subscriptions){
            if(sub.OrderApi__Subscription_Plan__r.OrderApi__Enable_Schedule__c){
                salesOrderIdSet.add(sub.OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c);
                SalesOrderVSItem.put(sub.OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c,sub.OrderApi__Item__c);
            }
        }
     }
      list<OrderApi__Invoice__c> invoices = [select id,OrderApi__Balance_Due__c,OrderApi__Sales_Order__c ,(select id,OrderApi__Is_Cancelled__c from OrderApi__Scheduled_Payments__r )from OrderApi__Invoice__c where OrderApi__Sales_Order__c IN : salesOrderIdSet ];
       
         if(!invoices.isEmpty()){
             for(OrderApi__Invoice__c eachInvoice :  invoices){
                 eachInvoice.OrderApi__Is_Voided__c = true;
                 UpdatedinvoiceList.add(eachInvoice);
                 Total_Balance_Due = eachInvoice.OrderApi__Balance_Due__c+ Total_Balance_Due;
                 salesOrderId=eachInvoice.OrderApi__Sales_Order__c;
                 for(OrderApi__Scheduled_Payment__c SP : eachInvoice.OrderApi__Scheduled_Payments__r){
                     SP.OrderApi__Is_Cancelled__c=true;
                     listoFSchedulePaymnts.add(SP);
                 }
             }
         } 
        
        if(!UpdatedinvoiceList.isEmpty()){
            update UpdatedinvoiceList;
        }
        
        if(!listoFSchedulePaymnts.isEmpty()){
            update listoFSchedulePaymnts;
        }
             if(Total_Balance_Due > 0){
              OrderApi__Invoice__c invoice= CreateNewInvoice(salesOrderId,ContactId);
              invoiceList.add(invoice);
             }
         if(!invoiceList.isEmpty()){
             insert invoiceList;
            } 
            for(OrderApi__Invoice__c eachInvoice :  invoiceList){ 
             OrderApi__Invoice_Line__c invoiceLine = CreateNewInvoiceLine(eachInvoice.Id,SalesOrderVSItem.get(eachInvoice.OrderApi__Sales_Order__c),Total_Balance_Due); 
             invoiceLineList.add(invoiceLine);
            } 
             if(!invoiceLineList.isEmpty()){
              insert invoiceLineList;   
             }
        return null;
    }
    public static OrderApi__Invoice__c CreateNewInvoice(Id salesOrderId,Id ContactId){
        OrderApi__Invoice__c invoice =new OrderApi__Invoice__c();
        invoice.OrderApi__Contact__c=ContactId;
        invoice.OrderApi__Sales_Order__c=salesOrderId;
            return invoice; 
         }
    public static OrderApi__Invoice_Line__c CreateNewInvoiceLine(Id invoiceId,Id itemId,Decimal TotalBalanceDue){
         OrderApi__Invoice_Line__c invoiceLine =new OrderApi__Invoice_Line__c();
         invoiceLine.OrderApi__Item__c=itemId;
         invoiceLine.OrderApi__Price_Override__c=true;
         invoiceLine.OrderApi__Sale_Price__c=TotalBalanceDue;
         return invoiceLine;
    }   
  
}