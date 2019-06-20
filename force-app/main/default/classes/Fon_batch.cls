public class Fon_batch {
    Set<String> salesOrderIds;//Contains ids of salesorder from url
    
    public PageReference process(){
        String soIds = apexpages.currentpage().getparameters().get('soIds');
        if(String.isNotBlank(soIds)){
            List<String> splitSalesOrderIds = soIds.split(',');
            salesOrderIds = new Set<String>(splitSalesOrderIds);
        }
        if(!salesOrderIds.isEmpty()){
            String newBatchRecordId = createBatchRecord(system.today());
            Database.executeBatch(new Fon_UpdateInvoiceBatch(salesOrderIds,newBatchRecordId),1);
        }
      
        PageReference pr = new PageReference('https://aafp--fontevadev.cs11.my.salesforce.com/a1F');
        return pr;
    }
    
    public String createBatchRecord(Date currentDate){
        OrderApi__Batch__c newBatch = new OrderApi__Batch__c();
        newBatch.Name='AutoAppliedCreditMemoBatch-'+currentDate;
        newBatch.OrderApi__Expected_Count__c=1;
        newBatch.OrderApi__Expected_Amount__c=1;
        insert newBatch;
        return newBatch.Id;
    }
}