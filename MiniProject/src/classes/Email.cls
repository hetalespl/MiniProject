/******************************************************************************
Version:1.0
Date:11/07/2014
Author:Hetal Tanna
Comment:Create a class to provide an inbound service for the query fired by user 
*******************************************************************************/
//Created a Messaging.InboundEmailHandler interface which allows you to process the email contents of required user query

global class Email implements Messaging.InboundEmailHandler {

global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
 
 
//Declaration
 
 contact c;
 boolean iscontact;
 list<contact> oldcontact;
 
 //Checking contact is present 
 try
 {
  oldcontact=[select id,Email from contact where Email = :envelope.fromaddress limit 1];
  system.debug('++ email'+oldcontact[0].Email);
 }
 catch(Exception e)
 {
  system.debug('++ Record couldnot be fetched');
 }
 
 
 // Generate new contact if it is not present or add in the existing one
 
 if(oldcontact.size()==0)
 {
  c = new Contact();
  c.LastName = email.fromname;
  c.Email = envelope.fromaddress;
  iscontact = false;
  insert c;
  
 }
 else
 {
   iscontact = true;
 } 
 
 
  //Object named Email_Details__c stores the subject and body of the sender
  
  Email_details__c e = new Email_details__c();
  e.Body__c=email.plaintextbody;
  e.subject__c = email.Subject;
 // e.Name=email.fromName;
 e.Sender__c = envelope.fromaddress;
 // md.Contact_email__c = envelope.fromaddress;

  
  
 //Storing all the details (Email id,Subject,Body)
  if(iscontact==false)
 {
  
  e.Email_id__c = c.id; 
 }
 else
 {
 
  e.Email_id__c = oldContact[0].Id;
 }
 
 
//Store email id to existing or create new check
  
 try
 {
  insert e;
 }
 catch(DMLException d)
 {
  system.debug('++ Error in contact insertion'); 
 } 
      
    return result;
    
    }
}