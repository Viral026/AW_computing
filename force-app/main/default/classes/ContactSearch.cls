public class ContactSearch {
    /**
     * Method to search for contacts based on last name and mailing postal code.
     *
     * @param lastName The last name to match.
     * @param postalCode The mailing postal code to match.
     * @return List of Contact records with ID and Name fields populated.
     */
    public static List<Contact> searchForContacts(String lastName, String postalCode) {
        // Validate input parameters
        if (String.isBlank(lastName) || String.isBlank(postalCode)) {
            return new List<Contact>(); // Return an empty list if parameters are invalid
        }

        // Query the contacts based on the provided parameters
        List<Contact> matchingContacts = [
            SELECT Id, Name
            FROM Contact
            WHERE LastName = :lastName
              AND MailingPostalCode = :postalCode
        ];

        return matchingContacts;
    }
}