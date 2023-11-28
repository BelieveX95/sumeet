import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getProductTypePicklistValues from '@salesforce/apex/OrderFormController.getProductTypePicklistValues';
import getRoundSectionPicklistValues from '@salesforce/apex/OrderFormController.getRoundSectionPicklistValues';
import createOrder from '@salesforce/apex/OrderFormController.createOrder';
import getProductName from '@salesforce/apex/OrderFormController.getProductName';

export default class YourComponent extends NavigationMixin(LightningElement) {
  picklistValues = [];
  roundSectionValues = [];
  selectedProductType = '';
  selectedRoundSection = '';
  productName = '';
  items = [];
orproductId;
orproductName;
ororderId;
  @api accountId;
  @api poNumber;
  @api poDate;
  @api address;
  @api accountName;

      recordId;


  handleOrderData(event) {
    const orderData = event.detail;
    this.accountId = orderData.accountId;
    this.poNumber = orderData.poNumber;
    this.poDate = orderData.poDate;
    this.address = orderData.address;
    console.log('AccountIdCHild', JSON.stringify(this.accountId));
  }

  @wire(getProductTypePicklistValues)
  wiredPicklistValues({ error, data }) {
    if (data) {
      this.picklistValues = data;
      console.log('Getting product type picklist', JSON.stringify(this.picklistValues));
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getRoundSectionPicklistValues)
  wiredRoundSectionValues({ error, data }) {
    if (data) {
      this.roundSectionValues = data;
      console.log('Getting round section picklist', JSON.stringify(this.roundSectionValues));
    } else if (error) {
      console.error(error);
    }
  }

  handleAddress(event){
  let adddtest = event.target.detail;
    console.log('adddtest => ' , JSON.stringify(adddtest));

   console.log('Street => ' , event.target.street);
    console.log('City => ' , event.target.city);
    console.log('Province => ' , event.target.province);
    console.log('Country => ' , event.target.country);
    console.log('postal Code => ' , event.target.postalCode);

  }

  handleProductTypeChange(event) {
    this.selectedProductType = event.target.value;
    console.log('Checking log product selectedProductType', JSON.stringify(this.selectedProductType));
    this.updateProductName();
  }

  handleRoundSectionChange(event) {
    const { key } = event.target.dataset;
    const selectedSection = event.target.value;
    console.log('Checking log product selectedRoundSection', JSON.stringify(selectedSection));
    this.updateProductName(key, selectedSection);
  }

 updateProductName(key, section) {
    if (this.selectedProductType && section) {
        getProductName({
            productType: this.selectedProductType,
            section: section
        })
        .then(result => {

            const itemIndex = this.items.findIndex(item => item.key === key);
            if (itemIndex !== -1) {
                this.items[itemIndex].productName = result.productName;
                this.items[itemIndex].productId = result.productId;
                this.items = [...this.items];
          this.orproductName = result.productName; 
          this.orproductId = result.productId; 

            }
            console.log('Checking log product name', JSON.stringify(this.items[itemIndex].productName));
            console.log('Checking log product ID', JSON.stringify(this.items[itemIndex].productId));
        })
        .catch(error => {
            console.error('Error fetching product name', error);
        });
    }
}

  handleClick() {
    const newItem = {
      key: Date.now().toString(),
      productName: this.productName,
      quantity: 0
    };

    this.items = [...this.items, newItem];
  }

  handleDeleteRow(event) {
  const { key } = event.target.dataset;

  this.items = this.items.filter(item => item.key !== key);
}



  handleQuantityChange(event) {
    const { key } = event.target.dataset;
    const newQuantity = parseInt(event.target.value, 10);

    this.items = this.items.map(item => {
      if (item.key === key) {
        return { ...item, quantity: newQuantity };
      }
      return item;
    });
  }

  get totalQuantity() {
    return this.items.reduce((total, item) => total + item.quantity, 0);
  }

  handleCancel() {
    this.selectedRoundSection = '';
    this.productName = '';
    this.items = [];
  }

  handleSave() {
  const newOrder = {
    accountId: this.accountId,
    poDate: this.poDate,
    status: 'Draft',
    accountName: this.accountName,
    productId: this.orproductId,
    quantity: this.totalQuantity 
  };

  createOrder({
    accountId: newOrder.accountId,
    poDate: newOrder.poDate,
    status: newOrder.status,
    productId: newOrder.productId,
    quantity: newOrder.quantity
  })
    .then(result => {
      console.log('Order created successfully:', result);
      this.recordId = result;
      this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
          recordId: this.recordId,
          objectApiName: 'Order',
          actionName: 'view'
        }
      });

       setTimeout(() => {
        window.location.reload();
      }, 1000);

    })
    .catch(error => {
console.error('Error creating order:', error.message);
    });
}


}