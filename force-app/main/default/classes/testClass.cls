public with sharing class testClass {
    
    
    @AuraEnabled
    public static List<Map<String,String>> getTabReports() {
        List<Map<String,String>> reports = new List<Map<String,String>>();
        try {
            Report[] tabularReports = [
                SELECT Id, DeveloperName, Name, FolderName,
                Format, Description
                FROM Report
                WHERE Format = 'Tabular'
                ORDER BY LastReferencedDate, FolderName, Name ASC
            ];
            for ( Report r : tabularReports ) {
                reports.add(new Map<String, String>{
                    'label' => r.Name, 'value' => r.Id, 'group' => 'report'
                        });
            }
        }
        catch (Exception e) {
            // throw LtngUtil.getException(e);
        }
        return reports;
    }
}