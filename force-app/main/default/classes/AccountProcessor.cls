public class AccountProcessor {
    @future
    public static void processAccounts(Set<Id> accountIds) {
        // Fetch accounts in bulk
        List<Account> accountsToUpdate = [SELECT Id, Type FROM Account WHERE Id IN :accountIds];
        
        List<Account> accountsToUpdateList = new List<Account>();
        List<Processing_Log__c> logs = new List<Processing_Log__c>();
        
        for (Account acc : accountsToUpdate) {
            acc.Type = 'Prospect'; // Update the Type field
            accountsToUpdateList.add(acc);
            
            // Create a log entry
            logs.add(new Processing_Log__c(
                Account_ID__c = acc.Id,
                Log_Message__c = 'Account Type updated to Prospect via Future Method'
            ));
        }
        
        // Perform DML operations
        if (!accountsToUpdateList.isEmpty()) {
            update accountsToUpdateList;
        }
        
        if (!logs.isEmpty()) {
            insert logs;
        }
    }
}