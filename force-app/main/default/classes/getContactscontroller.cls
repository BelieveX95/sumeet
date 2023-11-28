public class getContactscontroller {
    @AuraEnabled(cacheable=true)
    public static List<ContactWrapper> getContacts(){
        List<ContactWrapper> contactList = new List<ContactWrapper>();
        
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact];
        
        for(Contact con : contacts) {
            ContactWrapper wrapper = new ContactWrapper();
            wrapper.contact = con;
            wrapper.isEditing = false;
            contactList.add(wrapper);
        }
        
        return contactList;
    }
    
    @AuraEnabled
    public static void saveContacts(List<ContactWrapper> contactList) {
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (ContactWrapper wrapper : contactList) {
            contactsToUpdate.add(wrapper.contact);
        }
        
        try {
            System.debug('contactsToUpdate##'+ contactsToUpdate);
            update contactsToUpdate;
        } catch (Exception ex) {
            throw new AuraHandledException('Error saving contacts: ' + ex.getMessage());
        }
    }
    
   @AuraEnabled
    public static void deleteContact(String recordId) {
        try {
            Contact contactToDelete = [SELECT Id FROM Contact WHERE Id = :recordId];
            system.debug('contactToDelete'+contactToDelete);
            if (contactToDelete != null) {
                delete contactToDelete;
            } else {
                throw new AuraHandledException('Contact record not found');
            }
        } catch (Exception ex) {
            throw new AuraHandledException('Error deleting contact: ' + ex.getMessage());
        }
    }
    
    
    
    public class ContactWrapper {
        @AuraEnabled
        public Contact contact { get; set; }
        
        @AuraEnabled
        public Boolean isEditing { get; set; }
        
        public ContactWrapper() {
        }
        
        public ContactWrapper(Contact contact, Boolean isEditing) {
            this.contact = contact;
            this.isEditing = isEditing;
        }
    }
    
}