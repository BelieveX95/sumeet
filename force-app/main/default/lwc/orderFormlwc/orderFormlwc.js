import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import searchAccounts from '@salesforce/apex/OrderFormController.searchAccounts';

export default class AccountSearchBox extends LightningElement {
    @track searchKey = '';
    @track accounts = [];
    @track selectedAccount = {};
    @track error;
     poNumber = '';
    poDate = '';
    address = {};

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.searchAccounts();

        
    }

    searchAccounts() {
        searchAccounts({ searchKey: this.searchKey })
            .then(result => {
                this.accounts = result;
            })
            .catch(error => {
                this.accounts = [];
                this.error = error;
                console.error('Error fetching accounts:', error);
            });
    }

    handleAccountSelect(event) {
        const accountId = event.currentTarget.dataset.accountId;
        const selectedAccount = this.accounts.find((account) => account.Id === accountId);
        this.selectedAccount = selectedAccount;
                      console.log('this.selectedAccount)',JSON.stringify(this.selectedAccount));

        this.searchKey = selectedAccount.Name;
        this.accounts = [];
         this.sendOrderDataToParent();
    }

    handleInputChange(event) {
        const fieldName = event.target.name;
        const fieldValue = event.target.value;
        if (fieldName === 'PO Number') {
            this.poNumber = fieldValue;
              console.log('this.poNumber)',JSON.stringify(this.poNumber));
              this.sendOrderDataToParent();
        } else if (fieldName === 'PO Date') {
            this.poDate = fieldValue;
              console.log('this.poDate)',JSON.stringify(this.poDate));
        }

    }

  handleAddressChange(event) {
  const addressFields = event.target.value;
  console.log('Street => ' , event.target.street);
    console.log('City => ' , event.target.city);
    console.log('Province => ' , event.target.province);
    console.log('Country => ' , event.target.country);
    console.log('postal Code => ' , event.target.postalCode);
         
           this.sendOrderDataToParent();

//   this.address = {
//     street: addressFields.street,
//     city: addressFields.city,
//     country: addressFields.country,
//     province: addressFields.province,
//     postalCode: addressFields.postalCode
//   };
//            this.sendOrderDataToParent();

}


   
  sendOrderDataToParent() {
    const orderData = {
        accountId: this.selectedAccount.Id,
        poNumber: this.poNumber,
        // poDate: this.poDate,
        address: this.address,
        accountName :this.selectedAccount
    };

    const event = new CustomEvent('orderdata', {
        detail: orderData
    });

    this.dispatchEvent(event);

    console.log('this.dispatchEvent',this.dispatchEvent);
}
 refreshApexCache() {
        refreshApex(searchAccounts);
    }

}