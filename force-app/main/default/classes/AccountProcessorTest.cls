@isTest
public class AccountProcessorTest {
    @isTest
    static void testProcessAccounts() {
        // Create test data
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
        
        // Collect IDs to pass to the future method
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }
        
        // Call the future method
        Test.startTest();
        AccountProcessor.processAccounts(accountIds);
        Test.stopTest();
        
        // Verify Account updates
        List<Account> updatedAccounts = [SELECT Id, Type FROM Account WHERE Id IN :accountIds];
        for (Account acc : updatedAccounts) {
            System.assertEquals('Prospect', acc.Type, 'Account Type should be updated to Prospect');
        }
        
        // Verify Processing Log entries
        List<Processing_Log__c> logs = [SELECT Account_ID__c, Log_Message__c FROM Processing_Log__c WHERE Account_ID__c IN :accountIds];
        System.assertEquals(10, logs.size(), 'There should be 10 log entries for the processed accounts');
    }
}