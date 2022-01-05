public with sharing class WeatherAppController {

  @AuraEnabled
  public static WeatherWrapper getCustomSettingsWeather(String city) {

    Weather_Setting__c settingsWeather = Weather_Setting__c.getOrgDefaults();

    WeatherWrapper forecastWeather = getForecastWeather(settingsWeather, city);

    return forecastWeather;
  }

  public static WeatherWrapper getForecastWeather(Weather_Setting__c settingsWeather, String city ) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(settingsWeather.Forecast_Service_URL__c + city + '&units=metric' + '&appid=' + settingsWeather.Api_Key__c);
    req.setMethod('GET');
    HTTPResponse res = http.send(req);

    WeatherWrapper wrapper = (WeatherWrapper)JSON.deserialize(res.getBody(), WeatherWrapper.class);
    
    Map<String, Object> forecastsMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody()); 
    String jsonList = JSON.serialize(forecastsMap.get('list'));
    List<Forecast> listForecasts = (List<Forecast>) JSON.deserialize(jsonList, List<Forecast>.class);

    wrapper.listForecasts = listForecasts;
    
    String cityName = wrapper.city.name;
    String countryAbr = wrapper.city.country;

    City__c recordCity = createRecordCity(cityName, countryAbr);
    createForecast(recordCity, listForecasts);
    
    return wrapper;
  }

  public static City__c createRecordCity(String cityName, String countryAbr) {
    City__c recordCity = new City__c();
    recordCity.Name = cityName;
    recordCity.Country__c = countryAbr;

    insert recordCity;

    return recordCity;
  }

  public static void createForecast(City__c recordCity, List<Forecast> listForecasts) {

    List<Forecast__c> recordsForecast = new List<Forecast__c>();

    for (Forecast variable : listForecasts) {
      DateTime dataTimesForecast =  DateTime.newInstance(1000 * (Long) variable.dt);
      Forecast__c newForecast = new Forecast__c();
      newForecast.Name = recordCity.Name + '-' + dataTimesForecast.format('DD.MM.YYYY');
      newForecast.Date__c = dataTimesForecast.date();
      newForecast.Time__c = dataTimesForecast.time();     
      newForecast.Temperature__c = variable.main.temp;
      newForecast.City__c = recordCity.Id;
      recordsForecast.add(newForecast); 
    }

    insert recordsForecast;
  }

  public class WeatherWrapper{
  @AuraEnabled
    public City city;

  @AuraEnabled
    public List<Forecast> listForecasts;
  }

  public class City{
  @AuraEnabled
    public String name;

  @AuraEnabled
    public String country;
  }

  public class Forecast{
  @AuraEnabled
    public Main main;

  @AuraEnabled
    public Integer dt;
  }

  public class Main{
  @AuraEnabled
    public Decimal temp;

  @AuraEnabled
    public Decimal temp_min;

  @AuraEnabled
    public Decimal temp_max;
  }
}
