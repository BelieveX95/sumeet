trigger WeatherUpdateAccount on Account (after insert) {
    List<Account> accountsToUpdate = new List<Account>();

    for (Account acc : Trigger.new) {
        if (acc.BillingCity != null) {
            accountsToUpdate.add(acc);
        }
    }

    if (!accountsToUpdate.isEmpty()) {
        WeatherUpdateQueueable queueable = new WeatherUpdateQueueable(accountsToUpdate);
        System.enqueueJob(queueable);
    }
}