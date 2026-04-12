public class CaseHandler {

    public static void caseBeforeDeleteActivity(List <Case> oldCaseRecord){
        //Id currentUser = UserInfo.getUserId();
        //Id profileName = [Select Id, Name From Profile where Name = 'System Adminstration'].Id;
        String profileName = [
    	SELECT Profile.Name
    	FROM User
   		WHERE Id = :UserInfo.getUserId()
		].Profile.Name;
        
        for(Case caseRecord : oldCaseRecord){
            if(profileName != 'System Administrator'){
                caseRecord.addError('Only system admin can delete the case record.');
            }
        }
        
    }
}