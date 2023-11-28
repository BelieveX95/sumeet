import { LightningElement, api, wire } from 'lwc';
import accountDetails from '@salesforce/apex/accountRecordController.accountDetails';

export default class AccountDetailslwc extends LightningElement {
    @api recordId;
    accountDetails;

    @wire(accountDetails, { accountId: '$recordId' })
    wiredAccountDetails({ error, data }) {
        if (data) {
            this.accountDetails = data;
            console.log('Account Details:', this.accountDetails);
        } else if (error) {
            console.error('Error retrieving account details:', error);
        }
    }
}