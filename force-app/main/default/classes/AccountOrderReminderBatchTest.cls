@isTest
public class AccountOrderReminderBatchTest {
  
    @isTest
    static void notTasksForAccountsWithOrders(){
         //create 200 accounts
         List<Account> accList  = new List<Account>();
         for(Integer i=0;i<200;i++){
             accList.add(new Account(Name = 'OC'+i));
         }
         insert accList;

         Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
         Insert pd1;
         
         //Create one order per account
         List<Order> orderList = new List<Order>();
         for(Account acc : accList){
             orderList.add(new Order(AccountId = acc.Id, 
                                    EffectiveDate = Date.newInstance(2024, 1, 1), 
                                    Status = 'Draft', 
                                    Pricebook2Id = Test.getStandardPriceBookId(),
                                    Name = 'Item'));
         }
         
        insert orderList;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;
        
        //create one order item per order
		List<OrderItem> orderItemList = new List<OrderItem>();
        for(Order oo : orderList){
            oo.Status = 'Ordered';
            orderItemList.add(new OrderItem(OrderId = oo.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 120));
        }
		
		insert orderItemList;


        Test.startTest();
            AccountOrderReminderBatch ba = new AccountOrderReminderBatch();
            Id jobid= Database.executeBatch(ba, 200);
        Test.stopTest();
        Assert.areEqual(0, [SELECT Id FROm Task].size(),'No tasks should be created for accounts with order');
    }

    @isTest
    static void cresteTasksForAccountsWithOrders() {
        //create 200 accounts
        List<Account> accList  = new List<Account>();
        for(Integer i=0;i<200;i++){
            accList.add(new Account(Name = 'OC'+i));
        }
        insert accList;
        Test.startTest();
            AccountOrderReminderBatch ba = new AccountOrderReminderBatch();
            Id jobid= Database.executeBatch(ba, 200);
        Test.stopTest();
        Assert.areEqual(200, [SELECT Id FROm Task].size(),'Tasks should be created for accounts without orders');
    }
}