@IsTest 
public class Fon_ReceiptCreditMemoPageControllerTest{
    
    static testMethod void createCreditMemoMethod(){
        OrderApi__Receipt__c RECEIPT =new OrderApi__Receipt__c();
        RECEIPT.OrderApi__Type__c='Payment';
        RECEIPT.Is_Credit_Memo_Existed__c=true;
        insert RECEIPT;
        
        OrderApi__Receipt_Line__c receiptline=new OrderApi__Receipt_Line__c();
        receiptline.OrderApi__Receipt__c=RECEIPT.Id;
        insert receiptline;
        
        Test.startTest(); 
        Fon_ReceiptCreditMemoPageController.createCreditMemo(RECEIPT.Id);
        Fon_ReceiptCreditMemoPageController.fetchCreditMemoInstance(receiptline);
        Test.stopTest();         
    
    }

}