trigger ForecastTrigger on Forecast__c (before insert) {

	if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            ForecastTriggerHandler.fillFieldWeatherMessage();
            ForecastTriggerHandler.deleteDublicateForecastForCity();
        }     
    }
}