import { LightningElement } from 'lwc';
import getTemperature from '@salesforce/apex/WeatherAppController.getTemperature';
import getCustomSettingsWeather from '@salesforce/apex/WeatherAppController.getCustomSettingsWeather';
import createRecordCity from '@salesforce/apex/WeatherAppController.createRecordCity';
import createForecast from '@salesforce/apex/WeatherAppController.createForecast';

export default class WeatherApp extends LightningElement {

    apiKey;
    api;
    forecast;
    city;
    forecastWeather;
    nameCity;
    countryAbr;
    dateForecast;
    timeForecast;
    tempForecast;
    messageWeather;

    connectedCallback() {
        getCustomSettingsWeather()
        .then(result=> {
            this.api = result.Forecast_Service_URL__c;
            this.apiKey = result.Api_Key__c;
        })
        .catch(error=> {
            console.log(error);
        })
    }
    
    onchangeInputCity(event) {
        this.city = event.target.value;
    }

    weatherCheck() {
        // this.forecast = true;
        getTemperature({api: this.api, apiKey: this.apiKey, city: this.city})
        .then(data => {
            this.forecastWeather = JSON.parse(data);
            this.nameCity = this.forecastWeather.city.name;
            this.countryAbr = this.forecastWeather.city.country;

            this.forecastWeather.list.forEach(elem => {
                this.dateForecast = elem.dt_txt.slice(0, 10);
                this.timeForecast = elem.dt_txt.slice(11, 20).trim();
                this.tempForecast = elem.main.temp;
                const nameForecastCity = `${this.forecastWeather.city.name}-${this.dateForecast.replace(/-/g, '.')}`;
                createForecast({nameForecastCity: nameForecastCity, 
                    dateForecast: this.dateForecast, 
                    timeForecast: this.timeForecast,
                    tempForecast: this.tempForecast,});

                    console.log('time===>>>',this.dateForecast);

            });

            createRecordCity({nameCity: this.nameCity, countryAbr: this.countryAbr});
           
            // const listForecast = this.forecastWeather.list;

            // console.log('====== Data', this.forecastWeather.list);
        })
        .catch(error => {
            console.log(error);
        })
    }
}