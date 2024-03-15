/***
 * Author: Talia Ajaz
 * Date: March 2024
 * Trigger for Order object
 */
trigger OrderTrigger on Order (after update, after delete) {
    if(trigger.isAfter && trigger.isUpdate){
        OrderHandler.afterUpdate(Trigger.new);
    }
    if(trigger.isAfter && trigger.isDelete){
        OrderHandler.afterDelete(trigger.old);
    }
}