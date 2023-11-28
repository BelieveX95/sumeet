import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/getContactscontroller.getContacts';
import saveContacts from '@salesforce/apex/getContactscontroller.saveContacts';
import deleteContact from '@salesforce/apex/getContactscontroller.deleteContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class GetContactList extends LightningElement {
  contacts;
  filteredContacts;
  error;
  originalContacts;
  @track isLoading = false;


  @wire(getContacts)
  wiredcontacts({ error, data }) {
    if (data) {
      this.contacts = data.map((wrapper) => {
        return {
          ...wrapper.contact,
          isEditing: wrapper.isEditing
        };
      });
      this.filteredContacts = this.contacts;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.contacts = undefined;
      this.filteredContacts = undefined;
    }
  }

  handleSearch(event) {
    const searchQuery = event.detail.searchQuery;
    console.log('test-> ', searchQuery);

    this.filteredContacts = this.contacts.filter((con) =>
      (con.FirstName ? con.FirstName.toLowerCase().includes(searchQuery) : false) ||

      con.LastName.toLowerCase().includes(searchQuery) ||
      con.Phone.toLowerCase().includes(searchQuery) ||
      (con.Email ? con.Email.toLowerCase().includes(searchQuery) : false)

    );
  }

  handleEdit(event) {
    const recordId = event.target.dataset.recordId;
    this.originalContacts = JSON.parse(JSON.stringify(this.contacts));
    this.contacts = this.contacts.map((contact) => {
      if (contact.Id === recordId) {
        return { ...contact, isEditing: true };
      }
      return contact;
    });
    this.filteredContacts = [...this.contacts];
  }



  handleInputChange(event) {
    const recordId = event.target.dataset.recordId;
    console.log('recordId inputid', recordId);
    const fieldName = event.target.name;
    console.log('fieldName NAme', fieldName);
    const inputValue = event.target.value;

    this.contacts = this.contacts.map((contact) => {
      if (contact.Id === recordId) {
        return { ...contact, [fieldName]: inputValue };
      }
      return contact;
    });

    this.filteredContacts = [...this.contacts];
  }




  handleSave(event) {
    const recordId = event.target.dataset.recordId;
    console.log('### Record Id for saving record', recordId);

    const editedContact = this.contacts.find((contact) => contact.Id === recordId);

    const contactWrapper = {
      contact: editedContact,
      isEditing: false
    };
    this.isLoading = true;

    saveContacts({ contactList: [contactWrapper] })
      .then(() => {
        this.contacts = this.contacts.map((contact) => {
          if (contact.Id === recordId) {
            return { ...contact, isEditing: false };
          }
          return contact;

        });
        this.filteredContacts = [...this.contacts];

        const toastMessage = ` ${editedContact.LastName} (${editedContact.Id}) has been updated.`;

        this.showToast('success', 'Contact Updated', toastMessage);
        this.isLoading = false;

      })
      .catch((error) => {
        console.error('Error saving contact: ', error);
        let errorMessage = 'Unknown error occurred.';

        if (error.body && error.body.message) {
          errorMessage = error.body.message;
        }

        this.showToast('error', 'Contact Update Failed', errorMessage);
        this.isLoading = false;
      });

  }

  handleDelete(event) {
    const recordId = event.target.dataset.recordId;
    console.log('recordId for Delete', recordId);

    this.isLoading = true;
    const deletedContact = this.contacts.find((contact) => contact.Id === recordId);

    deleteContact({ recordId })
      .then(() => {
        this.contacts = this.contacts.filter((contact) => contact.Id !== recordId);
        this.filteredContacts = [...this.contacts];
        this.isLoading = false;

        const toastMessage = `Contact ${deletedContact.LastName} (${deletedContact.Id}) has been deleted.`;
        this.showToast('success', 'Contact Deleted', toastMessage);
      })
      .catch((error) => {
        console.error('Error saving contact: ', error);

        let errorMessage = 'Unknown error occurred.';
        if (error.body && error.body.message) {
          errorMessage = error.body.message;
        }

        this.showToast('error', 'Contact Delete Failed', errorMessage);
        this.isLoading = false;
      });

  }


  handleCancel(event) {
    const recordId = event.target.dataset.recordId;

    this.contacts = this.contacts.map((contact) => {
      if (contact.Id === recordId) {
        const originalContact = this.originalContacts.find((originalContact) => originalContact.Id === recordId);
        return { ...originalContact, isEditing: false };
      }
      return contact;
    });

    this.filteredContacts = [...this.contacts];
  }



  showToast(variant, title, message) {
    const event = new ShowToastEvent({
      variant: variant,
      title: title,
      message: message
    });
    this.dispatchEvent(event);
  }
}