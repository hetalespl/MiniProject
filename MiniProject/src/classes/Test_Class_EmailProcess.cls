/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Class_EmailProcess {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // Create a new email and envelope object
     Messaging.InboundEmail email = new Messaging.InboundEmail();
     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     Email_details__c c;
      test.setMock(HttpCalloutMock.class, new Test_Google_call());
  // Create the plainTextBody and fromAddres for the test
   email.plainTextBody = 'Google Search';
   email.subject = 'dell';
   email.fromAddress ='abc@xyz.com';
   env.fromAddress ='abc@xyz.com';
   email.fromname = 'xyz4';
   

   Email objemail = new Email();
   objemail.handleInboundEmail(email, env);
   
   
  /* c  = [select Subject__c,Body__c from Email_details__c where Subject__c = 'dell'];
   system.assertEquals(c.Body__c, email.plaintextbody);
   Contact con = [select LastName,Email from Contact where email = :env.fromaddress limit 1];  
   system.assertEquals(email.fromName, con.Lastname);
   system.assertEquals(env.fromAddress, con.Email);
   */
   
   email.plainTextBody = 'Google';
   email.subject = 'hp';
   email.fromAddress ='abcd@xyz.com';
   env.fromAddress ='abcd@xyz.com';
   email.fromname = 'xyz4';
   //Email_Process objemail1 = new Email_Process();
   objemail.handleInboundEmail(email, env);
   
  /* c  = [select Subject__c,Body__c from Email_details__c where Subject__c = 'hp' limit 1];
   system.assertEquals(c.Body__c, email.plaintextbody);
   con = [select LastName,Email from Contact where email = :env.fromaddress limit 1];  
   system.assertEquals(email.fromName, con.Lastname);
   system.assertEquals(env.fromAddress, con.Email);*/
   
   
   email.plainTextBody = 'Google mail';
   email.subject = 'lenovo';
   email.fromAddress ='abc12@xyz.com';
   env.fromAddress ='abc12@xyz.com';
   email.fromname = 'xyz4';
   //Email_Process objemail1 = new Email_Process();
  // objemail=new Email();
   objemail.handleInboundEmail(email, env);
   
 /*  c  = [select Subject__c,Body__c from Email_details__c where Subject__c = 'lenovo' limit 1];
   system.assertEquals(c.Body__c, email.plaintextbody);    
   
    con = [select LastName,Email from Contact where email = :env.fromaddress limit 1];  
   system.assertEquals(email.fromName, con.Lastname);
   system.assertEquals(env.fromAddress, con.Email);*/
   
   email.plainTextBody = 'Google mail';
   email.subject = 'asus';
   email.fromAddress ='abc123@xyz.com';
   env.fromAddress ='abc123@xyz.com';
   email.fromname = 'xyz4';
   //Email_Process objemail1 = new Email_Process();
 //   objemail=new Email();
   objemail.handleInboundEmail(email, env);
   
   c  = [select Subject__c,Body__c from Email_details__c where Subject__c = 'asus' limit 1];
   system.assertEquals(c.Body__c, email.plaintextbody);    
   Contact con;
   con = [select LastName,Email from Contact where email = :env.fromaddress limit 1];  
   system.assertEquals(email.fromName, con.Lastname);
   system.assertEquals(env.fromAddress, con.Email);
        
        
    }
}