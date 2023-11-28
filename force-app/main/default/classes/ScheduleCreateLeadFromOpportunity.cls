global class ScheduleCreateLeadFromOpportunity implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Create an instance of the batch job and schedule it to run
        CreateLeadFromOpportunityBatch batchJob = new CreateLeadFromOpportunityBatch();
        Database.executeBatch(batchJob);
                    system.debug('batchJob'+batchJob);

    }
}