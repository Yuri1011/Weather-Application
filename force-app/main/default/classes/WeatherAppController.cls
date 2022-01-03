public with sharing class WeatherAppController {

  @AuraEnabled (cacheable = true)
  public static void getCustomSettingsWeather(String city) {

    List<Weather_Setting__c> settingsWeather = new List<Weather_Setting__c>();
    settingsWeather =  [SELECT Id, Api_Key__c, Forecast_Service_URL__c FROM Weather_Setting__c ];

    String api;
    String apiKey;

    for (Weather_Setting__c record : settingsWeather) {
      api = record.Forecast_Service_URL__c;
      apiKey = record.Api_Key__c;
    }

    getForecastWeather(api, apiKey, city);
  }

  @AuraEnabled (cacheable = true)
  public static WeatherWrapper getForecastWeather(String api, String apiKey, String city ) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(api + city + '&units=metric' + '&appid=' + apiKey);
    req.setMethod('GET');
    HTTPResponse res = http.send(req);

    WeatherWrapper wrapper = (WeatherWrapper)JSON.deserialize(res.getBody(), WeatherWrapper.class);
    

    Map<String, Object> forecastsMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody()); 
    String jsonList = JSON.serialize(forecastsMap.get('list'));
    List<Forecast> listForecasts = (List<Forecast>) JSON.deserialize(jsonList, List<Forecast>.class);

    wrapper.listForecasts = listForecasts;
    
    String cityName = wrapper.city.name;
    String countryAbr = wrapper.city.country;

    createRecordCity(cityName, countryAbr, listForecasts);
    
    return wrapper;
  }

  @AuraEnabled
  public static void createRecordCity(String cityName, String countryAbr, List<Forecast> listForecasts) {
    City__c recordCity = new City__c();
    recordCity.Name = cityName;
    recordCity.Country__c = countryAbr;

    createForecast(cityName, listForecasts);
    // insert recordCity;
  }

  @AuraEnabled
  public static void createForecast(String cityName, List<Forecast> listForecasts) {

    for (Forecast variable : listForecasts) {
      DateTime dataTimesForecast =  DateTime.newInstance(1000 * (Long) variable.dt);
      Forecast__c newForecast = new Forecast__c();
      newForecast.Name = cityName + '-' + dataTimesForecast.date();
      newForecast.Date__c = dataTimesForecast.date();
      newForecast.Time__c = dataTimesForecast.time();

      // newForecast.Temperature__c = 
    }
  }

  public class WeatherWrapper{
    public City city;
    public List<Forecast> listForecasts;
  }

  public class City{
    public String name;
    public String country;
  }

  public class Forecast{
    public Main main;
    public Integer dt;
  }

  public class Main{
    public Decimal temp;
    public Decimal temp_min;
    public Decimal temp_max;
  }
}
