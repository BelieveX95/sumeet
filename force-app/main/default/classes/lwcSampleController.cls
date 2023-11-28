public class lwcSampleController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> contactList(){
        List<Contact> conlist =[SELECT id, FirstName,LastName,Phone,Email FROM Contact];
                System.debug('conlist'+conlist);

        return conlist;
    }

}