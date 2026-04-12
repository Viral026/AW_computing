public class LeadHelper {

    public static void leadAfterInsertActivity(List<Lead> leadRecord){
        List <Task> taskToBeInserted = new List<Task>();
        for(Lead l : leadRecord){
        Task taskRecordss = new Task();
        taskRecordss.Description = 'New Lead';
        taskRecordss.WhoId = l.Id;
        taskRecordss.OwnerId = l.OwnerId;
        taskRecordss.Subject = 'Lead created today';
        taskRecordss.Priority = 'High';
    	taskToBeInserted.add(taskRecordss);
        }
        if(!taskToBeInserted.isEmpty()){
            insert taskToBeInserted;
        }
    }
    
    public static void leadBeforeDeleteActivity(List<Lead> leadNewRecord){
        for(Lead leadRec : leadNewRecord){
            if(leadRec.Status == 'Working - Contacted'){
                leadRec.addError('You can delete this record');
            }
        }
    }
}