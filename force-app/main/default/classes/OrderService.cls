public with sharing class OrderService {
       //RG-02
    
    public static void checkRelatedAccount(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> accToUpdate = new List<Account>();

        for(Order orderItem : orders){
            accountIds.add(orderItem.AccountId);
        }

        for(Account acc : [SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id In:accountIds]){
            acc.Active__c = !acc.Orders.isEmpty();
            accToUpdate.add(acc);
        }

        update accToUpdate;
    }
}