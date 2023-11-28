import { LightningElement, track,api } from 'lwc';

export default class ProgressBarDemo extends LightningElement {
    
    @track lightningOutAppUrl;

    connectedCallback() {
        // Replace 'YourNamespace' with your Salesforce namespace
        this.lightningOutAppUrl = `/c/AuraApplication.app`;

        console.log(this.lightningOutAppUrl);
    }
}