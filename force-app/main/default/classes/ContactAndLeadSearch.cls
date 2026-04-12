public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String searchString) {
        // Ensure the input string is formatted correctly for the SOSL query
        String formattedSearchString = '%' + String.escapeSingleQuotes(searchString) + '%';

        // Perform the SOSL search to find both Contacts and Leads with the given first or last name
        List<List<SObject>> searchResults = [
            FIND :searchString IN NAME FIELDS
            RETURNING Contact (Id, FirstName, LastName),
                      Lead (Id, FirstName, LastName)
        ];

        return searchResults;
    }
}