public class Fon_UploadCSV {
    @AuraEnabled
    public static Boolean updateRecords(List<Fon_Membership_Staging__c> msList) {
        List<Fon_Membership_Staging__c> membershipUpdateList = new  List<Fon_Membership_Staging__c>();
        system.debug('jmd msList-->'+msList);
        if(msList.size()>0){
            for(Fon_Membership_Staging__c obj :msList){
                system.debug('jmd id-->'+obj.Id);
                Fon_Membership_Staging__c ms =new Fon_Membership_Staging__c();
                ms.Id=obj.Id;
                ms.Fon_Staging_Status__c=obj.Fon_Staging_Status__c;
               ms.Fon_Cancelled_Reason__c=obj.Fon_Cancelled_Reason__c;
                
              
               // ms.Fon_Cancelled_Reason__c='final';
                membershipUpdateList.add(ms);
            }
            if(membershipUpdateList.size()>0){
                update membershipUpdateList;
                return true;
            }
        }
        return false;
    }
}