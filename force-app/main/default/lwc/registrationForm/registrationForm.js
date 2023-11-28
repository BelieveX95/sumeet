// registrationForm.js
import { LightningElement, track } from 'lwc';

export default class RegistrationForm extends LightningElement {
    @track name = '';
    @track mobile = '';
    @track email = '';

  
    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleMobileChange(event) {
        this.mobile = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleSubmit() {
        // Access the values of Name, Mobile, and Email
        console.log('Name: ' + this.name);
        console.log('Mobile: ' + this.mobile);
        console.log('Email: ' + this.email);

        // Add your logic to handle the form submission here

        // Optionally, reset the input fields after submission
        this.resetForm();
    }

    handleCancel() {
        // Reset the input fields when the Cancel button is clicked
        this.resetForm();

        // Handle form cancellation logic here
        console.log('Form cancelled.');
    }

    resetForm() {
        // Reset the tracked properties to their initial state
        this.name = '';
        this.mobile = '';
        this.email = '';

        // Log a message to check if resetForm is called
        console.log('Form reset');
    }
}
