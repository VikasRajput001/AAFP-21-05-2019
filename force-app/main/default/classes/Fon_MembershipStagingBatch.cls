global class Fon_MembershipStagingBatch implements Database.Batchable<sObject>, Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext BC) {
         return Database.getQueryLocator('SELECT Id,Fon_Staging_Status__c,Fon_Contact__c,Fon_Year__c,Fon_Membership_Activation_Date__c,Fon_PAC_Contribution_Information__c,'+
                                           'Fon_Membership_Type__c,Fon_Subscription_Plan__c,Fon_ContactID__c,Fon_Payment_Method_Id__c,Fon_Join_Date__c FROM Fon_Membership_Staging__c');
    }
    //Executing business logic here
    global void execute(Database.BatchableContext BC, List<Fon_Membership_Staging__c> lstMemberStage) {
        new Fon_MembershipStagingTriggerHandler().initializeMembershipStage(lstMemberStage);
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}