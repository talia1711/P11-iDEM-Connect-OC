trigger OrderTrigger on Order (after update, before delete) {
    if(trigger.isAfter && trigger.isUpdate){
        OrderHandler.afterUpdate(Trigger.new);
    }
    if(trigger.isBefore && trigger.isDelete){
        OrderHandler.beforeDelete(trigger.old);
    }
}