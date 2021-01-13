trigger sidplatformtest on sidtest__e (after insert) {
	Account acc = new Account();
    acc.Name = 'sidtest Platform';
    insert acc;
    system.debug('acc ' + acc);
}