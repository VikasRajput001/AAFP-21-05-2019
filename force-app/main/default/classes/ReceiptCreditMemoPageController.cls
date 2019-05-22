public with sharing class ReceiptCreditMemoPageController{

    @AuraEnabled
    public static void createCreditMemo(String receiptId){
        List<OrderApi__Credit_Memo__c> lstCreditMemorecord = new List<OrderApi__Credit_Memo__c>();
        //=OrderApi__Receipt__c receipt = (OrderApi__Receipt__c) new Framework.Selector(OrderApi__Receipt__c.SObjectType).selectById(Id.valueOf(receiptId));
        OrderApi__Receipt__c objReceipt = [SELECT Id,OrderApi__Deposit_Account__c,OrderApi__Memo__c,OrderApi__Is_Posted__c,
                                            OrderApi__Business_Group__r.OrderApi__Credit_Memo_Account__c,
                                            (SELECT Id,OrderApi__Receipt__r.OrderApi__Deposit_Account__c,OrderApi__Receipt__c 
                                                FROM OrderApi__Receipt_Lines__r) FROM OrderApi__Receipt__c WHERE Id =:receiptId];
        
        //=List<OrderApi__Receipt_Line__c> lstReceiptLine = (List<OrderApi__Receipt_Line__c>)new Framework.Selector(OrderApi__Receipt_Line__c.SObjectType).selectById(new Set<Id>{receipt.Id},'OrderApi__Receipt__c');
        //System.debug('========'+lstReceiptLine);
        
        //=List<OrderApi__Receipt_Line__c> lstReceiptLine = [SELECT Id,OrderApi__Receipt__r.OrderApi__Deposit_Account__c,OrderApi__Receipt__c FROM OrderApi__Receipt_Line__c WHERE OrderApi__Receipt__c =:receipt.Id];
        
        for(OrderApi__Receipt_Line__c objReceiptLine : objReceipt.OrderApi__Receipt_Lines__r){
            lstCreditMemorecord.add(fetchCreditMemoInstance(objReceiptLine));
        }
        if(!lstCreditMemorecord.isEmpty()){
            //insert lstCreditMemorecord;
            objReceipt.OrderApi__Deposit_Account__c = objReceipt.OrderApi__Business_Group__r.OrderApi__Credit_Memo_Account__c;
            objReceipt.OrderApi__Memo__c = 'Credit Memo created from Receipt';
            objReceipt.OrderApi__Is_Posted__c = true;
            update objReceipt; 
        }
        //OrderApi__Receipt__c objR = null;
        //Id objId = objR.Id;
    }
    
    public static OrderApi__Credit_Memo__c fetchCreditMemoInstance(OrderApi__Receipt_Line__c objReceiptLineARG){
        OrderApi__Credit_Memo__c objCreditMemo = new OrderApi__Credit_Memo__c();
        objCreditMemo.OrderApi__Debit_Account__c = objReceiptLineARG.OrderApi__Receipt__r.OrderApi__Deposit_Account__c;
        //objCreditMemo.        Credit Memo Account
        objCreditMemo.OrderApi__Posted_Date__c = Date.today();
        objCreditMemo.Fon_Receipt_Line__c = objReceiptLineARG.Id;
        objCreditMemo.Fon_Receipt__c = objReceiptLineARG.OrderApi__Receipt__c;
        objCreditMemo.OrderApi__Status__c = 'Posted';
        //objCreditMemo.
        
        return objCreditMemo;
    }

}