import { LightningElement } from 'lwc';
export default class OrderFormlwcMain extends LightningElement {
accId;
poNum;
poDat;
addr;
accName;
handleOrderData(event) {
                const orderData = event.detail;
                const accountId = orderData.accountId;
                this.accId = accountId;
                const poNumber = orderData.poNumber;
                this.poNum = poNumber;

                const poDate = orderData.poDate;
                this.poDat = poDate;

                const address = orderData.address;
                this.addr = address;

                const accountName = orderData.accountName;
                this.accName = accountName;

                console.log('AccountId On parent', JSON.stringify(accountId));
                console.log('poNumber', JSON.stringify(poNumber));
                console.log('poDate', JSON.stringify(poDate));
                console.log('On Parent Got address', JSON.stringify(address));
                console.log('accountName', JSON.stringify(accountName));



        }
}