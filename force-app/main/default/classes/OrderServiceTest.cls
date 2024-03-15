@isTest
public class OrderServiceTest {
   
    @testSetup
    static void setupData(){
        //create 200 accounts
        List<Account> accList  = new List<Account>();
        for(Integer i=0;i<200;i++){
            accList.add(new Account(Name = 'OC'+i));
        }
        insert accList;
        
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
        
        //Create one order per account, total 200 orders
        List<Order> orderList = new List<Order>();
        for(Account acc : accList){
            orderList.add(new Order(AccountId = acc.Id, 
                                   EffectiveDate = Date.newInstance(2024, 1, 1), 
                                   Status = 'Draft', 
                                   Pricebook2Id = Test.getStandardPriceBookId(),
                                    Name = 'Item1'));
        }
        
        insert orderList;
       
       PricebookEntry pbe = new PricebookEntry(
           Pricebook2Id = Test.getStandardPricebookId(),
           Product2Id = pd1.Id,
           UnitPrice = 1020,
           IsActive = true
       );
       insert pbe;
    }


    @isTest
    static void checkRelatedAccountWithOrdersTest(){

       Order orderItem = [SELECT Id, AccountId, Name FROM Order LIMIT 1];

       Test.startTest();
           orderItem.Name = 'Item2';
           update orderItem;
       Test.stopTest();

       Account acc = [SELECT Id, Active__c FROM Account WHERE Id = :orderItem.AccountId LIMIT 1];
       Assert.isTrue(acc.Active__c, 'The account active field should be checked');
    }   
    
    @isTest
    static void checkRelatedAccountWithOrdersBulkTest(){
   	//prepare data
       Set<Id> accountIds = new Set<Id>();
       List<Order> orderList = [SELECT Id, AccountId, Name FROM Order];
 	   for(Order order: orderList){
            order.Name = 'Item2';
            accountIds.add(order.AccountId);
       }
        
       Test.startTest();
           update orderList;
       Test.stopTest();
       
        for(Account acc : [SELECT Id, Active__c FROM Account WHERE Id IN :accountIds]){
            Assert.isTrue(acc.Active__c, 'The account active field should be checked');
        }
 
    }  

    @isTest
    static void checkRelatedAccountWithoutOrdersTest(){
        insert new Account(Name = 'AccWithoutOrder');
        Order orderItem = [SELECT Id, Name FROM Order LIMIT 1];

       Test.startTest();
           orderItem.Name = 'Item2';
           update orderItem;
       Test.stopTest();

       Account acc = [SELECT Id, Active__c FROM Account WHERE Name = 'AccWithoutOrder' LIMIT 1];
       Assert.isFalse(acc.Active__c, 'The account active field should be unchedcked');
    }
    
     @isTest
    static void checkRelatedAccountWithoutOrdersBulkTest(){
        List<Account> accList = new List<Account>();
         for(Integer i=0;i<200;i++){
            accList.add(new Account(Name = 'AccWithoutOrder'+i));
        }
        
        insert accList;
      	List<Order> orderList = [SELECT Id, Name FROM Order];
        
         for(Order order: orderList){
            order.Name = 'Item2';
       }

       Test.startTest();
           update orderList;
       Test.stopTest();
        
       for(Account acc : [SELECT Id, Active__c FROM Account WHERE Name = 'AccWithoutOrder%']){
            Assert.isTrue(acc.Active__c, 'The account active field should be checked');
        }
    }

    @isTest
    static void checkRelatedAccountWithDeletedOrdersTest(){
        Order orderItem = [SELECT Id, AccountId, Name FROM Order LIMIT 1];
        Account acc = [SELECT Id, Active__c FROM Account WHERE Id = :orderItem.AccountId LIMIT 1];
        acc.Active__c = true;
        update acc;
        Test.startTest();
            delete orderItem;
        Test.stopTest();
        Account accWithNoOrder = [SELECT Id, Active__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        Assert.isFalse(accWithNoOrder.Active__c, 'The account active field should be unchecked');

    }
    
    @isTest
    static void checkRelatedAccountWithDeletedOrdersBulkTest(){
        Set<Id> accountIds = new Set<Id>();
        List<Order> orderList = [SELECT Id, AccountId, Name FROM Order];
        
        for(Order order: orderList){
            accountIds.add(order.AccountId);
        }
        
        List<Account> accList = new List<Account>();
        for(Account acc: [SELECT Id, Active__c FROM Account WHERE Id IN :accountIds LIMIT 1]){
            acc.Active__c = true;
            accList.add(acc);
        }
 
        update accList;
        
        Test.startTest();
            delete orderList;
        Test.stopTest();
        
        for(Account accWithNoOrder : [SELECT Id, Active__c FROM Account WHERE Id IN :accountIds]){
            Assert.isFalse(accWithNoOrder.Active__c, 'The account active field should be unchecked');
        }
    }   
}