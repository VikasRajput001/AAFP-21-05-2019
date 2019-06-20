public class SampleTestClassForFdService {
    
    //public class OrderSummaryRawData {
    // public List<OrderApi__Sales_Order__c> orders = new List<OrderApi__Sales_Order__c>();
    // }
    public static List<FDService.SalesOrder> getAllItems() {
        list<string> mulfields=new list<String>{'Fon_Process_Payment__c','Name'};
            
            //return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance());//return all fields of salesorder
            //return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().fields('Name')); //return id with its name 
            return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().fields(mulfields));
    }
    
    public static List<FDService.SalesOrder> getSingleItemById(Id soId) {  //(set<Id> soId)
        
        return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().selectById(soId)
                                                        
                                                       );
        
    }
    public static List<FDService.SalesOrder> filterItem(Id itemId) {
        return FDService.OrderService.getInstance().get(FDService.SearchRequest.getInstance().filter('OrderApi__Is_Active__c = true AND Id IN itemId')
                                                        
                                                        //new List<Object>{true,new List<String>{itemId}})
                                                        // new List<Object>{true,itemId})
                                                        
                                                       );
        
    }
    public static List<FDService.Item> filterItem1(Id itemId) {
        
        return FDService.ItemService.getInstance().get( FDService.SearchRequest.getInstance().filter('OrderApi__Is_Active__c = true ')
                                                      );
        
    }
    public static List<FDService.Item> filterItem2() {
        return FDService.ItemService.getInstance().get( FDService.SearchRequest.getInstance().filter('OrderApi__Item_Class__r.Fon_Is_Main_Membership__c = {0}',
                                                                                                     
                                                                                                     new List<Object>{true})
                                                       
                                                      );
        
    } 
    public static List<FDService.Item> filterItem3() {
        return FDService.ItemService.getInstance().get(FDService.SearchRequest.getInstance().filter('Fon_Is_PAC_Item__c = true')
                                                       
                                                      );
    } 
    public static List<OrderApi__Sales_Order__c> filterItem4() {
        List<Id> orderLines = new List<Id>();
        //OrderSummaryRawData returnModel = new OrderSummaryRawData();
        List<OrderApi__Sales_Order__c>   orders  = (List<OrderApi__Sales_Order__c>)FDService.SearchRequest.getInstance()
            .fields('Name,OrderApi__Due_Date__c,OrderApi__Total__c')
            .additionalFields('(SELECT Id,Name FROM OrderApi__Sales_Order_Lines__r)')
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
    
   // ***********************************************************************
    public static List<OrderApi__Sales_Order__c> filterItem5() {
        List<Id> orderLines = new List<Id>();
        
        List<OrderApi__Sales_Order__c> orders  = (List<OrderApi__Sales_Order__c>)FDService.SearchRequest.getInstance()
            .fields('id,Name,OrderApi__Contact__c,OrderApi__Status__c,OrderApi__Posting_Entity__c,OrderApi__Schedule_Type__c')
            .additionalFields('(select id,OrderApi__Sales_Order__c from OrderApi__Sales_Order_Lines__r where OrderApi__Item__r.OrderApi__Is_Subscription__c=true  AND OrderApi__Subscription_Plan__r.OrderApi__Enable_Schedule__c=false)')
            .filter('OrderApi__Is_Posted__c= {0} And Fon_Auto_Apply_Credit__c= {1} And OrderApi__Posting_Entity__c = {2} And OrderApi__Status__c={3}',new List<Object>{false,true,'Receipt','Closed'})
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

    public static List<OrderApi__Credit_Memo__c> filterItem6(Id contactIds) {  //(set<Id> soId)
        List<OrderApi__Credit_Memo__c> CM  = (List<OrderApi__Credit_Memo__c>)FDService.SearchRequest.getInstance()
            .fields('id,OrderApi__Contact__c')
            .filter('Fon_Suggested_Usage__c= {0} And Fon_Required__c= {1} And OrderApi__Contact__c  IN ({2})',new List<Object>{'Memberships',true, contactIds})
            .executeQuery(OrderApi__Credit_Memo__c.SObjectType);
          system.debug(' cm'+ CM);
        return null;
   
    }

    public static List<FDService.SalesOrderLine> filterItem7(Id soId) {  //(set<Id> soId)
        
        return FDService.SalesOrderLineService.getInstance().get(FDService.SearchRequest.getInstance().selectById(soId)
                                                                 
                                                                );
        
    }
  
    
}