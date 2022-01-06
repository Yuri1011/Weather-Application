trigger ForecastTrigger on Forecast__c (before insert) {

	if (Trigger.isInsert && Trigger.isBefore) {
        ForecastTriggerHandler.doBeforeInsert();
    }
}