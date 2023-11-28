import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getContacts from '@salesforce/apex/accountRecordController.getContacts';
import saveContacts from '@salesforce/apex/accountRecordController.saveContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AccountReletedContactlwc extends LightningElement {
  @api recordId;
  contacts;
  wiredContactsResult;
  @track conDetails = [];
  updatedContacts;
  contactSize;

  @wire(getContacts, { accountId: '$recordId' })
  wiredContacts(result) {
    this.wiredContactsResult = result;
    if (result.data) {
      this.contacts = result.data;
            this.contactSize = this.contacts.length;

      console.log('contacts => ', JSON.stringify(this.contacts.length));

    } else if (result.error) {
    }
  }

handleFieldChange(event) {
  const fieldName = event.target.name;
  const fieldValue = event.target.value;
  const index = event.target.dataset.index;

  const updatedContacts = [...this.conDetails];
  updatedContacts[index][fieldName] = fieldValue;

  this.conDetails = updatedContacts;
}



 handleAddContact() {
  this.conDetails = [...this.conDetails, { lastName: '', phone: '', email: '' }];
}




 handleRemoveContact(event) {
  const index = parseInt(event.target.dataset.index, 10);
  this.conDetails = this.conDetails.filter((_, i) => i !== index);
}


handleSaveContacts() {
  const accountId = this.recordId;

  const hasEmptyFields = this.conDetails.some(contact => !contact.lastName || !contact.phone || !contact.email);

  if (hasEmptyFields) {
    this.showToast('error', 'Error', 'Required field(s) missing');
    return;
  }

  const contactsToSave = this.conDetails.map(contact => ({
    LastName: contact.lastName,
    Phone: contact.phone,
    Email: contact.email
  }));

  saveContacts({ accountId, contacts: contactsToSave })
    .then(() => {
      console.log('Contacts saved successfully.');
      this.showToast('success', 'Contact Updated');
      return refreshApex(this.wiredContactsResult);
    })
    .catch(error => {
      console.error('Error occurred while saving contacts:', error);
    })
    .finally(() => {
      this.conDetails = [];
    });
}

 showToast(variant, title, message) {
    const event = new ShowToastEvent({
      variant: variant,
      title: title,
      message: message
    });
    this.dispatchEvent(event);
      // window.location.reload();

  }

}