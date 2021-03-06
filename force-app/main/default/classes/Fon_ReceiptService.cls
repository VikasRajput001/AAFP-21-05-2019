public class Fon_ReceiptService {
    /* @@@TC-012644 
@Description: The Deposit Account on the Refund Receipt to the ‘Accounts Payable account’ on the Business Group that the receipt is related to.
*/
    
    public static void updateDepositeAccountBI(List<OrderApi__Receipt__c> newList){//Before Insert
        Framework.Log.push(Fon_ReceiptService.class.getName(),'updateDepositeAccountBI'); 
        if(newList.size()>0){
            Set<Id> BusinessGroupIds = new Set<Id>();
            Map<Id,Id> BusinessGroup_AccountsPayableAccount=new Map<Id,Id>();
            for(OrderApi__Receipt__c receipt:newList){
                BusinessGroupIds.add(receipt.OrderApi__Business_Group__c);
            }
            if(!BusinessGroupIds.isEmpty()){
                List<OrderApi__Business_Group__c> BGList=[select Accounts_Payable_Account__c from OrderApi__Business_Group__c where id in:BusinessGroupIds And Accounts_Payable_Account__c!=Null];
                if(BGList.size()>0){
                    for(OrderApi__Business_Group__c bg:BGList){
                        BusinessGroup_AccountsPayableAccount.put(bg.Id,bg.Accounts_Payable_Account__c);
                    }
                }
            }
            
            for(OrderApi__Receipt__c receipt:newList){
                if(receipt.OrderApi__Type__c=='Refund' && receipt.OrderApi__Payment_Type__c=='Check'){
                    if(!BusinessGroup_AccountsPayableAccount.isEmpty()){
                        if(BusinessGroup_AccountsPayableAccount.ContainsKey(receipt.OrderApi__Business_Group__c)){
                            receipt.OrderApi__Deposit_Account__c=BusinessGroup_AccountsPayableAccount.get(receipt.OrderApi__Business_Group__c);
                        }
                        else{
                            receipt.addError(Label.Fon_ReceiptErrorMessage);    
                        }
                    }
                    else{
                        receipt.addError(Label.Fon_ReceiptErrorMessage);    
                    }
                }
            }
        }
        Framework.Log.pop();
    }
  
}