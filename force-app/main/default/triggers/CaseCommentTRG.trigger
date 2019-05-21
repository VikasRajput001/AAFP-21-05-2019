trigger CaseCommentTRG on CaseComment (before insert,before update) {
    
    for(CaseComment obj : (List<CaseComment>)Trigger.new){
        System.debug('===================='+obj.getQuickActionName());
    }
}