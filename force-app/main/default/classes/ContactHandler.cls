public class ContactHandler {

   
    public static void beforeContactInsertActivity(List<Contact> contactRecords){
        List<Id> conAccId = new List<Id>();
        Map<Id, Id> convsAccId = new Map<Id, Id>();
        for(Contact con : contactRecords){
            conAccId.add(con.AccountId);
            conVsAccId.put(con.Id,con.AccountId);
        }
        
        Map<Id, Account> accountRecordMap = new Map<Id, Account>([Select Id, Max_Contacts_Allowed__c,(Select Id From Contacts) from Account Where Id IN :conAccId]);
        
        for(Id accId : accountRecordMap.keySet()){
            Integer numberOfContactsOnAcc = (accountRecordMap.get(accId).Contacts).size() + 1;
            if(accountRecordMap.get(accId).Max_Contacts_Allowed__c < numberOfContactsOnAcc){
                for(Contact cont : contactRecords){
                    if(cont.AccountId == accId){
                        cont.addError('Contact can be added');
                    }
                }
            }
        }
        
    }
   
    public static void beforeInsertActivity(List<Contact> contactRecords){
        
        List<Contact> exsitingContactList = [SELECT Id,LastName,Phone,Email From Contact limit 5000];
        
        for(Contact con : contactRecords){
            for(Contact existingCon : exsitingContactList){
            if(con.LastName == existingCon.LastName && con.Phone == existingCon.Phone && con.Email == existingCon.Email){
                con.addError('Contact can not be inserted');
            }    
            }
        }
    }
    public static void afterInsertActivity(List<Contact> newContactRecords){
        List <ContactShare> conShareRecord = new List<ContactShare>();
        Id publicGroupId = [ SELECT Id, Name FROM Group WHERE Name = 'Contact Innovators' LIMIT 1 ].Id;
        
        for(Contact con : newContactRecords){
          ContactShare cons = new ContactShare();
            cons.ContactId = con.Id;
            cons.UserOrGroupId = publicGroupId;
            cons.RowCause = 'Rule';
            conShareRecord.add(cons);
        }
        if(!conShareRecord.isEmpty()){
            insert conShareRecord;
        }
    }
    
    public static void beforeConInsertActivity(List<Contact> newConRec){
        List<Id> conAccId = new List<Id>();
        for(Contact con : newConRec){
            conAccId.add(con.AccountId);
        }
        
		Map<Id, Account> accRec = new Map<Id, Account>([Select Id, BillingStreet, BillingCity, BillingState, BillingCountry,BillingPostalCode From Account where Id IN :conAccId]);                
        
		for(Contact conRec : newConRec){
            if(accRec.ContainsKey(conRec.AccountId)){
                conRec.MailingStreet = accRec.get(conRec.AccountId).BillingStreet;
                conRec.MailingCity = accRec.get(conRec.AccountId).BillingCity;
                conRec.MailingState = accRec.get(conRec.AccountId).BillingState;
                conRec.MailingCountry = accRec.get(conRec.AccountId).BillingCountry;
                conRec.MailingPostalCode = accRec.get(conRec.AccountId).BillingPostalCode;
            }	
            
        }
        
    }
    
    public static void afterUpdateActivity(List<Contact> newContactRec, Map<Id, Contact> oldContactRec){
        List<Id> AccountIds = new List<Id>();
        for(Contact con : newContactRec){
            if(con.AccountId != null){
                if(con.Email != oldContactRec.get(con.Id).Email || con.Phone != oldContactRec.get(con.Id).Phone){
                    AccountIds.add(con.AccountId);
                }    
            }
        }
        
        List<String> emailAddressList = new List<String>(); 
        List<Account> accountOwner = [Select Id, OwnerId,Owner.Email From Account Where Id IN :AccountIds];
        
        for(Account acc : accountOwner){
            emailAddressList.add(acc.Owner.Email);
        }
        
        if(!emailAddressList.isEmpty()){
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            for(Id accId : AccountIds){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                // Set recipients to two contact IDs.
                // Replace IDs with valid record IDs in your org.
                message.toAddresses = emailAddressList ;
                message.optOutPolicy = 'FILTER';
                message.subject = 'Contact Email Or Phone Changed';
                message.plainTextBody = 'The email or phone information of you child contact had been modified.';
                messages.add(message);
            }
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
    }
}