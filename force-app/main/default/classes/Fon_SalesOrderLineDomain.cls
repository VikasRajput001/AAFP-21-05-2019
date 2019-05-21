/**
 *
 * Domain class for the Fon_SalesOrderLineDomain SObjectType
 *
 **/

global class Fon_SalesOrderLineDomain extends Framework.Domain{
    public Fon_SalesOrderLineDomain(List<OrderApi__Sales_Order_Line__c> sObjectList) {
        super(sObjectList);
    }

    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Fon_SalesOrderLineDomain(sObjectList);
        }
    }

    public override void afterInsert(){
        Framework.Log.push(Fon_SalesOrderLineDomain.class.getName(),'afterInsert'); 
        Fon_SalesOrderLineService.createSalesOrderLine((OrderApi__Sales_Order_Line__c[]) records); 
        Framework.Log.pop();
    }
}