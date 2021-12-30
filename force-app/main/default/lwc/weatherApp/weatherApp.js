import { LightningElement } from 'lwc';

export default class WeatherApp extends LightningElement {

    forecast;
    weatherCheck() {
        this.forecast = true;
    }

    onchangeInputCity(event) {
      
    }
}