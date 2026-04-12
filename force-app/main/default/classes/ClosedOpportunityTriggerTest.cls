@isTest
private class ClosedOpportunityTriggerTest {
    static testMethod void testClosedOpportunityTrigger() {
        Test.startTest();

        // Insert Opportunities
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Name = 'Test Opp 1',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Discount_Percent__c = 10 // Required field populated
            ),
            new Opportunity(
                Name = 'Test Opp 2',
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                Discount_Percent__c = 20 // Required field populated
            )
        };

        // Insert opportunities
        insert opps;

        // Update an opportunity to set its Stage to Closed Won
        opps[0].StageName = 'Closed Won';
        update opps;

        Test.stopTest();

        // Verify tasks are created
        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE Subject = 'Follow Up Test Task'];
        System.assertEquals(2, tasks.size());
    }
}