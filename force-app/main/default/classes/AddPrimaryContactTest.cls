@isTest
private class AddPrimaryContactTest {
    @isTest
    static void testAddPrimaryContact() {
        // Create 50 Accounts for NY and 50 for CA
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'NY Account ' + i, BillingState = 'NY'));
            accounts.add(new Account(Name = 'CA Account ' + i, BillingState = 'CA'));
        }
        insert accounts;

        // Create a Contact to be cloned
        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'johndoe@example.com');

        // Instantiate the Queueable class
        AddPrimaryContact job = new AddPrimaryContact(contact, 'CA');

        // Enqueue the job
        System.enqueueJob(job);

        // Verify that 50 Contacts were inserted for CA Accounts
        Test.startTest();
        Test.stopTest();

        // Assert that 50 Contacts have been created
        List<Contact> insertedContacts = [
            SELECT Id, AccountId 
            FROM Contact 
            WHERE Email = 'johndoe@example.com'
        ];
        System.assertEquals(50, insertedContacts.size());

        // Validate the Contacts are linked to CA Accounts
        Set<Id> caAccountIds = new Map<Id, Account>(
            [SELECT Id FROM Account WHERE BillingState = 'CA']
        ).keySet();

        for (Contact con : insertedContacts) {
            System.assert(caAccountIds.contains(con.AccountId), 
                'Contact is not linked to a CA Account');
        }
    }
}