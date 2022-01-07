import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/WeatherAppController.getData';

export default class WeatherApp extends LightningElement {
    city;
    dateForecast;
    timeForecast;
    temperatureForecast;

    forecastRecords;

    onchangeInputCity(event) {
        this.city = event.target.value;
    }

    weatherCheck() {
        getData({city: this.city})
        .then(result => {
            this.forecastRecords = result.listForecasts;
            // console.log('====>>> ', this.fore);
            // const arrayDate = [];
            // const arrayTime = [];
            // const arrayTemp = [];
            // result.listForecasts.forEach(item=>{
            //     const currentDate = new Date(item.dt * 1000);
            //     const currentDayOfMonth = currentDate.getDate();
            //     const currentMonth = currentDate.getMonth(); 
            //     const currentYear = currentDate.getFullYear();
            //     const dateForecast = currentDayOfMonth + "-" + (currentMonth + 1) + "-" + currentYear;
            //     arrayDate.push(dateForecast);
            //     this.dateForecast = arrayDate;

            //     const currentHour = currentDate.getHours();
            //     const currentMinutes = currentDate.getMinutes();
            //     const timeForecast = currentHour + ":" + currentMinutes;
            //     arrayTime.push(timeForecast);
            //     this.timeForecast = arrayTime;

            //     const temperatureForecast = item.main.temp;
            //     arrayTemp.push(temperatureForecast);
            //     this.temperatureForecast = arrayTemp;
            // })
        })
        .catch(error =>{
            console.log(error);
        })
    }
}