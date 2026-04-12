public class OpportunityTriggerHandler {
    public static void handleOpportunityUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunityMap) {
        List<Custom_Contract__c> contractsToInsert = new List<Custom_Contract__c>();

        for (Opportunity opp : newOpportunities) {
            Opportunity oldOpp = oldOpportunityMap.get(opp.Id);

            // Check if StageName has changed to "Closed Won"
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                System.debug('Opportunity CloseDate being assigned to Custom Contract: ' + opp.CloseDate);

                Custom_Contract__c customContract = new Custom_Contract__c(
                    Account__c = opp.AccountId, // Linking the contract to the Opportunity's Account
                    Opportunity__c = opp.Id, // Linking the contract to the Opportunity via the custom lookup field Opportunity__c
                    Contract_Start_Date__c = opp.CloseDate, // Set the Contract Start Date to the Opportunity Close Date
                    Amount__c = opp.Amount, // Set the Amount field of the contract from Opportunity
                    //Opportunity_Name__c = opp.Name, //not needed 
                    Name = 'Contract ' + String.valueOf(Math.abs(Crypto.getRandomInteger())) // Generate a random contract name
                );

                System.debug('Custom Contract Start Date before insertion: ' + customContract.Contract_Start_Date__c);
                contractsToInsert.add(customContract);
            }
        }

        if (!contractsToInsert.isEmpty()) {
            try {
                insert contractsToInsert;
            } catch (Exception e) {
                System.debug('Error inserting Custom Contracts: ' + e.getMessage());
            }
        }
    }
}