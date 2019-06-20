trigger Fon_MembershipStagingTrigger on Fon_Membership_Staging__c (after insert, after update) {
   // if(trigger.isInsert && trigger.isBefore){ 
   //  newMembershipStagingClass.createMembershipStaging(trigger.new); Old code
   // }
   
   if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
       Set<Id> memberStageIdSet = new Set<Id>();
       for(Fon_Membership_Staging__c eachMember : (List<Fon_Membership_Staging__c>)Trigger.new){
           memberStageIdSet.add(eachMember.Id);
       }
       if(!memberStageIdSet.isEmpty()){
           Fon_MembershipStagingBatch bachable = new Fon_MembershipStagingBatch(memberStageIdSet);
           Database.executeBatch(bachable);
       }
   }
}