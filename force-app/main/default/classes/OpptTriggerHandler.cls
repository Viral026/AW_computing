public class OpptTriggerHandler {
    
    public static void handleAfterUpdateActivity(List <Opportunity> newRecords,Map<Id,Opportunity> oldMapRecord){
        List<Task> taskRecordInserted = new List<Task>();
        List<Id> oppIds = new List<Id>();
        List<OpportunityTeamMember> deleteTeamMember = new List<OpportunityTeamMember>();
        for(Opportunity opps : newRecords){
            oppIds.add(opps.Id);
        }
        List <OpportunityTeamMember> oppTeamMember = [Select Id,OpportunityId from OpportunityTeamMember where OpportunityId IN :oppIds];
        
        for(Opportunity opp : newRecords){
            
            if(opp.StageName == 'Closed Won'){
                
                Task taskRecords = new Task();
                taskRecords.Priority = 'High';
                taskRecords.Status = 'Not Stated';
                taskRecords.OwnerId = Opp.OwnerId;
               	taskRecords.WhatId = Opp.Id;
                taskRecords.Subject = 'split revenue';
               	
				taskRecordInserted.add(taskRecords);
                
            }
            else if(opp.StageName == 'Closed Lost'){
                for(OpportunityTeamMember teamMember : oppTeamMember){
                    if(teamMember.OpportunityId == opp.Id){
                        deleteTeamMember.add(teamMember);
                    }
                }
            }
        }
        
        if(!taskRecordInserted.isEmpty()){
            insert taskRecordInserted;
        }

        if(!deleteTeamMember.isEmpty()){
            delete deleteTeamMember;
        }
    }

    public static void handleBeforeUpdateActivity(List<Opportunity> oppNewRecords,Map<Id,Opportunity> oldMapRecord){
        
        for(Opportunity oppNew : oppNewRecords){
        
            if(oldMapRecord.get(oppNew.Id).StageName != oppNew.StageName){
                oppNew.Amount = oppNew.Probability * oppNew.ExpectedRevenue;
            }

		}
        
    }
    
    public static void handleAfterDeleteActivity(List<Opportunity> oppRecords){
       	Set<Id> accountIds = new Set<Id>();
        Map<Id,Id> oppvsAccountMap = new Map<Id, Id>();
        Map<Id,Id> accIdvsOwnerId = new Map<Id, Id>();
        for(Opportunity opp: oppRecords){
            accountIds.add(opp.AccountId);
            oppvsAccountMap.put(opp.Id, opp.AccountId);
        }
        
        List<Account> accountRecords = [Select Id, ownerId From Account where Id IN :accountIds];
        
        for(Account acc: accountRecords){
            accIdvsOwnerId.put(acc.Id, acc.OwnerId);
        }
        
        List<Task> tasksRecordInserted = new List<Task>();
        for(Opportunity oRecord : oppRecords){
            Task taskRec = new Task();
            //taskRec.AccountId = oppRecords.get(oRecord.Id).AccountId;
            taskRec.OwnerId = accIdvsOwnerId.get(oppvsAccountMap.get(oRecord.Id));
            taskRec.Description = 'Why this opp. is deleted';
            taskRec.Status = 'Not Started';
			taskRec.Priority = 'High';
            //taskRec.WhatId = oRecord.Id;
            taskRec.Subject = 'Follow Up';
            tasksRecordInserted.add(taskRec);
        }
        
        if(!tasksRecordInserted.isEmpty()){
            insert tasksRecordInserted;
        }
        
    }
    
    public static void addTeamMember(List<Opportunity> oppRecords, Map<Id,Opportunity> oppOldRecords){
        List<OpportunityTeamMember> oppTeamMemberList = new List<OpportunityTeamMember>();
        List<User> userIdOpp = [Select Id, UserRole.Name from User Where isActive = true AND UserRole.Name = 'Opportunists'];
        for(Opportunity opp : oppRecords){
            if(opp.StageName != oppOldRecords.get(opp.Id).StageName && opp.StageName == 'Needs Analysis'){
                for(User userRec : userIdOpp){
                OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                oppTeamMember.OpportunityId = opp.Id;
				oppTeamMember.OpportunityAccessLevel = 'Edit';
                oppTeamMember.UserId = userRec.Id;
                oppTeamMemberList.add(oppTeamMember);    
                }
            }
        }
        if(!oppTeamMemberList.isEmpty()){
            insert oppTeamMemberList;
        }
    }
    
    public static void addTask(List<Opportunity> oppRecords, Map<Id,Opportunity> oppOldRecords){
        List<Task> taskList = new List<Task>();
        for(Opportunity opp : oppRecords){
            if(opp.StageName != oppOldRecords.get(opp.Id).StageName){
                if((opp.StageName == 'Qualification' || opp.StageName == 'Prospecting') && oppOldRecords.get(opp.Id).StageName == 'Perception Analysis'){
                    Task taskRec = new Task();
                    taskRec.WhatId = opp.Id;
                    taskRec.Subject = 'Opp updated';
                    taskRec.Description = 'Why the opportunity didnt progress further.';
                    taskRec.Priority = 'High';
                    taskRec.IsReminderSet = true;
                    taskRec.ReminderDateTime = System.today() + 1;
                    
                    taskList.add(taskRec);
                }
            }
        }
        if(!taskList.isEmpty()){
            insert taskList;
        }
    }
}