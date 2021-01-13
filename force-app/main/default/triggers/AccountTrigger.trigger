trigger AccountTrigger on Account (before insert, before update) {
    
    for(Account acc: trigger.new) {
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            system.debug('@@@@@ ' + acc.Name);
            acc.Name = acc.Name.toLowerCase();
            system.debug('@@@@@ ' + acc.Name);
        }
    }
    
}