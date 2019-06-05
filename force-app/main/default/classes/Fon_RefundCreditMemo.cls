public class Fon_RefundCreditMemo {
    public String creditMemoId;
    public List<OrderApi__Credit_Memo__c> creditMemoRecord = new List<OrderApi__Credit_Memo__c>();
    public List<OrderApi__Transaction__c> existingTransactionList= [select id from OrderApi__Transaction__c];
    Set<Id> existingTransactionIds = new Set<Id>();
    List<OrderApi__Item__c> creditMemoRefundItem = new List<OrderApi__Item__c>();
    
    
    
    public Fon_RefundCreditMemo(ApexPages.StandardController controller){
        creditMemoRefundItem= [select id from OrderApi__Item__c where Name='Credit Memo Refund Item' And OrderApi__Is_Active__c=true];
        creditMemoId=controller.getId();//Current Record Id
        if(String.isNotBlank(creditMemoId)){
            creditMemoRecord=[select OrderApi__Remaining_Amount__c,
                              Fon_Receipt_Line__r.OrderApi__GL_Account__c,
                              Fon_Receipt__r.OrderApi__Contact__c,
                              Fon_Receipt__r.OrderApi__Account__c,
                              Fon_Receipt__r.OrderApi__Business_Group__c
                              from OrderApi__Credit_Memo__c where Fon_Receipt__c!=Null And Id=:creditMemoId];
            existingTransactionList=[select id from OrderApi__Transaction__c where OrderApi__Credit_Memo__c=:creditMemoId];
            if(existingTransactionList.size()>0){
                existingTransactionIds=(new Map<Id,OrderApi__Transaction__c>(existingTransactionList)).keySet();
            }
        }
    }
    
    public PageReference createCreditMemoline(){
        Id newReceiptId;
        if(creditMemoRecord.size()>0){
            //Creating Credit Memo line
            OrderApi__Credit_Memo_Line__c cml = new OrderApi__Credit_Memo_Line__c();
            cml.OrderApi__Credit_Memo__c=creditMemoId;//Create credit Memo line will be created under the Credit Memo 
            cml.OrderApi__Amount__c=creditMemoRecord[0].OrderApi__Remaining_Amount__c;//Amount same as the remaining amount on the Credit Memo
            if(creditMemoRecord[0].Fon_Receipt_Line__r.OrderApi__GL_Account__c!=null){
                cml.OrderApi__Credit_Account__c=creditMemoRecord[0].Fon_Receipt_Line__r.OrderApi__GL_Account__c; //Liability Account as one of GL Account on the receipt lines
            }
            cml.OrderApi__Status__c='Posted';//The Credit Memo line will be posted 
            Insert cml;
            
            //The transactions created as a result of posting will be deleted
            List<OrderApi__Transaction__c> trans= [select id from OrderApi__Transaction__c where Id Not in :existingTransactionIds And OrderApi__Credit_Memo__c=:creditMemoId];
            if(trans.size()>0){
                system.debug('jmd trans-->'+trans.size());
                Delete trans;
            }
            //A new Refund receipt will be created from this receipt
            newReceiptId=createRefundReceipt();            
        }
        PageReference pr;
        if(newReceiptId!=Null){
            pr= new PageReference('/'+newReceiptId);
        }
        else{
            pr= new PageReference('/'+creditMemoId);
        }
        
        pr.setRedirect(true);
        return pr;
    }
    
    public Id createRefundReceipt(){
        OrderApi__Receipt__c receipt = new OrderApi__Receipt__c();
        receipt.OrderApi__Type__c='Refund';
        receipt.OrderApi__Contact__c=creditMemoRecord[0].Fon_Receipt__r.OrderApi__Contact__c;
        receipt.OrderApi__Account__c=creditMemoRecord[0].Fon_Receipt__r.OrderApi__Account__c;
        receipt.OrderApi__Business_Group__c=creditMemoRecord[0].Fon_Receipt__r.OrderApi__Business_Group__c;
        receipt.OrderApi__Memo__c='CreditMemo Refunded';//The Memo field on the receipt will be populated as ‘Credit Memo Refunded’
        receipt.Fon_Credit_Memo__c=creditMemoId;
        insert receipt;
        
        receipt.OrderApi__Is_Posted__c=true;//The Receipt will be posted
        update receipt;
        
        //A new Receipt line will be created under the Receipt 
        OrderApi__Receipt_Line__c rl= new OrderApi__Receipt_Line__c();
        rl.OrderApi__Receipt__c=receipt.Id;
        rl.OrderApi__Item__c=creditMemoRefundItem[0].Id;//the lookup to the ‘Credit Memo Refund Item’ on the Item field
        insert rl;
        
       // updateTransaction(receipt.Id,creditMemoId);
        
        return receipt.Id;
    }
    
  /*  @future
    public static void updateTransaction(Id receiptId,Id creditMemoId){
        //Once all the transactions are created as a result of posting the Receipt the lookup field ‘Credit Memo’ will be updated
        //on all the Transactions with the Credit Memo found and modified.
        List<OrderApi__Transaction__c> receiprTransactions= [select OrderApi__Credit_Memo__c from OrderApi__Transaction__c where OrderApi__Receipt__c=:receiptId];
        system.debug('jmd receiprTransactions-->'+receiprTransactions.size());
        if(receiprTransactions.size()>0){
            for(OrderApi__Transaction__c trns:receiprTransactions){
                trns.OrderApi__Credit_Memo__c=creditMemoId;
            }
            update receiprTransactions;
        }
    }*/
}