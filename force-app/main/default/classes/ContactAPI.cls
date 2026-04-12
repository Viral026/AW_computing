@RestResource(urlMapping='/ContactAPI/*')
global with sharing class ContactAPI {

    private static final String API_KEY = 'viral-salesforce-training';

    private static Boolean validateApiKey(String key) {
        return key != null && key == API_KEY;
    }

    @HttpGet
    global static Contact getContactById() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Validate API Key
        String apiKey = req.headers.get('x-api-key');
        if (!validateApiKey(apiKey)) {
            res.statusCode = 401; // Unauthorized
            res.responseBody = Blob.valueOf('Invalid API Key');
            return null;
        }

        // Get Contact ID from URL
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        // Fetch Contact
        Contact contactRecord = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];
        if (contactRecord == null) {
            res.statusCode = 404; // Not Found
            res.responseBody = Blob.valueOf('Contact Not Found');
        }
        return contactRecord;
    }

    @HttpPost
    global static String createContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        // Validate the API Key
        String apiKey = req.headers.get('x-api-key');
        if (!validateApiKey(apiKey)) {
            res.statusCode = 401; // Unauthorized
            res.responseBody = Blob.valueOf('Invalid API Key');
            return null;
        }
        
        try {
            // Deserialize the JSON payload directly from request body
            String requestBody = req.requestBody.toString();
            Contact newContact = (Contact) JSON.deserialize(requestBody, Contact.class);
            
            // Insert the new Contact record
            insert newContact;
            res.statusCode = 201; // Created
            return 'Contact created with ID: ' + newContact.Id;
        } catch (Exception e) {
            res.statusCode = 400; // Bad Request
            res.responseBody = Blob.valueOf('Error: ' + e.getMessage());
            return null;
        }
    }

}