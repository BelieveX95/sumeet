import { LightningElement, track, wire } from 'lwc';
import getOccupationOptions from '@salesforce/apex/MetadataController.getOccupationOptions';
import empolyeeDetails from '@salesforce/apex/DemoWrapperClass.empolyeeDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmployeeForm extends LightningElement {
    @track employeeName = '';
    @track employeeStatus = '';
    @track occupation = '';
    @track industry = '';

    @track metadataRecord = [];

    statusOptions = [
        { label: 'Homemaker', value: 'Homemaker' },
        { label: 'Self Employeed', value: 'Self Employeed' },
        { label: 'Student', value: 'Student' },
        { label: 'Employed', value: 'Employed' }


    ];

    occupationOptions = [
        { label: 'Manager', value: 'Manager' },
        { label: 'Developer', value: 'Developer' },
        { label: 'Student', value: 'Student' },
        { label: 'Unemployeed ', value: 'Unemployeed' },

    ];

    industryOptions = [
        { label: 'Technology', value: 'Technology' },
        { label: 'Finance', value: 'Finance' },
        { label: 'Agree', value: 'Agree' },
        { label: 'Pharma', value: 'Pharma' },

    ];

    @wire(getOccupationOptions)
    wiredOccupationOptions({ error, data }) {
        if (data) {
            this.metadataRecord = data;
            console.log(this.metadataRecord);
        }
    }

    handleNameChange(event) {
        this.employeeName = event.target.value;
    }

    handleStatusChange(event) {
        this.employeeStatus = event.target.value;
        console.log(' this.employeeStatus', this.employeeStatus);
        this.industry = '';
        this.occupation = '';
        this.updateFieldAvailability();
    }

    handleOccupationChange(event) {
        this.occupation = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.target.value;
    }



    updateFieldAvailability() {
        const matchingRecord = this.metadataRecord.find(record => record.MasterLabel == this.employeeStatus);
        console.log('matchingRecord', matchingRecord);
        console.log('matchingRecord.Industry__c:', matchingRecord.Industry__c);
        console.log('matchingRecord.Occupation__c:', matchingRecord.Occupataion__c);
        const occupationOptionsDropdown = this.template.querySelector('.occupationOptions');
        console.log('occupationOptionsDropdown', occupationOptionsDropdown);
        const industryOptionsDropdown = this.template.querySelector('.industryOptions');
        console.log('industryOptionsDropdown', industryOptionsDropdown);

        if (matchingRecord) {
            if (matchingRecord.Industry__c == true) {

                industryOptionsDropdown.disabled = false;
                industryOptionsDropdown.required = true;
            } else {
                industryOptionsDropdown.disabled = true;
                industryOptionsDropdown.required = false;

            }
        }
        if (matchingRecord) {
            if (matchingRecord.Occupataion__c == true) {

                occupationOptionsDropdown.disabled = false;
                occupationOptionsDropdown.required = true;
            } else {
                occupationOptionsDropdown.disabled = true;
                occupationOptionsDropdown.required = false;

            }
        }
    }

    handleSave() {
        const uniqueId = 'EM00' + Date.now() + Math.floor(Math.random() * 1000);

        const matchingRecord = this.metadataRecord.find(record => record.MasterLabel === this.employeeStatus);
        if (matchingRecord) {
            const industryRequired = matchingRecord.Industry__c;
            const occupationRequired = matchingRecord.Occupataion__c;

            if ((industryRequired && !this.industry) || (occupationRequired && !this.occupation)) {
                this.showToast('Error', 'Required field(s) are missing.', 'error');
                return;
            }
        }
        if (!this.employeeName) {
            this.showToast('Error', 'Employee name is required.', 'error');
            return;
        }


        const employeedetailsllst = [{
            id: uniqueId,
            employeeName: this.employeeName,
            employeeStatus: this.employeeStatus,
            occupation: this.occupation,
            industry: this.industry

        }];

        console.log('employeedetailsllst', JSON.stringify(employeedetailsllst));
        empolyeeDetails({ employeeslist: JSON.stringify(employeedetailsllst) })

            .then((result) => {
                console.log('Save Successfully', result);
                this.showToast('Success', result, 'success');
                this.employeeName = '';
                this.employeeStatus = '';
                this.industry = '';
                this.occupation = '';

            }).catch((error) => {
                console.log('Error Occoured', error);
                this.showToast('Error', 'An error occurred.', 'error');


            });
    }



    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }



        @track isShowModal = false;
    @track button1Variant = 'brand';
    @track button2Variant = 'natural';

    showModalBox() {
        this.isShowModal = true;
    }

    hideModalBox() {
        this.isShowModal = false;
    }

    changeButton(event) {
        const buttonId = event.target.dataset.id;

        if (buttonId === 'button1') {
            this.button1Variant = 'brand';
            this.button2Variant = 'natural';
        } else if (buttonId === 'button2') {
            this.button1Variant = 'natural';
            this.button2Variant = 'brand';
        }
    }



 @track orderNumber = '';
    @track label = '';

    handleOrderNumberChange(event) {
        this.orderNumber = event.target.value;
    }

    generateLabel() {
        // You can replace this with your label generation logic.
        // For now, we'll just display the order number.
        this.label = `Order Label for ${this.orderNumber}`;
    }

}