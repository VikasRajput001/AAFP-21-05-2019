//For testing purpose
public class RSI_FD_SERVICE {
    
    //Issue -  SOQL on sales order line ---- Arpita Solution- List<FDService.SalesOrderLine> sols = FDService.SalesOrderLineService.getInstance().get(FDService.SearchRequest.getInstance());
    //Issue - not able to get related record fields --- Arpita SOLution - (List<OrderApi__Sales_Order__c>)FDService.SearchRequest.getInstance()
       //             .fields('Name,OrderApi__Due_Date__c,OrderApi__Total__c  ')
       //             .additionalFields('(SELECT Id FROM OrderApi__Sales_Order_Lines__r)')
        //            .selectById(os.orders)
         //           .executeQuery(OrderApi__Sales_Order__c.SObjectType);
//Check StatementInvoiceController.cls 


    // default LIMIT 2000
    public RSI_FD_SERVICE(){       
        //List<FDService.SalesOrder> soList = getAllItems();
       
        
       // List<String> lstItemName = new List<String>{'AAFP Foundation Voluntary Contribution' , 'RSI Keyboard'};
        //List<FDService.Item> itmList= filterItem(lstItemName);
         //List<FDService.Item> itmList= customfilterItem();
       //  List<FDService.Item> itmList= customfilterItem1();
        
        
       // system.debug('jmd itm size-->'+itmList.size());
       // for(FDService.Item itm : itmList){
       //     system.debug('jmd itm-->'+itm.name);
       // }
        
    }
    
    //SOQL on Sales Order Object
    //It will return all records with all field
    public static List<FDService.SalesOrder> getAllItems() {
        List<String> fields = new List<String>{'OrderApi__Calculate_Billing_Details__c','Name','Fon_Process_Payment__c'};
            //return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance());   //All fields
            //return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().fields('OrderApi__Calculate_Billing_Details__c')); //Single Field
            //return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().fields(fields)); //Multiple Fields
            
            //For Related field 
           return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().additionalFields('OrderApi__Contact__r.Name,OrderApi__Contact__r.LastName')); 
        
      //  (List<OrderApi__Sales_Order__c>)FDService.SearchRequest.getInstance().fields('Name,OrderApi__Due_Date__c,OrderApi__Total__c ').additionalFields('(SELECT Id FROM OrderApi__Sales_Order_Lines__r)')                    .selectById(os.orders)
               //     .executeQuery(OrderApi__Sales_Order__c.SObjectType);
    }
    
    //SOQL on Sales Order Line Object
    public static List<FDService.SalesOrderLine> getAllItems1() {
        List<FDService.SalesOrderLine> sols = FDService.SalesOrderLineService.getInstance().get(FDService.SearchRequest.getInstance());
        return sols;
    }
    
    //Vikas Query  
    public static List<FDService.Item> filterItem(List<String> lstItemName) {
        return FDService.ItemService.getInstance().get(
            FDService.SearchRequest.getInstance().filter('Name IN ({0})', new List<Object>{lstItemName})
        );
    }  
    
    public static List<FDService.Item> customfilterItem() {
        return FDService.ItemService.getInstance().get(
            FDService.SearchRequest.getInstance().filter('Fon_Is_PAC_Item__c = true')
        );
    }  
    
    public static List<FDService.Item> customfilterItem1() {
        return FDService.ItemService.getInstance().get(
            FDService.SearchRequest.getInstance().filter('OrderApi__Item_Class__r.Fon_Is_Main_Membership__c = true')
        );
    } 
    public static List<OrderApi__Sales_Order__c> filterItem5() {
        List<Id> orderLines = new List<Id>();
        List<OrderApi__Sales_Order__c> orders  = (List<OrderApi__Sales_Order__c>)FDService.SearchRequest.getInstance()
            .fields('id,Name,OrderApi__Contact__c,OrderApi__Status__c,OrderApi__Posting_Entity__c,OrderApi__Schedule_Type__c')
            .additionalFields('(select id,OrderApi__Sales_Order__c from OrderApi__Sales_Order_Lines__r where OrderApi__Item__r.OrderApi__Is_Subscription__c=true  AND OrderApi__Subscription_Plan__r.OrderApi__Enable_Schedule__c=false)')
            .filter('OrderApi__Is_Posted__c= {0} And Fon_Auto_Apply_Credit__c= {1} And OrderApi__Posting_Entity__c = {2}',new List<Object>{false,true,'Receipt'})
            .executeQuery(OrderApi__Sales_Order__c.SObjectType);
        // system.debug('@@@'+ returnModel.orders);
        system.debug('@@@'+ orders);
        for (OrderApi__Sales_Order__c so : orders) {
            if (so.OrderApi__Sales_Order_Lines__r != null && !so.OrderApi__Sales_Order_Lines__r.isEmpty()) {
                for (OrderApi__Sales_Order_Line__c sol : so.OrderApi__Sales_Order_Lines__r) {
                    orderLines.add(sol.Id);
                    
                    system.debug(' orderLines'+ orderLines);
                }
            }
            
        }
        return null;
        
    }
}