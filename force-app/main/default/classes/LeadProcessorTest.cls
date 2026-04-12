@isTest
private class LeadProcessorTest {
    @isTest
    static void testLeadProcessor() {
        // Step 1: Create test data - 200 Lead records
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'TestFirst' + i,
                LastName = 'TestLast' + i,
                Company = 'TestCompany' + i,
                LeadSource = 'Web'
            ));
        }
        insert testLeads;

        // Step 2: Execute the batch class
        Test.startTest();
        LeadProcessor batch = new LeadProcessor();
        Database.executeBatch(batch);
        Test.stopTest();

        // Step 3: Verify all Lead records are updated
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead];
        for (Lead lead : updatedLeads) {
            System.assertEquals('Dreamforce', lead.LeadSource, 'LeadSource should be updated to Dreamforce');
        }
    }
}