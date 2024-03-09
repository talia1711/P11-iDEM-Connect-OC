global class AccountOrderReminderBatch implements Database.Batchable<sObject>, Schedulable {
    public void execute(SchedulableContext sc) {
        // Initiate the batch process when the scheduled job executes.
        Database.executeBatch(this);
    }
    
    public static void scheduleWeekly() {
        // CRON scheduling Monday at 6 AccountOrderReminderBatch
        System.schedule('Weekly AccountOrderReminderBatch',  '0 0 6 ? * MON', new AccountOrderReminderBatch());
    }
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
	    return Database.getQueryLocator('SELECT Id, Name, OwnerId FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)');
   }
    
   global void execute(Database.BatchableContext info, List<Account> listAccounts){   
        List<Task> tasksToBeAdded = new  List<Task>();
        for(Account acc : listAccounts){
            tasksToBeAdded.add(new Task(
                WhatId = acc.Id,
                Subject = 'Call',
                Status = 'New',
                Priority = 'Normal',
                OwnerId = acc.OwnerId
            ));
        }

        insert tasksToBeAdded;
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}