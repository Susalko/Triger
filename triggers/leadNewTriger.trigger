trigger leadNewTriger on Lead (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            LeadHendlerTriger.beforeInsert(Trigger.New);
        }
    }
}