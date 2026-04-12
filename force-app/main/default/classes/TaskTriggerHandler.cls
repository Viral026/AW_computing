public class TaskTriggerHandler {

    public static void taskAfterInsertActivity(List<Task> newTaskRec){
        Map<Id, Integer> conCountMap = new Map<Id, Integer>();
        List<Contact> conRecordToUpdate = new List<Contact>();
        //List<Task> taskRec = [Select Id, WhoId From Task];
        for(Task t : newTaskRec){
            if(String.ValueOf(t.WhoId).startsWith('003')){
                if(conCountMap.containsKey(t.WhoId)){
                    Integer countVar = conCountMap.get(t.WhoId) + 1;
                    conCountMap.put(t.WhoId, countVar);
                }
                else{
                    conCountMap.put(t.WhoId, 1);
                }
            }
        }
        
        List<Contact> conRecords = [Select Id, Number_Of_Task_Associated__c FROM Contact where Id IN :conCountMap.keySet()];
        
        for(Contact con : conRecords){
            if(con.Number_Of_Task_Associated__c != null){
            con.Number_Of_Task_Associated__c = con.Number_Of_Task_Associated__c + conCountMap.get(con.Id);    
            }
            else{
                con.Number_Of_Task_Associated__c = conCountMap.get(con.Id);
            }
            
            conRecordToUpdate.add(con);
        }
        if(!conRecordToUpdate.isEmpty()){
            update conRecordToUpdate;
        }
    }
    
    
    public static void taskBeforeUpdateActivity(List<Task> newTaskRecord){
        List<Id> contactId = new List<Id>();
        Map<Id, Id> taskVsConMap = new Map<Id, Id>();
        Map<Id, Id> conVsAccMap = new Map<Id, Id>();

        for(Task eachTask : newTaskRecord){
            if(String.valueOf(eachTask.WhoId).startsWith('003')){
                contactId.add(eachTask.WhoId);
                taskVsConMap.put(eachTask.Id, eachTask.WhoId);
            }
        }
        
        Map<Id, Account> accountRecordsMap = new Map<Id, Account>([Select Id, Modify_Task_Permission__c From Account where Id IN (Select AccountId From Contact Where Id IN :contactId)]);
     
        //task Id, contact id
        //account record
        //contact id , account id
        //task id, account id
        
        List<Contact> conRecords = [Select AccountId From Contact where Id IN :contactId];
        for(Contact con : conRecords){
            conVsAccMap.put(con.Id , con.AccountId);
        }
        
        for(Task eachTask : newTaskRecord){
            if(!accountRecordsMap.get(conVsAccMap.get(taskVsConMap.get(eachTask.Id))).Modify_Task_Permission__c){
               eachTask.addError('You cant modify this task record'); 
            }
        }
    }
}