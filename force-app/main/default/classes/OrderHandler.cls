/***
 * Author: Talia Ajaz
 * Date: March 2024
 */
public with sharing class OrderHandler {
    public static void afterUpdate(List<Order> newOrders) {
        OrderService.checkRelatedAccount(newOrders);
    }

    public static void afterDelete(List<Order> deletedOrder) {
        OrderService.checkRelatedAccount(deletedOrder);
    }
}