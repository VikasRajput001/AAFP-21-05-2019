public class sampleforFdClass {
    public static Set<Id> recordIds = new Set<Id>();
    public class OrderSummaryRawData {
        public List<OrderApi__Invoice__c> invoices = new List<OrderApi__Invoice__c>();
        public List<OrderApi__Sales_Order__c> orders = new List<OrderApi__Sales_Order__c>();
        public List<FDService.ReceiptLine> receiptLines = new List<FDService.ReceiptLine>();
    }

   public static OrderSummaryRawData getOrderSummaryRawData (OrderSummary os){
        OrderSummaryRawData returnModel = new OrderSummaryRawData();
        Boolean pullReceipts = false;
        List<Id> orderLines = new List<Id>();
        if (os.orders != null && !os.orders.isEmpty()) {
            returnModel.orders = (List<OrderApi__Sales_Order__c>)FDService.SearchRequest.getInstance()
                    .fields('Name,OrderApi__Due_Date__c,OrderApi__Total__c  ')
                    .additionalFields('(SELECT Id FROM OrderApi__Sales_Order_Lines__r)')
                    .selectById(os.orders)
                    .executeQuery(OrderApi__Sales_Order__c.SObjectType);
                 system.debug(' returnModel.orders'+ returnModel.orders);
            for (OrderApi__Sales_Order__c so : returnModel.orders) {
                if (so.OrderApi__Sales_Order_Lines__r != null && !so.OrderApi__Sales_Order_Lines__r.isEmpty()) {
                    for (OrderApi__Sales_Order_Line__c sol : so.OrderApi__Sales_Order_Lines__r) {
                        orderLines.add(sol.Id);
                        pullReceipts = true;
                         system.debug(' orderLines'+ returnModel.orders);
                    }
                }
                recordIds.add(so.Id);
            }
        }
  
        if (pullReceipts) {
            String filter;
            List<Object> filterCriteria = new List<Object>();
            if (os.invoices != null && !os.invoices.isEmpty()) {
                filter = 'OrderApi__Invoice__c IN ({0})';
                filterCriteria.add(os.invoices);
            }
            if (orderLines.size() > 0) {
                if (String.isNotEmpty(filter)) {
                    filter += ' OR OrderApi__Sales_Order_Line__c IN ({1})';
                }
                else {
                    filter = 'OrderApi__Sales_Order_Line__c IN ({0})';
                }
                filterCriteria.add(orderLines);
            }

            returnModel.receiptLines = (List<FDService.ReceiptLine>) FDService.ReceiptLineService.getInstance().get(FDService.SearchRequest.getInstance()
                    .fields('OrderApi__Total__c,OrderApi__Receipt__c')
                    .additionalFields('OrderApi__Receipt__r.Id, OrderApi__Receipt__r.Name, OrderApi__Receipt__r.OrderApi__Date__c, OrderApi__Receipt__r.OrderApi__Is_Refund__c, ' +
                            'OrderApi__Sales_Order_Line__c, OrderApi__Invoice_Line__c, OrderApi__Sales_Order_Line__r.OrderApi__Sales_Order__c, OrderApi__Invoice_Line__r.OrderApi__Invoice__c')
                    .filter(filter,filterCriteria));
        }
        return returnModel;
    }

}