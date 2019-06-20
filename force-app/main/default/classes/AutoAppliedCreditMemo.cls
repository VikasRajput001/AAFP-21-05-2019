public class AutoAppliedCreditMemo {
    public static list<sObject> convertProformaInvoice(Set<Id> lstSO){
        map<Id,Id> ContactVSSalesOrder =new  map<Id,Id>();
        set<Id> contactIds=new set<Id>();
        set<Id> newcontactIds=new set<Id>();
        list<OrderApi__Sales_Order__c> salesOrder=[select id,OrderApi__Contact__c,OrderApi__Status__c,OrderApi__Posting_Entity__c,OrderApi__Schedule_Type__c,(select id,OrderApi__Sales_Order__c from OrderApi__Sales_Order_Lines__r where OrderApi__Item__r.OrderApi__Is_Subscription__c=true  AND 
                                                       OrderApi__Subscription_Plan__r.OrderApi__Enable_Schedule__c=false  ) from OrderApi__Sales_Order__c where ID IN :lstSO AND OrderApi__Status__c='Closed'
                                                        AND OrderApi__Posting_Entity__c='Receipt' AND OrderApi__Is_Posted__c=FALSE AND Fon_Auto_Apply_Credit__c=TRUE];
        
        if(!salesOrder.isEmpty()){
            for(OrderApi__Sales_Order__c SO : salesOrder){
                if(SO.OrderApi__Contact__c !=null){
                contactIds.add(SO.OrderApi__Contact__c);
				ContactVSSalesOrder.put(SO.Id,SO.OrderApi__Contact__c);
               }
            }
        }
  list<OrderApi__Credit_Memo__c> creditMemo =[select id,OrderApi__Contact__c  from OrderApi__Credit_Memo__c where Fon_Suggested_Usage__c='Memberships' AND Fon_Required__c=true AND
                                 OrderApi__Contact__c IN : contactIds]; 
        if(!creditMemo.isEmpty()){
            for(OrderApi__Credit_Memo__c CM : creditMemo){
                        newcontactIds.add(CM.OrderApi__Contact__c);
                }
        }
        map<Id,OrderApi__Sales_Order__c> mapOfSalesOrder =new  map<Id,OrderApi__Sales_Order__c>();
        if(!salesOrder.isEmpty()){
            for(OrderApi__Sales_Order__c salesOrderValue : salesOrder){
                if(newcontactIds.contains(ContactVSSalesOrder.get(salesOrderValue.Id)) && salesOrderValue.OrderApi__Sales_Order_Lines__r !=null && salesOrderValue.OrderApi__Sales_Order_Lines__r.size()>0){
                            salesOrderValue.OrderApi__Status__c='Open';//Sales orders to ‘Open’ 
                            salesOrderValue.OrderApi__Posting_Entity__c='Invoice';//‘Posting Entity’ equals to Invoice 
                            salesOrderValue.OrderApi__Schedule_Type__c='Simple Invoice';//‘Schedule Type’ equals to ‘Simple Invoice’ 
                            mapOfSalesOrder.put(salesOrderValue.Id,salesOrderValue);
                }
            }
        } 
        if(!mapOfSalesOrder.isEmpty()){
            update mapOfSalesOrder.values();
            system.debug('mapOfSalesOrder'+mapOfSalesOrder);
        }
        if(!mapOfSalesOrder.isEmpty()){
            for(Id ids: mapOfSalesOrder.keyset()){
                mapOfSalesOrder.get(ids).OrderApi__Status__c='Closed'; 
            }
            update mapOfSalesOrder.values();
             system.debug('mapOfSalesOrder1'+mapOfSalesOrder);
        }
       map<Id,OrderApi__Invoice__c> mapofInvoice=new map<Id,OrderApi__Invoice__c>([select id,Fon_Auto_Apply_Credit__c from OrderApi__Invoice__c where OrderApi__Sales_Order__c IN : mapOfSalesOrder.keyset()]);
        system.debug('mapofInvoice'+mapofInvoice);
        for(OrderApi__Invoice__c invoice : mapofInvoice.values()){
         invoice.Fon_Auto_Apply_Credit__c=true;   
        }
        if(!mapofInvoice.values().isEmpty()){
            update mapofInvoice.values();
        }
        return null;
    }
}