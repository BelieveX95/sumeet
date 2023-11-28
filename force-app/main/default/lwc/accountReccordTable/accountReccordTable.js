import { LightningElement, wire, api } from 'lwc';
import getAccountRecord from '@salesforce/apex/accountRecordController.getAccountRecord';

export default class AccountRecordTable extends LightningElement {
    @api accounts;
    filteredAccounts;
    searchKey = '';

   @wire(getAccountRecord)
wiredAccounts({ error, data }) {
    if (data) {
        this.accounts = data.map(accountWrapper => {
            const account = accountWrapper.account;
            const contactSize = accountWrapper.contactSize;
            console.log('Sizeof Con@@',contactSize);
            return { ...account, contactSize };
        });
        this.filteredAccounts = this.accounts;
    } else if (error) {
        // Handle error
    }
}
 

    handleRowclick(event) {
        const selectedRowId = event.currentTarget.dataset.recordId;
        this.dispatchEvent(new CustomEvent('recorselectid', { detail: selectedRowId }));
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.filterAccounts();
    }

filterAccounts() {
    if (this.searchKey) {
        this.filteredAccounts = this.accounts.filter(
            acc => acc.Name.toLowerCase().includes(this.searchKey.toLowerCase())
        );
    } else {
        this.filteredAccounts = this.accounts;
    }
}

    sortByName(event) {
        const sortedAccounts = [...this.filteredAccounts];
        sortedAccounts.sort((a, b) => {
            return a.account.Name.localeCompare(b.account.Name);
        });
        this.filteredAccounts = sortedAccounts;
    }

    
}