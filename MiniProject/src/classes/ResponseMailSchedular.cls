/******************************************************************************
Version:1.0
Date:16/07/2014
Author:Hetal Tanna
Comment:Create a Batch class for processing the emails(response of query) 
*****************************************************************************/


global class ResponseMailSchedular implements Database.Batchable<sObject>, Database.Stateful {
 
 Time StartTime;
 String address;
 public ResponseMailSchedular(){ }
 
    
    public ResponseMailSchedular(String q)
    {     
    	StartTime = Datetime.now().time();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
     
      String q = 'SELECT r.Sender__c From Email_Details__c r ORDER BY createddate DESC Limit 1';
       return Database.getQueryLocator(q);
    }
     
     
 global void execute(Database.BatchableContext BC, List<sObject> scope)
 {
  
 /*Mail_details__c rec = [Select r.sender_email__c From Mail_details__c r Limit 10];
 Search__c resp = new Search__c();
 resp = [Select r.Querry_result__c From Search__c r Limit 10];
*/
 
//Email_details__c rec = [Select r.Sender__c From Email_details__c r Limit 1];
 Search__c resp = new Search__c();
 resp = [Select r.Search_Query__c,r.Sender_Email_Id__c From Search__c r ORDER BY createddate DESC Limit 1];
 
 // add result field of second object
  address=resp.Sender_Email_Id__c;
 
 //attach pdf
  String body=resp.Search_Query__c;
 
    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType('application/pdf');
    attach.setFileName('QueryPdf.pdf');
    attach.setInline(false);
    attach.Body = Blob.toPDF(body);
 
 
 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   
 String[] toAddresses = new String[] {address};    
   // Assign the addresses for the To and CC lists to the mail object.
 mail.setToAddresses(ToAddresses);
 
 mail.setSenderDisplayName('Batch Processing for Response Mail');
    mail.setSubject('Response mails are sechdeuled...'); 
    mail.setPlainTextBody('===StartTime==='+StartTime+'\n'+resp);
    
    //attaching generated pdf to mail
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
    
 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
 
 
 }
    
  global void finish(Database.BatchableContext BC){
  
   }
}