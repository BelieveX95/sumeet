import { LightningElement, wire, track } from 'lwc';
import getObjectNames from '@salesforce/apex/ObjectListController.getObjectNames';
import insertFields from '@salesforce/apex/ObjectListController.insertFields';
import generateField from '@salesforce/apex/MetadataUtility.generateField';



export default class ObjectListLWC extends LightningElement {
    objectOptions = [];
    selectedObject = '';
    allObjectOptions = [];

    fieldDefinitions = [];


    lebelX;
    typeX;
    nameX;

    @track fields = [];

    typeOptions = [
        { label: 'Text', value: 'text' },
        { label: 'Date', value: 'date' },
        { label: 'Number', value: 'number' },
        { label: 'Email', value: 'email' },
        { label: 'Phone', value: 'phone' },
        { label: 'Double', value: 'double' }

    ];


    @wire(getObjectNames)
    wiredObjectList({ error, data }) {
        if (data) {
            this.allObjectOptions = data.map(objectName => ({ label: objectName, value: objectName }));

            this.allObjectOptions.sort((a, b) => a.label.localeCompare(b.label));

            this.objectOptions = [...this.allObjectOptions];
        } else if (error) {
            console.error('Error fetching object list', error);
        }
    }


     handleSearch(event) {
        const searchTerm = event.target.value.toLowerCase();

        this.updateFilteredOptions(searchTerm);
    }

    updateFilteredOptions(searchTerm = '') {
        this.objectOptions = this.allObjectOptions.filter(option =>
            option.label.toLowerCase().includes(searchTerm)
        );
    }

    handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        this.fields = [{ id: 0, label: '', name: '', type: '', }];
    }

    handleFocus(event) {
        this.objectOptions = [...this.allObjectOptions];
    }

    addRow() {
        this.fields.push({ id: Date.now(), label: '', name: '', type: '' });
    }

    handleChangeLebel(event) {
        const index = event.target.dataset.index;
        const fieldToUpdate = this.fields[index];
        this.lebelX = fieldToUpdate; //

        const newLabel = event.target.value;
        const newName = newLabel.replace(/\s+/g, '_').toLowerCase() + '__c';
        this.nameX = newName;
        fieldToUpdate.label = newLabel;
        fieldToUpdate.name = newName;

        this.fields = [...this.fields];
    }

    handleChangeName(event) {
        const index = event.target.dataset.index;
        const fieldToUpdate = this.fields[index];
        fieldToUpdate.name = event.target.value;
        this.fields = [...this.fields];

    }

    handleTypeChange(event) {
        const index = event.target.dataset.index;
        const fieldToUpdate = this.fields[index];
        this.typeX = fieldToUpdate;

        fieldToUpdate.type = event.target.value;
        this.fields = [...this.fields];
    }

    deleteRow(event) {
        const index = event.target.dataset.index;
        this.fields.splice(index, 1);
        this.fields = [...this.fields];
    }

    handleClearAll() {
        this.fields.splice(1, this.fields.length - 1);
        this.fields[0] = { id: this.fields[0].id, label: '', name: '', type: '' };
        this.fields = [...this.fields];
    }



    handleSave() {
        const fieldDefinitions = this.fields.map(field => {
            return {
                fieldType: field.type,
                fieldName: field.name,
                fieldLabel: field.label,
            };
        });

        console.log('fieldDefinitions', JSON.stringify(fieldDefinitions));

        generateField({
            objectAPIName: this.selectedObject, fieldDefinitions: JSON.stringify(fieldDefinitions),
            fieldAPIName: JSON.stringify(this.nameX), fieldLabel: JSON.stringify(this.lebelX), fieldType: JSON.stringify(this.typeX)
        })
            .then(result => {
                console.log('Custom fields inserted successfully:', result);
            })
            .catch(error => {
                console.error('Error inserting custom fields:', JSON.stringify(error));
            });
    }
}