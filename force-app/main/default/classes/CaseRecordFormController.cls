public with sharing class CaseRecordFormController {
    @AuraEnabled
    public static Id createCase(String subject, String description, Id accountId, Id contactId,
                                String type, String reason, String status, String origin,
                                String attachmentName, String attachmentBody ,List<Attachment> attachments) {
                                    system.debug('attachments'+attachments);
                                    system.debug('attachmentName'+attachmentName);
                                    system.debug('attachmentBody'+attachmentBody);
                                    
                                    
                                    Case newCase = new Case(
                                        Subject = subject,
                                        Description = description,
                                        AccountId = accountId,
                                        ContactId = contactId,
                                        Type = type,
                                        Reason = reason,
                                        Status = status,
                                        Origin = origin
                                    );
                                    
                                    insert newCase;
                                    system.debug('newCase'+newCase);
                                    
                                    if (attachmentName != null && attachmentBody != null) {
                                        Attachment attachment = new Attachment(
                                            ParentId = newCase.Id,
                                            Name = attachmentName,
                                            Body = EncodingUtil.base64Decode(attachmentBody)
                                        );
                                        insert attachment;
                                        system.debug('attachment'+attachment);
                                        
                                    }
                                    
                                    return newCase.Id;
                                }
    
     public class AttachmentData {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public String body { get; set; }
    }
}