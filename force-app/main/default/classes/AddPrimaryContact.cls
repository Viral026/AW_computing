public class AddPrimaryContact implements Queueable {
    private Contact contactToInsert;
    private String stateAbbreviation;

    // Constructor
    public AddPrimaryContact(Contact contactToInsert, String stateAbbreviation) {
        this.contactToInsert = contactToInsert;
        this.stateAbbreviation = stateAbbreviation;
    }

    // Execute method
    public void execute(QueueableContext context) {
        // Query for a maximum of 200 Accounts based on BillingState
        List<Account> accounts = [
            SELECT Id 
            FROM Account 
            WHERE BillingState = :stateAbbreviation 
            LIMIT 200
        ];

        // Prepare a list of Contacts to insert
        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : accounts) {
            Contact newContact = contactToInsert.clone(false, true, false);
            newContact.AccountId = acc.Id;
            contactsToInsert.add(newContact);
        }

        // Insert the Contacts
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}