trigger ForecastTrigger on Forecast__c (before insert, after insert) {
	 if (Trigger.isInsert) {
        if (Trigger.isBefore) {
           ForecastTriggerHandler.fillFieldWeatherMessage();
        } else if (Trigger.isAfter) {

        }        
    }
}