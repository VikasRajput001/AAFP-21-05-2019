public without sharing class Fon_CustomPaymentMethodCtrl{

    @AuraEnabled
    public static String getContactInfo() {
        
        try {
            user u = [SELECT ContactId,Id FROM User where id = : userinfo.getuserid()];
            if(u !=null){
                return u.contactid;
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage()+e.getStackTraceString());
        }
        return null; 
    }
    
    @AuraEnabled
    public static String getTokenInfo() {
        
        try {
            if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox == true){
                OrderApi__Payment_Gateway__c pg = [SELECT Id, OrderApi__Token__c FROM OrderApi__Payment_Gateway__c WHERE OrderApi__Is_Test__c = True limit 1];
                if(pg !=null){
                    return pg.OrderApi__Token__c ;
                }
            } else{
                OrderApi__Payment_Gateway__c pg = [SELECT Id, OrderApi__Token__c FROM OrderApi__Payment_Gateway__c WHERE OrderApi__Is_Test__c = False AND OrderApi__Is_Enabled__c = true limit 1];
                if(pg !=null){
                    return pg.OrderApi__Token__c ;
                }
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage()+e.getStackTraceString());
        }
        return null; 
    }
    
    @AuraEnabled
    public static String getPaymentMethod() {
        
        try {
            user u = [SELECT ContactId,Id FROM User where id = : userinfo.getuserid()];
            if(u !=null){
                OrderApi__Payment_Method__c pm = [SELECT Id, Name FROM OrderApi__Payment_Method__c WHERE OrderApi__Contact__c =: u.contactid ORDER BY CreatedDate DESC LIMIT 1];
                if(pm !=null){
                    return pm.Name;
                }
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage()+e.getStackTraceString());
        }
        return null; 
    }
}