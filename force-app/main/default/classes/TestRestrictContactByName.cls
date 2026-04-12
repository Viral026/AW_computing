@IsTest
public class TestRestrictContactByName {
    @IsTest
    static void testTrigger_BlockInvalidLastNameOnInsert() {
        // Test case to verify the trigger blocks insert for invalid last name
        Contact invalidContact = new Contact(FirstName = 'John', LastName = 'INVALIDNAME');
        
        // Verify that the trigger prevents insertion
        try {
            insert invalidContact;
            System.assert(false, 'Expected an exception, but none was thrown.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed for DML'),
                'Exception message does not match expected.');
        }
    }

    @IsTest
    static void testTrigger_BlockInvalidLastNameOnUpdate() {
        // Insert a valid contact
        Contact validContact = new Contact(FirstName = 'Jane', LastName = 'Doe');
        insert validContact;

        // Attempt to update the contact with an invalid last name
        validContact.LastName = 'INVALIDNAME';
        try {
            update validContact;
            System.assert(false, 'Expected an exception, but none was thrown.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed for DML'),
                'Exception message does not match expected.');
        }
    }

    @IsTest
    static void testTrigger_AllowValidNames() {
        // Test case to ensure valid last names are allowed
        Contact validContact = new Contact(FirstName = 'Alice', LastName = 'Smith');
        
        // Insert the contact with a valid last name
        insert validContact;
        
        // Verify that the contact was inserted
        Contact insertedContact = [SELECT Id, LastName FROM Contact WHERE Id = :validContact.Id];
        System.assertEquals('Smith', insertedContact.LastName, 'The contact should have been inserted with the valid last name.');
        
        // Update the contact with another valid last name
        validContact.LastName = 'Johnson';
        update validContact;

        // Verify that the contact was updated
        Contact updatedContact = [SELECT Id, LastName FROM Contact WHERE Id = :validContact.Id];
        System.assertEquals('Johnson', updatedContact.LastName, 'The contact should have been updated with the valid last name.');
    }
}