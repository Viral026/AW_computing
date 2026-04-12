public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numContacts, String lastName) {
        // Initialize the list to store the generated contacts
        List<Contact> contacts = new List<Contact>();
        
        // Loop through the specified number of contacts
        for (Integer i = 0; i < numContacts; i++) {
            // Create a new contact with a unique first name and the provided last name
            Contact newContact = new Contact(
                FirstName = 'Test ' + i,
                LastName = lastName
            );
            // Add the contact to the list
            contacts.add(newContact);
        }
        
        // Return the generated list of contacts
        return contacts;
    }
}