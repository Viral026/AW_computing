public class LeadProcessor implements Database.Batchable<SObject> {
    // Start method to query all Lead records
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Lead');
    }

    // Execute method to update LeadSource field
    public void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for (SObject obj : scope) {
            Lead leadRecord = (Lead)obj;
            leadRecord.LeadSource = 'Dreamforce';
            leadsToUpdate.add(leadRecord);
        }
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    // Finish method (optional for logging or post-processing)
    public void finish(Database.BatchableContext BC) {
        // Optional logic after batch processing completes
    }
}