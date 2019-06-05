@isTest
public class Fon_NewMembershipController_Test {
    static Account acct = new Account();
    static Contact con = new Contact();
    
    static testMethod void TestNewMembershipController() {
        acct = new Account();
        acct.Name = 'Test Account';
        insert acct;
        
        con = new Contact();
        con.LastName = 'LASTNAME';
        con.AccountId = acct.Id;
        con.Email ='testemail@testemail.com';
        con.MailingPostalCode = '22209';
        con.Fon_AAFP_ID__c= 111;
        con.Fon_Total_Months_of_Membership__c=10;
        con.Fon_Current_Membership_Status__c='Active';
        insert con;
        
        Fon_Membership_Staging__c memStag = new Fon_Membership_Staging__c(
        Fon_Membership_Activation_Date__c = System.today(),
        Fon_Chapter_Join_Date__c = System.today(),
        Fon_Dues_Paid_by_Chapter__c = 12,
        Fon_Dues_Paid_by_Residency_Program__c = 23,
        Fon_Join_Date__c = System.today(),
        Fon_Membership_State_Chapter__c = 'Virginia',
        Fon_Membership_Type__c = 'Resident',
        Fon_Staging_Status__c = 'New',
        Fon_Subscription_Plan__c = '1/1 – 12/31, single paymt',
        Fon_Contact__c = con.id);
        insert memStag;
        
        Fon_NewMembershipController.getForm(memStag.id, 'Fon_Membership_Staging__c', 'Fon_membership_staging_fs');
    }
}