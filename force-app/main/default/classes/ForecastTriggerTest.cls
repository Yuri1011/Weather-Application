@isTest
private class ForecastTriggerTest {
    @isTest  
    public static void forecastTriggerTest() {
        
		Weather_Setting__c settingsWeather = new Weather_Setting__c();
        settingsWeather.Lower_Limit_Message__c = 'the current temperature exceeds the lower limit';
        settingsWeather.Upper_Limit_Message__c = 'the current temperature exceeds the upper limit';
        settingsWeather.Normal_Level_Message__c = 'normal temperature';
        settingsWeather.Upper_Limit__c = 20;	
        settingsWeather.Lower_Limit__c = -5;
        
        insert settingsWeather;
        
        City__c city = new City__c();
        city.Name = 'cityTest';
        city.Country__c = 'AbrTest';

        insert city;
        
		List<Forecast__c> forecastsToInsert = new List<Forecast__c>();
        
        Forecast__c newForecast = new Forecast__c();
        newForecast.Name = 'cityNameTest';
        newForecast.Date__c = Date.today();
        newForecast.Time__c = time.newInstance(01, 01, 01, 0);
        newForecast.Temperature__c = 5;
        newForecast.City__c = city.Id;
        forecastsToInsert.add(newForecast);
        
        Forecast__c newForecast1 = new Forecast__c();
        newForecast1.Name = 'cityNameTest';
        newForecast1.Date__c = Date.today();
        newForecast1.Time__c = time.newInstance(01, 01, 01, 0);
        newForecast1.Temperature__c = -30;
        newForecast1.City__c = city.Id;
		forecastsToInsert.add(newForecast1);
        
        Forecast__c newForecast2 = new Forecast__c();
        newForecast2.Name = 'cityNameTest';
        newForecast2.Date__c = Date.today();
        newForecast2.Time__c = time.newInstance(01, 01, 01, 0);
        newForecast2.Temperature__c = 50;
        newForecast2.City__c = city.Id;
        forecastsToInsert.add(newForecast2);
        
        insert forecastsToInsert;
        
        List<Forecast__c> forecasts = [SELECT Weather_Message__c FROM Forecast__c];       
        System.assertNotEquals(NULL, forecasts[0].Weather_Message__c);
    }
}