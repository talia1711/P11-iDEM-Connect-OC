/***
 * Author: Talia Ajaz
 * Date: March 2024
 */
public with sharing class OrderService {
    //RG-02
    //check if related order account has at least an order to set the account active as true, or false otherwise
    public static void checkRelatedAccount(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> accToUpdate = new List<Account>();

        for(Order orderItem : orders){
            accountIds.add(orderItem.AccountId);
        }

        //get orders for each account that are related to the triggered orders
        for(Account acc : [SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id In:accountIds]){
            acc.Active__c = !acc.Orders.isEmpty();
            accToUpdate.add(acc);
        }

        //update[date related accounts
        update accToUpdate;
    }
}