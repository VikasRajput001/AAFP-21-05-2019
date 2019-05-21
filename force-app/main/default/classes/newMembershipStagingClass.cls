public class newMembershipStagingClass {
    //Create Membershipstaging Record
    public static void createMembershipStaging(list<Fon_Membership_Staging__c> listOfRecords){
        set<Id> setOfcontactId=new set<Id>();
        list<Fon_Membership_Staging__c> listofMembershipStaging=new  list<Fon_Membership_Staging__c>();
        for(Fon_Membership_Staging__c membership:listOfRecords){
            //setOfcontactId.add(membership.Fon_Contact__c);
            //membership.Fon_Staging_Status__c='Active';
        } 
       //Updating the old MembershipStaging status from active to inactive
        
        list<Fon_Membership_Staging__c> membershipList=[select id, name,Fon_Staging_Status__c from Fon_Membership_Staging__c where Fon_Contact__c in: setOfcontactId AND Fon_Staging_Status__c =:'Active'  ];
        if(membershipList.size()>0){
            for(Fon_Membership_Staging__c activeMember:membershipList){
                activeMember.Fon_Staging_Status__c='Inactive';
                listofMembershipStaging.add(activeMember);
            }
        }
        update  listofMembershipStaging;
        
    }
}