@IsTest
public class WeatherAppControllerTest {
    @IsTest
    public static void doApiCallTest() {
        Weather_Setting__c settingsWeather = new Weather_Setting__c();
        settingsWeather.Forecast_Service_URL__c = 'https://api.openweathermap.org/data/2.5/forecast?q=';
        settingsWeather.Api_Key__c = 'c2d4d6bdaa0b275ed6dee7df69d89f2e';

        insert settingsWeather;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        String response = WeatherAppController.doApiCall('Paris');
        Test.stopTest();
        System.assertEquals('{"example":"test"}', response);
    }

    @isTest
    public static void prepareWrapperTest() {
        WeatherAppController.WeatherWrapper wrapper = WeatherAppController.prepareWrapper('{"example":"test"}');
        
        System.assertNotEquals(NULL, wrapper);
    }

    @isTest
    public static void createCityRecordTest() {
        City__c cityRecord = WeatherAppController.createCityRecord('Paris', 'FR');

        System.assertNotEquals(NULL, cityRecord);
        System.assertNotEquals(NULL, cityRecord.Id);
        System.assertEquals('Paris', cityRecord.Name);
        System.assertEquals('FR', cityRecord.Country__c);
    }

    @isTest
    public static void createForecastsTest() {
        City__c cityRecord = new City__c();
        cityRecord.Name = 'Paris';

        insert cityRecord;

        WeatherAppController.Main main = new WeatherAppController.Main();
        main.temp = 5;
        main.temp_max = 30;
        main.temp_min = -30;

        WeatherAppController.Forecast forecast = new WeatherAppController.Forecast();
        forecast.dt = 1596564000;
        forecast.main = main;

        List<WeatherAppController.Forecast> listForecasts = new List<WeatherAppController.Forecast>();
        listForecasts.add(forecast);

        WeatherAppController.createForecasts(cityRecord, listForecasts);

        List<Forecast__c> forecasts = [SELECT Name, City__c FROM Forecast__c];

        System.assertEquals(1, forecasts.size());
        System.assertEquals('Paris-' + DateTime.newInstance(1000 * (Long) 1596564000).format('DD.MM.YYYY'), forecasts[0].Name);
        System.assertEquals(cityRecord.Id, forecasts[0].City__c);
    }

    @isTest
    public static void getDataTest() {
        WeatherAppController.WeatherWrapper forecastWeather = WeatherAppController.getData('Paris');


        System.assertNotEquals(NULL, forecastWeather);
    }
}