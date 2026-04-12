/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-07-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountHandler {
    
    public static void handleBeforeInsertActivity(List<Account> newAccountRec){
        Map<Id,Id> accOwnerId = new Map<Id,Id>();
        for(Account acc : newAccountRec){
            accOwnerId.put(acc.Id, acc.OwnerId);
        }
        
        Map<Id,User> userRecord = new Map<Id,User>([Select Id, Name From User Where Id IN:accOwnerId.values()]);
        
        for(Account acc: newAccountRec){
			acc.Sales_Rep__c = userRecord.get(accOwnerId.get(acc.Id)).Name;
        }
        
    }
    public static void handleAfterInsertActivity(List<Account> accConRecords){
        List<Contact> contactRecord = new List<Contact>();
        for(Account account : accConRecords){
            if(account.Create_N_Contacts__c != null){
                for(Integer i = 0 ; i<account.Create_N_Contacts__c ; i++){
                    Contact conRecord = new Contact();
                    conRecord.AccountId = account.Id;
                    conRecord.FirstName = account.Name + i;
                    contactRecord.add(conRecord);
                }
			
            }
        }
        if(!contactRecord.isEmpty()){
            insert contactRecord;
        }
    }
    
    public static void handleBeforeUpdateActivity(List<Account> accRecord, Map<id,Account> oldMap){
        
        for(Account acc : accRecord){
            if(acc.Industry == 'Agriculture' && acc.Type == 'Prospect' && acc.Ownership =='Private'){
                if(oldMap.get(acc.Id).Ownership != acc.Ownership){
                    acc.addError('Cant update this record');
                }
            }
        }   

}
    
    public static void handleAfterUpdateActivity(List<Account> accRecords, Map<id,Account> oldMapRecords){
        Set<Id> accId = new Set<Id>(); 
        Map<Id, Account> accMap = new Map<Id, Account>();
        for(Account acc : accRecords){
            if(oldMapRecords.get(acc.Id).BillingStreet != acc.BillingStreet || oldMapRecords.get(acc.Id).BillingCity != acc.BillingCity || oldMapRecords.get(acc.Id).BillingState != acc.BillingState || oldMapRecords.get(acc.Id).BillingPostalCode != acc.BillingPostalCode || oldMapRecords.get(acc.Id).BillingCountry != acc.BillingCountry){
                accId.add(acc.Id);
                accMap.put(acc.Id, acc);
            }
        }
        
        if(!accId.isEmpty()){
        
        List<Contact> contactToUpdate = [Select Id, AccountId,MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry from Contact where AccountId IN : accId];
        
         for(Contact conRecord : contactToUpdate){
             	Account acc = accMap.get(conRecord.AccountId);
                conRecord.MailingCity = acc.BillingCity;
                conRecord.MailingStreet = acc.BillingStreet;
                conRecord.MailingState = acc.BillingState;
                conRecord.MailingPostalCode = acc.BillingPostalCode;
                conRecord.MailingCountry = acc.BillingCountry;
            }
           	if(!contactToUpdate.isEmpty()){
            update contactToUpdate;
        	} 
        }
        
    }
    

    public static void handleBeforeDeleteActivity(List<Account> deleteAccount){
        
        Id currentProfileId = UserInfo.getProfileId();
        Id ProfileName = [Select Id, Name from Profile where Name = 'System Administrator' limit 1].id;
        
        for(Account acc : deleteAccount){
            if(ProfileName != currentProfileId){
                acc.addError('you can not delete this record.');
            }
        }
        
    }

    public static void handleAfterUndeleteActivity(List<Account> undeleteAccount){
        List<Id> accIds = new List<Id>();
        List<Account> accToUpdate = new List<Account>();
        for(Account acc : undeleteAccount){
            accIds.add(acc.Id);
        }
        List<Account> accountToUpdate = [Select Id, Name from Account where Id IN :accIds];
        
        for(Account acc : accountToUpdate){
            acc.Name = 'Restored ' + acc.Name;
            accToUpdate.add(acc);
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }    
    
    public static void handleAsyncApexActivity(List<Account> updatedAccountRec, Map<Id,Account> updatedAccMap){
        List<Id> accIds = new List<Id>();
        
        for(Account acc: updatedAccountRec){
            if(acc.Industry != updatedAccMap.get(acc.Id).Industry && acc.Industry == 'Biotechnology'){
                accIds.add(acc.Id);
            }
        }
        if(!accIds.isEmpty()){
            callAsyncApex(accIds);
        }
    }
    
    @future
    public static void callAsyncApex(List<Id> accountIds){
        List<Contact> conToUpdate = new List<Contact>();
        List<Contact> conRec = [Select Id,AccountId, LeadSource From Contact where AccountId IN :accountIds];
        for(Contact con : conRec){
            con.LeadSource = 'Phone';
            conToUpdate.add(con);
        }
        
        if(!conToUpdate.isEmpty()){
            update conToUpdate;
        }
        
    }
}