global class UpdateOpenOpportunitiesBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, StageName, CloseDate 
            FROM Opportunity 
            WHERE StageName = 'Open' AND CloseDate < TODAY
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        for (Opportunity opp : scope) {
            opp.StageName = 'Closed Lost';
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {
        // Optional: Log completion or send notifications
        System.debug('Batch job completed.');
    }
}