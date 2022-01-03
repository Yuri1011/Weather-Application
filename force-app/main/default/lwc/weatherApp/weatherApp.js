import { LightningElement } from 'lwc';
import getCustomSettingsWeather from '@salesforce/apex/WeatherAppController.getCustomSettingsWeather';

export default class WeatherApp extends LightningElement {
    city;

    onchangeInputCity(event) {
        this.city = event.target.value;
    }

    weatherCheck() {
        getCustomSettingsWeather({city: this.city});
    }
}