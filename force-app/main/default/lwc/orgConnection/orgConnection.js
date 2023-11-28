import { LightningElement, wire, track } from 'lwc';
import getAccount from '@salesforce/apex/OrgConnectionList.getAccount';
import getContact from '@salesforce/apex/OrgConnectionList.getContact';
import getOpportunity from '@salesforce/apex/OrgConnectionList2.getOpportunity';

import getAccounthisOrg from '@salesforce/apex/OrgConnectionList.getAccounthisOrg';

const columns = [
    { label: 'Account Id', fieldName: 'Id', type: 'String' },
    { label: 'Account Name', fieldName: 'Name', type: 'text',editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'text' },
    { label: 'Website', fieldName: 'Website', type: 'text' },
];

const concolumns = [
    { label: 'Contact Name', fieldName: 'Name', type: 'text', editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'text', editable: true },
    { label: 'Email', fieldName: 'Email', type: 'text', editable: true },
];

const oppcolumns = [
    { label: 'Opportunity Name', fieldName: 'Name', type: 'text', editable: true },
    { label: 'Stage Name', fieldName: 'StageName', type: 'text', editable: true },
    { label: 'CloseDate', fieldName: 'CloseDate', type: 'text', editable: true },
];

export default class OrgConnectionList extends LightningElement {
    @track accountList;
    columns = columns;
    searchKeyword = '';
    selectedAccountId;
    @track contactList;
    concolumns = concolumns;
    thisOrgAccountLIst;
    compairedNames;
searchAccountkey='';

oppotunityList;
    oppcolumns = oppcolumns;
    
    @wire(getAccounthisOrg)
    wiredAccouts({ error, data }) {
        if (data) {
            this.thisOrgAccountLIst = data;
            console.log('thisIS working list::::', this.thisOrgAccountLIst);
        } else if (error) {
            console.error(error);
        }

    }

    @wire(getAccount, { searchTerm: '$searchKeyword' })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountList = data;
            console.log('this.accountList', this.accountList);
            if (this.searchKeyword) {
                this.accountList = this.accountList.filter((account) =>
                    account.Name.toLowerCase().includes(this.searchKeyword.toLowerCase())
                );
            }
        } else if (error) {
            console.error(error);
        }
    }

    handleSearch(event) {
        this.searchKeyword = event.target.value;
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            const selectedAccount = selectedRows[0];
            this.selectedAccountId = selectedAccount.Id;
            console.log('Selected Account ID:', this.selectedAccountId);

            setTimeout(() => {
                getContact({ accountId: this.selectedAccountId })
                    .then(result => {
                        this.contactList = result;
                        console.log('this.contactList', JSON.stringify(this.contactList));
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }, 1000);

            getOpportunity({accountId: this.selectedAccountId })
            .then(result => {
                        this.oppotunityList = result;
                        console.log('this.OppotunityList', JSON.stringify(this.oppotunityList));
                    })
                    .catch(error => {
                        console.error(error);
                    });
        }
    }


    compareAccountLists() {
        if (this.accountList && this.thisOrgAccountLIst) {
            const matchedNames = [];
            for (let account of this.accountList) {
                for (let orgAccount of this.thisOrgAccountLIst) {
                    if (account.Name.toLowerCase() === orgAccount.Name.toLowerCase()) {
                        const matchedName = account.Name;
                        matchedNames.push(matchedName);
                        this.compairedNames = matchedNames;
                        console.log('Match found for account:', this.compairedNames);

                    }
                }
            }
        }
    }

createEmptyRow() {
    const newContact = {
        Id: '',
        Name: '',
        Phone: '',
        Email: ''
    };

    this.contactList = [...this.contactList, newContact];
}

savehandle(event){
        const updatedData = event.detail.draftValues; // USed to get input value from lightning data Table
            console.log('Selected Contact Details draft:',updatedData);

        
}



handleaccKey(event){
    this.searchAccountkey=event.target.value;
    console.log('test Keyword::::',this.searchAccountkey);
}
deleteRow(event) {
    const selectedRowId = event.target.dataset.rowId;
    this.contactList = this.contactList.filter(contact => contact.Id !== selectedRowId);
}

}