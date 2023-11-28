import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCase from '@salesforce/apex/CaseRecordFormController.createCase';

export default class CreateCase extends LightningElement {
    @track subject = '';
    @track description = '';
    @track caseRecordId;
    @track detailsList = [];
    @track attachmentsList = [];
     


    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Case created successfully',
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        console.log('fields to share', fields);

       
        if (this.attachmentData) {
            const reader = new FileReader();
            reader.onloadend = () => {
                const attachmentBody = reader.result.split(',')[1];
                createCase({
                    subject: fields.Subject,
                    description: fields.Description,
                    accountId: fields.AccountId,
                    contactId: fields.ContactId,
                    type: fields.Type,
                    reason: fields.Reason,
                    status: fields.Status,
                    origin: fields.Origin,
                    attachmentName: this.attachmentData.name,
                    attachmentBody: attachmentBody,
                    attachments: JSON.stringify(this.attachmentsList)

                })
                    .then(caseId => {
                        this.handleSuccess();
                        window.location.reload();
                    })
                    .catch(error => {
                        console.error(error);
                    });
            };
            reader.readAsDataURL(this.attachmentData);
        } else {
        }
    }

    handleDeleteFile(event) {
        const fileId = event.currentTarget.dataset.fileId;
        console.log('fileId', fileId);
        console.log('Before filter:', JSON.stringify(this.detailsList));

        this.detailsList = this.detailsList.filter(file => file.id != fileId);
        console.log('After filter:', JSON.stringify(this.detailsList));
    }


    handleFileChange(event) {
        const file = event.target.files[0];

        if (file) {
            if (this.detailsList.length >= 4) {
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: 'You can only upload up to 4 files.',
                    variant: 'error'
                });
                this.dispatchEvent(toastEvent);
                return;
            }

            const fileDetails = {
                id: Date.now(),
                name: file.name,
                type: file.type,
                size: file.size
            };
            this.attachmentData = file;
            this.detailsList.push(fileDetails);
            console.log('this.detailsList push', JSON.stringify(this.detailsList));
        }

        const reader = new FileReader();
        reader.onload = () => {
            const attachmentData = reader.result.split(',')[1];
            const attachment = {
                id: Date.now(),
                name: file.name,
                body: attachmentData
            };
            this.attachmentsList.push(attachment);
            console.log('this.attachmentsList push', JSON.stringify(this.attachmentsList));
        };
        reader.readAsDataURL(file);
    }
}