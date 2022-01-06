public with sharing class WeatherAppController {
    static String METRIC = '&units=metric';
    static String APPID = '&appid=';
    static String QUERY_METHOD = 'GET';

    @AuraEnabled
    public static WeatherWrapper getData(String city) {
        try {
            String response = doApiCall(city);
            WeatherWrapper forecastWeather = prepareWrapper(response);
            City__c cityRecord = createCityRecord(forecastWeather.city.name, forecastWeather.city.country);
            createForecasts(cityRecord, forecastWeather.listForecasts);

            return forecastWeather;

        } catch (Exception e) {
            String errorMsg = e.getMessage();
            throw new AuraHandledException(errorMsg);
        }
    }

    public static String doApiCall(String city) {
        Weather_Setting__c settingsWeather = Weather_Setting__c.getOrgDefaults();

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(settingsWeather.Forecast_Service_URL__c + city + METRIC + APPID + settingsWeather.Api_Key__c);
        req.setMethod(QUERY_METHOD);
        HTTPResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('The status code returned was not expected: ' + res.getStatusCode());
        } else {
            return res.getBody();
        }
    }

    public static WeatherWrapper prepareWrapper(String response) {
        WeatherWrapper wrapper = (WeatherWrapper)JSON.deserialize(response, WeatherWrapper.class);
        
        Map<String, Object> forecastsMap = (Map<String, Object>) JSON.deserializeUntyped(response);
        String jsonList = JSON.serialize(forecastsMap.get('list'));
        List<Forecast> listForecasts = (List<Forecast>) JSON.deserialize(jsonList, List<Forecast>.class);
        wrapper.listForecasts = listForecasts;

        return wrapper;
    }

    public static City__c createCityRecord(String cityName, String countryAbr) {
        City__c cityRecord = new City__c();
        cityRecord.Name = cityName;
        cityRecord.Country__c = countryAbr;

        insert cityRecord;

        return cityRecord;
    }

    public static void createForecasts(City__c cityRecord, List<Forecast> listForecasts) {

        List<Forecast__c> recordsForecast = new List<Forecast__c>();

        for (Forecast variable : listForecasts) {
            DateTime dataTimesForecast = DateTime.newInstance(1000 * (Long) variable.dt);
            Forecast__c newForecast = new Forecast__c();
            newForecast.Name = cityRecord.Name + '-' + dataTimesForecast.format('DD.MM.YYYY');
            newForecast.Date__c = dataTimesForecast.date();
            newForecast.Time__c = dataTimesForecast.time();         
            newForecast.Temperature__c = variable.main.temp;
            newForecast.City__c = cityRecord.Id;
            recordsForecast.add(newForecast); 
        }

        insert recordsForecast;
    }

    public class WeatherWrapper{
        @AuraEnabled public City city;
        @AuraEnabled public List<Forecast> listForecasts;
    }

    public class City{
        @AuraEnabled public String name;
        @AuraEnabled public String country;
    }

    public class Forecast{
        @AuraEnabled public Main main;
        @AuraEnabled public Integer dt;
    }

    public class Main{
        @AuraEnabled public Decimal temp;
        @AuraEnabled public Decimal temp_min;
        @AuraEnabled public Decimal temp_max;
    }
}
