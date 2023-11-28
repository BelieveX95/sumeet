import { LightningElement, api, wire } from 'lwc';
import getOpportunity from '@salesforce/apex/accountRecordController.getOpportunity';

export default class AccountRelatedOpportunity extends LightningElement {
    @api recordId;
    opportunityDetails;
    totalAmount = 0;

    @wire(getOpportunity, { accountId: '$recordId' })
    wiredOpportunity({ data, error }) {
        if (data) {
            this.opportunityDetails = data;
            this.calculateTotalAmount();
        } else if (error) {
            console.error('Error retrieving account details:', error);
        }
    }

    calculateTotalAmount() {
        this.totalAmount = this.opportunityDetails.reduce((total, opportunity) => {
            return total + opportunity.Amount;
        }, 0);
    }
}