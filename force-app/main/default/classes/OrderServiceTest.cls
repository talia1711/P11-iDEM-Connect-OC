@isTest
public class OrderServiceTest {
   
    @testSetup
    static void setupData(){
        Account acc = new Account(Name = 'OC');
        insert acc;
       
       Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
       Insert pd1;
       
       Order newOrder = new Order(AccountId = acc.Id, 
                                  EffectiveDate = Date.newInstance(2024, 1, 1), 
                                  Status = 'Draft', 
                                  Pricebook2Id = Test.getStandardPriceBookId(),
                                  Name = 'Item1');
       insert newOrder;
       
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
    static void checkRelatedAccountWithDeletedOrdersTest(){
        Order orderItem = [SELECT Id, AccountId, Name FROM Order LIMIT 1];
        Account acc = [SELECT Id, Active__c FROM Account WHERE Id = :orderItem.AccountId LIMIT 1];
        acc.Active__c = true;
        update acc;
        Test.startTest();
            delete orderItem;
        Test.stopTest();
        Account accWithNoOrder = [SELECT Id, Active__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        Assert.isFalse(acc.Active__c, 'The account active field should be unchedcked');

    }   

}