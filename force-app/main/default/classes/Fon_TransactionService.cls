public class Fon_TransactionService {
    public static void updateCreditMemoOnTransaction(LIst<OrderApi__Transaction__c> newList){
        Framework.Log.push(Fon_SalesOrderLineService.class.getName(),'createSalesOrderLine');
        if(newList.size()>0){
            Set<Id> receiptIds= new Set<Id>();
            Map<Id,Id> receiptVScreditMemo = new Map<Id,Id>();
            for(OrderApi__Transaction__c trsns:newList){
                if(trsns.OrderApi__Receipt__c!=Null){
                    receiptIds.add(trsns.OrderApi__Receipt__c);
                }
            }
            if(!receiptIds.isEmpty()){
                List<OrderApi__Receipt__c> receiptList=[select Fon_Credit_Memo__c from OrderApi__Receipt__c where Fon_Credit_Memo__c!=Null];
                if(receiptList.size()>0){
                    for(OrderApi__Receipt__c receipt:receiptList){
                        receiptVScreditMemo.put(receipt.Id,receipt.Fon_Credit_Memo__c);
                    }
                }
            }
            if(!receiptVScreditMemo.isEmpty()){
                for(OrderApi__Transaction__c trsns:newList){
                    if(trsns.OrderApi__Receipt__c!=Null){
                        trsns.OrderApi__Credit_Memo__c=receiptVScreditMemo.get(trsns.OrderApi__Receipt__c);
                    }
                } 
            }
        }
        Framework.Log.pop();
    }
}