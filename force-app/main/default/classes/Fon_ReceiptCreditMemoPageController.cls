public with sharing class Fon_ReceiptCreditMemoPageController{

    @AuraEnabled
    public static OrderApi__Receipt__c createCreditMemo(String receiptId){
        List<OrderApi__Credit_Memo__c> lstCreditMemorecord = new List<OrderApi__Credit_Memo__c>();
        OrderApi__Receipt__c objReceipt = [SELECT Id,OrderApi__Deposit_Account__c,OrderApi__Memo__c,OrderApi__Is_Posted__c,
                                            OrderApi__Business_Group__r.OrderApi__Credit_Memo_Account__c,OrderApi__Type__c,Is_Credit_Memo_Existed__c,
                                            (SELECT Id,OrderApi__Receipt__r.OrderApi__Deposit_Account__c,OrderApi__Receipt__c,
                                                 OrderApi__Receipt__r.OrderApi__Business_Group__r.OrderApi__Credit_Memo_Account__c 
                                                    FROM OrderApi__Receipt_Lines__r) FROM OrderApi__Receipt__c WHERE Id =:receiptId];
        for(OrderApi__Receipt_Line__c objReceiptLine : objReceipt.OrderApi__Receipt_Lines__r){
            lstCreditMemorecord.add(fetchCreditMemoInstance(objReceiptLine));
        }
        if(!lstCreditMemorecord.isEmpty()){
            insert lstCreditMemorecord;
            objReceipt.OrderApi__Deposit_Account__c = objReceipt.OrderApi__Business_Group__r.OrderApi__Credit_Memo_Account__c;
            objReceipt.OrderApi__Memo__c = 'Credit Memo created from Receipt';
            objReceipt.OrderApi__Is_Posted__c = true;
            update objReceipt; 
        }
        //OrderApi__Receipt__c objR = null;
        //Id objId = objR.Id;
        return objReceipt;
    }
    
    public static OrderApi__Credit_Memo__c fetchCreditMemoInstance(OrderApi__Receipt_Line__c objReceiptLineARG){
        OrderApi__Credit_Memo__c objCreditMemo = new OrderApi__Credit_Memo__c();
        objCreditMemo.OrderApi__Debit_Account__c = (objReceiptLineARG.OrderApi__Receipt__r != null) ? objReceiptLineARG.OrderApi__Receipt__r.OrderApi__Deposit_Account__c : null;
        objCreditMemo.Fon_Credit_Memo_Account__c = (objReceiptLineARG.OrderApi__Receipt__r != null) ? ((objReceiptLineARG.OrderApi__Receipt__r.OrderApi__Business_Group__r != null) ? 
                                                        objReceiptLineARG.OrderApi__Receipt__r.OrderApi__Business_Group__r.OrderApi__Credit_Memo_Account__c : null) : null;
        objCreditMemo.OrderApi__Posted_Date__c = Date.today();
        objCreditMemo.Fon_Receipt_Line__c = objReceiptLineARG.Id;
        objCreditMemo.Fon_Receipt__c = objReceiptLineARG.OrderApi__Receipt__c;
        objCreditMemo.OrderApi__Status__c = 'Posted';
        return objCreditMemo;
    }

}