import { LightningElement, wire } from 'lwc';
import getCases from '@salesforce/apex/CaseIntegrationClass.getCases';
import updateCase from '@salesforce/apex/CaseIntegrationClass.updateCase';
import getProductOptions from '@salesforce/apex/CaseIntegrationClass.getProductOptions';

export default class CaseIntegration extends LightningElement {
    options = [
        { label: 'Ross', value: 'option1' },
        { label: 'Rachel', value: 'option2' },
    ];
    caseList;
    productOptions;
    value = 'option1';

    handleChange(event) {
        const selectedOption = event.detail.value;
        console.log('Option selected with value: ' + selectedOption);
    }
    @wire(getCases)
    wiredCases({ error, data }) {
        if (data) {
            this.caseList = data.map((cs) => ({
                ...cs,
                editable: false,
                editedProduct: cs.Product__c,
                editedSubject: cs.Subject,
            }));
            console.log('this.caseList', this.caseList);
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getProductOptions)
    wiredProductOptions({ error, data }) {
        if (data) {
            this.productOptions = data.map((option) => ({
                label: option,
                value: option
            }));
            console.log('this.productOptions', this.productOptions);
        } else if (error) {
            console.error(error);
        }
    }
    handleId(event) {
        const getId = event.currentTarget.dataset.recordId;
    }
    handleEdit(event) {
        const caseId = event.target.dataset.caseid;
        console.log('caseId::::', caseId);
        this.caseList = this.caseList.map((cs) => ({
            ...cs,
            editable: cs.Id === caseId,
            editedProduct: cs.Product__c,
            editedSubject: cs.Subject,
        }));
    }

    handleProductChange(event) {
        const caseId = event.target.dataset.caseid;
        console.log('caseId On Handle Product::::', caseId);

        const editedProduct = event.target.value;
        console.log('editedProduct::::', editedProduct);

        this.caseList = this.caseList.map((cs) => ({
            ...cs,
            editedProduct: cs.Id === caseId ? editedProduct : cs.editedProduct,
        }));
    }

    handleSubjectChange(event) {
        const caseId = event.target.dataset.caseid;
        console.log('editedSubject caseId::::', caseId);

        const editedSubject = event.target.value;
        console.log('editedSubject::::', editedSubject);

        this.caseList = this.caseList.map((cs) => ({
            ...cs,
            editedSubject: cs.Id === caseId ? editedSubject : cs.editedSubject,
        }));
    }

    handleSave(event) {
        const caseId = event.target.dataset.caseid;
        console.log('ON Save caseId::::', caseId);

        const editedProduct = this.caseList.find((cs) => cs.Id === caseId).editedProduct;
        console.log('editedProduct On save ::::', editedProduct);

        const editedSubject = this.caseList.find((cs) => cs.Id === caseId).editedSubject;
        console.log('editedSubject On Save::::', editedSubject);

        updateCase({ caseId, product: editedProduct, subject: editedSubject })
            .then(() => {
                console.log('Case updated successfully');
                this.caseList = this.caseList.map((cs) => ({
                    ...cs,
                    editable: false,
                    Product__c: cs.editedProduct,
                    Subject: cs.editedSubject,
                }));
            })
            .catch((error) => {
                console.error('Error updating case:', error);
            });
    }
}