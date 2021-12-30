import { LightningElement } from 'lwc';
import getTemperature from '@salesforce/apex/WeatherAppController.getTemperature';
import getCustomSettingsWeather from '@salesforce/apex/WeatherAppController.getCustomSettingsWeather';

export default class WeatherApp extends LightningElement {

    apiKey;
    api;
    forecast;
    city;

    connectedCallback() {
        getCustomSettingsWeather()
        .then(result=>{
            this.api = result.Forecast_Service_URL__c;
            this.apiKey = result.Api_Key__c;
        })
        .catch(error=>{
            console.log('=====',error);
        })
    }

    weatherCheck() {
        // this.forecast = true;
        getTemperature({api: this.api, apiKey: this.apiKey, city: this.city})
        .then(data =>{
            console.log('====== Data', data);
        })
        .catch(error =>{
            console.log('=====errror',error);
        })
    }

    onchangeInputCity(event) {
        this.city = event.target.value;
    }
}