@isTest
private class UpdateOpenOpportunitiesBatchTest {
    @isTest
    static void testBatchExecution() {
        // Set up test data
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 100; i++) { // Limit data to ensure a single batch
            opps.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                StageName = 'Open',
                CloseDate = Date.today().addDays(-i - 1) // CloseDate in the past
            ));
        }
        insert opps;

        // Execute the batch job
        Test.startTest();
        Database.executeBatch(new UpdateOpenOpportunitiesBatch(), 200); // Single execution
        Test.stopTest();

        // Retrieve updated records and verify results
        List<Opportunity> updatedOpps = [SELECT StageName FROM Opportunity WHERE StageName = 'Closed Lost'];
        System.assertEquals(100, updatedOpps.size(), 'All Opportunities should be updated to "Closed Lost".');
    }

    @isTest
    static void testScheduledJob() {
        Test.startTest();
        OpportunityBatchScheduler scheduler = new OpportunityBatchScheduler();
        String jobId = System.schedule('Test Scheduler', '0 0 2 * * ?', scheduler);
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Scheduler should be successfully scheduled.');
    }
}