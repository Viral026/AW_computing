@isTest
public class CreateFollowUpTasksQueueableTest {
    @isTest
    static void testQueueable() {
        // Create test Contacts
        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', Contact_Status__c = 'Not Engaged');
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Smith', Contact_Status__c = 'Not Engaged');
        insert new List<Contact> { contact1, contact2 };

        // Update Contact_Status__c to 'Engaged'
        contact1.Contact_Status__c = 'Engaged';
        contact2.Contact_Status__c = 'Engaged';
        //update new List<Contact> { contact1, contact2 };

        // Verify the Tasks were created
        Test.startTest();
        update new List<Contact>{contact1, contact2}; // Trigger enqueues the job
        Test.stopTest();

        // Assert that the tasks are created with correct details
        List<Task> tasks = [SELECT Subject, Priority, ActivityDate, WhoId FROM Task WHERE WhoId IN :new List<Id>{contact1.Id, contact2.Id}];
        System.assertEquals(2, tasks.size(), 'Two tasks should be created');

        for (Task task : tasks) {
            System.assertEquals('Call', task.Subject, 'Subject should be "Call"');
            System.assertEquals('High', task.Priority, 'Priority should be "High"');
            System.assertEquals(System.today().addDays(3), task.ActivityDate, 'Due Date should be 3 days from today');
            System.assert(task.WhoId != null, 'WhoId should be populated');
        }
    }
}