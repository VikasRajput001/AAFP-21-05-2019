public class Fon_UploadCSV {
    final static String strCancelled = 'Cancelled';
    final static String strExpired = 'Expired';
    @AuraEnabled
    public static Boolean updateRecords(String strMembershipStage) {
       System.debug('======================'+strMembershipStage);
       List<Fon_Membership_Staging__c> lstMemberShipStaging = (List<Fon_Membership_Staging__c>)JSON.deserialize(strMembershipStage, List<Fon_Membership_Staging__c>.class);
       
       System.debug('======================'+lstMemberShipStaging.size());
       return false;
    }
    
    @AuraEnabled
    public static Boolean csvFileUpdloader(String strCSVFile){
       System.debug('==========*****=========='+strCSVFile.length());
       List<Fon_Membership_Staging__c> lstChangeTypeMembershipStage = new List<Fon_Membership_Staging__c>();
       List<Fon_Membership_Staging__c> lstMembershipStage = new List<Fon_Membership_Staging__c>();
       Set<Id> contactIdSetOfFinancialMember = new Set<Id>();
       Set<Id> contactIdSetOfNonFinancialMember = new Set<Id>();
       Set<Id> expiredMemberByContactIdSet = new Set<Id>();
       
       List<String> lstRows = strCSVFile.split('\n');
       Map<Integer,String> mapKeyToHeaderName = fetchCSVHeaderMap(lstRows);
       for(Integer i = 1; i<lstRows.size(); i++){
            Fon_Membership_Staging__c objMembershipStage = new Fon_Membership_Staging__c();
            List<String> lstColumns = lstRows[i].split(',');
            for(Integer j = 0; j < lstColumns.size(); j++){
                if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Id'.toLowerCase()){
                    objMembershipStage.Id = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Name'.toLowerCase()){
                    objMembershipStage.Name = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Cancelled_Reason__c'.toLowerCase()){
                    objMembershipStage.Fon_Cancelled_Reason__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Chapter_Id__c'.toLowerCase()){
                    objMembershipStage.Fon_Chapter_Id__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Chapter_Join_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Chapter_Join_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Contact__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Contact__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_ContactID__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_ContactID__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Dues_Paid_by_Chapter__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Dues_Paid_by_Chapter__c = fetchNumericData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Dues_Paid_by_Residency_Program__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Dues_Paid_by_Residency_Program__c = fetchNumericData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Dues_Waived__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Dues_Waived__c = fetchBooleanData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Error_Reason__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Error_Reason__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Expiration_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Expiration_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Extended_Training_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Extended_Training_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Foundation_Contribution_Information__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Foundation_Contribution_Information__c = fetchNumericData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Foundation_Contribution_Information__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Foundation_Contribution_Information__c = fetchNumericData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Join_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Join_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Life_Approved_Flag__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Life_Approved_Flag__c = fetchBooleanData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Main_Membership__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Main_Membership__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Medical_School_Graduation_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Medical_School_Graduation_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Membership_Activation_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Membership_Activation_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Membership_Local__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Membership_Local__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Membership_State__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Membership_State__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Membership_Type__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Membership_Type__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Other_Price_Override__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Other_Price_Override__c = fetchNumericData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_PAC_Contribution_Account_Type__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_PAC_Contribution_Account_Type__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_PAC_Contribution_Employer__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_PAC_Contribution_Employer__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_PAC_Contribution_Information__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_PAC_Contribution_Information__c = fetchNumericData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_PAC_Contribution_Occupation__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_PAC_Contribution_Occupation__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Payment_Method_Id__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Payment_Method_Id__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Residency_Program_Graduation_Date__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Residency_Program_Graduation_Date__c = fetchDateData(lstColumns[j]);
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Residency_Training_Status__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Residency_Training_Status__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Staging_Status__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Staging_Status__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Subscription_Plan__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Subscription_Plan__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Year__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Year__c = lstColumns[j];
                }else if(mapKeyToHeaderName.get(j).trim().toLowerCase() == 'Fon_Is_Financial__c'.toLowerCase() && !String.isBlank(lstColumns[j])){
                    objMembershipStage.Fon_Is_Financial__c = fetchBooleanData(lstColumns[j]);
                }
            }
            if(objMembershipStage.Fon_Staging_Status__c == 'Cancelled'){
                if(objMembershipStage.Fon_Is_Financial__c){
                    contactIdSetOfFinancialMember.add(objMembershipStage.Fon_Contact__c);
                }else{
                    contactIdSetOfNonFinancialMember.add(objMembershipStage.Fon_Contact__c);
                }
                lstMembershipStage.add(objMembershipStage);
            }else if(objMembershipStage.Fon_Staging_Status__c == 'Expired'){
                lstMembershipStage.add(objMembershipStage);         // Changing Subscription Type
                expiredMemberByContactIdSet.add(objMembershipStage.Fon_Contact__c);
            }
       }
       Set<Id> cancellMemberContactIdSet = new Set<Id>();
       if(!contactIdSetOfFinancialMember.isEmpty()){
           cancellMemberContactIdSet.addAll(contactIdSetOfFinancialMember);
           List<OrderApi__Subscription__c> lstSubscription = Fon_CommonUtilityCtrl.fetchSubscriptionBycontactIdSet(contactIdSetOfFinancialMember);
           Fon_CommonUtilityCtrl.updatingInvoiceAndScheduledPayment(lstSubscription);
       }
       if(!contactIdSetOfNonFinancialMember.isEmpty()){
           cancellMemberContactIdSet.addAll(contactIdSetOfNonFinancialMember);
           List<OrderApi__Subscription__c> lstSubscription = Fon_CommonUtilityCtrl.fetchSubscriptionBycontactIdSet(contactIdSetOfNonFinancialMember);
           Fon_CommonUtilityCtrl.updateSubscription(lstSubscription, strCancelled);
       }
       if(!expiredMemberByContactIdSet.isEmpty()){
           List<OrderApi__Subscription__c> lstSubscription = Fon_CommonUtilityCtrl.fetchSubscriptionBycontactIdSet(expiredMemberByContactIdSet);
           Fon_CommonUtilityCtrl.updatingInvoiceAndScheduledPayment(lstSubscription);
           Fon_CommonUtilityCtrl.updateSubscription(lstSubscription, strExpired);
           Fon_CommonUtilityCtrl.updatingContactStatus(expiredMemberByContactIdSet, strExpired);
       }
       if(!cancellMemberContactIdSet.isEmpty()){
           Fon_CommonUtilityCtrl.updatingContactStatus(cancellMemberContactIdSet, strCancelled);
       }
       
       System.debug('==========*****=========='+lstMembershipStage[0].Id);
       System.debug('==========*****=========='+lstMembershipStage[0].Name);
       System.debug('==========*****=========='+lstMembershipStage[0].Fon_Dues_Waived__c);
       System.debug('==========*****=========='+lstMembershipStage[0].Fon_Dues_Paid_by_Residency_Program__c );
       System.debug('==========*****=========='+lstMembershipStage[0].Fon_Join_Date__c);
       System.debug('==========*****Cancell=========='+lstMembershipStage.size());
       System.debug('==========*****Expired=========='+lstChangeTypeMembershipStage.size());
       return false;
    }
    
    public static Map<Integer,String> fetchCSVHeaderMap(List<String> lstRows){
        Map<Integer,String> mapKeyToHeaderName = new Map<Integer,String>();
        List<String> lstColumns = lstRows[0].split(',');
        for(Integer i = 0; i<lstColumns.size(); i++){
            mapKeyToHeaderName.put(i,lstColumns[i]);
        }
        return mapKeyToHeaderName;
    }
    public static Date fetchDateData(String strDate){
        return Date.parse(strDate);
    }
    public static Boolean fetchBooleanData(String strBoolean){
        return Boolean.valueOf(strBoolean);
    }
    public static Decimal fetchNumericData(String strNumeric){
        return Decimal.valueOf(strNumeric);
    }
    
}