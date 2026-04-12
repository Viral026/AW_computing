global class OpportunityBatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdateOpenOpportunitiesBatch(), 200);
    }
}