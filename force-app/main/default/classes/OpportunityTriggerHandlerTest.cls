@isTest
private class OpportunityTriggerHandlerTest {
    @isTest static void testCreateContractOnClosedWon() {
        // Step 1: Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.newInstance(2025, 1, 20),
            AccountId = testAccount.Id,
            Amount = 10000
        );
        insert testOpportunity;

        // Step 2: Update Opportunity Stage to 'Closed Won'
        testOpportunity.StageName = 'Closed Won';
        update testOpportunity;

        // Step 3: Verify Custom Contract was created
        List<Custom_Contract__c> contracts = [
            SELECT Id, Name, Account__c, Contract_Start_Date__c, Amount__c 
            FROM Custom_Contract__c 
            WHERE Account__c = :testAccount.Id
        ];
        System.assertEquals(1, contracts.size(), 'One Custom Contract should be created.');
        System.assertEquals(testOpportunity.CloseDate, contracts[0].Contract_Start_Date__c, 'The Start Date should match the Opportunity Close Date.');
        System.assertEquals(testOpportunity.Amount, contracts[0].Amount__c, 'The Amount should match the Opportunity Amount.');
        System.assertEquals(testOpportunity.Name, contracts[0].Name, 'The Name should match the Opportunity Name.');
    }

    @isTest static void testNoContractIfStageNotChangedToClosedWon() {
        // Step 1: Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Opportunity Without Stage Change',
            StageName = 'Prospecting',
            CloseDate = Date.newInstance(2025, 1, 20),
            AccountId = testAccount.Id,
            Amount = 5000
        );
        insert testOpportunity;

        // Step 2: Update Opportunity without changing Stage to "Closed Won"
        testOpportunity.Amount = 7000; // Change Amount but not Stage
        update testOpportunity;

        // Step 3: Verify no Custom Contract was created
        List<Custom_Contract__c> contracts = [
            SELECT Id 
            FROM Custom_Contract__c 
            WHERE Account__c = :testAccount.Id
        ];
        System.assertEquals(0, contracts.size(), 'No Custom Contract should be created if Stage is not changed to "Closed Won".');
    }

    @isTest static void testBulkOpportunityUpdates() {
        // Step 1: Create test data
        Account testAccount = new Account(Name = 'Bulk Test Account');
        insert testAccount;

        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            opportunities.add(new Opportunity(
                Name = 'Bulk Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.newInstance(2025, 1, 20).addDays(i),
                AccountId = testAccount.Id,
                Amount = 1000 * (i + 1)
            ));
        }
        insert opportunities;

        // Step 2: Update all Opportunities to "Closed Won"
        for (Opportunity opp : opportunities) {
            opp.StageName = 'Closed Won';
        }
        update opportunities;

        // Step 3: Verify all Custom Contracts were created
        List<Custom_Contract__c> contracts = [
            SELECT Id, Name, Account__c, Contract_Start_Date__c, Amount__c 
            FROM Custom_Contract__c 
            WHERE Account__c = :testAccount.Id
        ];
        System.assertEquals(5, contracts.size(), 'Five Custom Contracts should be created for the five Opportunities.');

        for (Integer i = 0; i < contracts.size(); i++) {
            Custom_Contract__c contract = contracts[i];
            Opportunity opp = opportunities[i];

            System.assertEquals(opp.CloseDate, contract.Contract_Start_Date__c, 'Start Date should match Opportunity Close Date.');
            System.assertEquals(opp.Amount, contract.Amount__c, 'Amount should match Opportunity Amount.');
            System.assertEquals(opp.Name, contract.Name, 'Name should match Opportunity Name.');
        }
    }
}