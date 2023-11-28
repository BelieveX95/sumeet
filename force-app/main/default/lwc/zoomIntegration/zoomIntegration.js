import { LightningElement } from 'lwc';

export default class FileUploadLWC extends LightningElement {
    selectedFile;

    handleFileChange(event) {
        this.selectedFile = event.target.files[0];
    }

    handleUpload() {
        if (this.selectedFile) {
            // You can now process the selected file here (e.g., upload it to a server, parse the content, etc.).
            // You may need to use the Lightning file upload API or custom Apex code to handle the file.
        } else {
            // Handle the case where no file is selected.
            console.log('No file selected.');
        }
    }
}