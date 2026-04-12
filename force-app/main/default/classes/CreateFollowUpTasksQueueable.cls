public class CreateFollowUpTasksQueueable implements Queueable {
    private List<Id> contactIds;

    // Constructor to accept Contact IDs
    public CreateFollowUpTasksQueueable(List<Id> contactIds) {
        this.contactIds = contactIds;
    }

    public void execute(QueueableContext context) {
        List<Task> tasksToCreate = new List<Task>();

        // Query Contacts with the given IDs
        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE Id IN :contactIds];

        for (Contact contact : contacts) {
            tasksToCreate.add(new Task(
                WhoId = contact.Id,
                Subject = 'Call',
                Priority = 'High',
                ActivityDate = System.today().addDays(3)
            ));
        }

        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }

        // Chaining example (if further processing is needed)
        // System.enqueueJob(new SomeOtherQueueableJob(someParameters));
    }
}