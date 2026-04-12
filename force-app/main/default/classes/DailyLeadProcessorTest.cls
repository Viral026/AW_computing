@isTest
private class DailyLeadProcessorTest {
    @isTest
    static void testDailyLeadProcessor() {
        // Insert 200 Lead records with a blank LeadSource
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(FirstName = 'Test', LastName = 'Lead ' + i, Company = 'Test Company'));
        }
        insert leads;

        // Verify that the leads have a blank LeadSource
        Integer countBefore = [SELECT COUNT() FROM Lead WHERE LeadSource = NULL];
        System.assertEquals(200, countBefore);

        // Schedule the class to run immediately
        Test.startTest();
        String jobId = System.schedule('Test Daily Lead Processor', '0 0 0 * * ?', new DailyLeadProcessor());
        Test.stopTest();

        // Verify that the LeadSource was updated
        Integer countAfter = [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, countAfter);
    }
}