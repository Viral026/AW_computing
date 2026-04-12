@isTest
public class ContactAPITest {

    // Helper method to set up test data
    private static Contact createTestContact() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test.user@example.com',
            Phone = '5551234567'
        );
        insert testContact;
        return testContact;
    }

    // Test GET method
    @isTest
    static void testGetContactById_Valid() {
        // Create a test contact
        Contact testContact = createTestContact();

        // Create a mock RestContext with the API key and contact ID
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ContactAPI/' + testContact.Id;
        req.headers.put('x-api-key', 'viral-salesforce-training');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the GET method
        Contact result = ContactAPI.getContactById();

        // Validate the result
        System.assertNotEquals(result, null, 'Expected a valid Contact record');
        System.assertEquals(result.Id, testContact.Id, 'Contact ID should match');
        System.assertEquals(res.statusCode, 200, 'Status code should be 200 OK');
        Test.stopTest();
    }

    // Test GET method with an invalid API key
    @isTest
    static void testGetContactById_InvalidApiKey() {
        // Create a test contact
        Contact testContact = createTestContact();

        // Create a mock RestContext with an invalid API key
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ContactAPI/' + testContact.Id;
        req.headers.put('x-api-key', 'wrong-api-key');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the GET method
        Contact result = ContactAPI.getContactById();

        // Validate the result
        System.assertEquals(result, null, 'Expected no contact result for invalid API key');
        System.assertEquals(res.statusCode, 401, 'Status code should be 401 Unauthorized');
        Test.stopTest();
    }

    // Test POST method with valid data
    @isTest
    static void testCreateContact_Valid() {
        // Prepare the request body
        String requestBody = '{"FirstName": "John", "LastName": "Doe", "Email": "john.doe@example.com", "Phone": "1234567890"}';

        // Create a mock RestContext with the API key
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ContactAPI/';
        req.headers.put('x-api-key', 'viral-salesforce-training');
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the POST method
        String result = ContactAPI.createContact();

        // Validate the result
        System.assert(result.contains('Contact created with ID'), 'Expected success message with contact ID');
        System.assertEquals(res.statusCode, 201, 'Status code should be 201 Created');
        Test.stopTest();
    }

    // Test POST method with invalid data
    @isTest
    static void testCreateContact_InvalidData() {
        // Prepare the request body with missing fields
        String requestBody = '{"FirstName": "John", "Email": "john.doe@example.com"}';  // Missing LastName and Phone

        // Create a mock RestContext with the API key
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ContactAPI/';
        req.headers.put('x-api-key', 'viral-salesforce-training');
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the POST method
        String result = ContactAPI.createContact();

        // Validate the result
        System.assert(result.contains('Error'), 'Expected error message due to missing required fields');
        System.assertEquals(res.statusCode, 400, 'Status code should be 400 Bad Request');
        Test.stopTest();
    }

    // Test POST method with invalid API key
    @isTest
    static void testCreateContact_InvalidApiKey() {
        // Prepare the request body
        String requestBody = '{"FirstName": "John", "LastName": "Doe", "Email": "john.doe@example.com", "Phone": "1234567890"}';

        // Create a mock RestContext with an invalid API key
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ContactAPI/';
        req.headers.put('x-api-key', 'wrong-api-key');
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the POST method
        String result = ContactAPI.createContact();

        // Validate the result
        System.assert(result.contains('Invalid API Key'), 'Expected error message for invalid API key');
        System.assertEquals(res.statusCode, 401, 'Status code should be 401 Unauthorized');
        Test.stopTest();
    }
}