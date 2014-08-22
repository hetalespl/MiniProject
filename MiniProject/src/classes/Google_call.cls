/******************************************************************************
Version:1.0
Date:13/07/2014
Author:Hetal Tanna
Comment:Create a class for HTTP callout and paring the results for same.
*******************************************************************************/

public with sharing class Google_call {

  public class wrapperclass
  {
    public string title,link,description;
    public wrapperclass(string t,string l,string d)
    {
      this.title=t;
      this.link=l;
      this.description=d;
      
    }
  }
  

//making callout to google
 @Future(callout=true)
 public static void googlecallout(String Nameid)
 {
   // string result;
    List<wrapperclass> result=new List<wrapperclass>();
    string sender_mail;
    string str1;
    Email_details__c pm ;
    
   
 //Retriving the Email Details    
    try
    {
    // insering value of querry from email into object pm
    
    pm = [Select Body__c,Sender__c from Email_details__c where Name=:Nameid limit 1];
    }
    
    catch(Exception e)
    {
        system.debug('Cannot fetch record');
    }

   
       
     //making http callout
      String query = pm.Body__c;
      
     //Store email id of sender
      sender_mail = pm.Sender__c;
      
     //use this line to accept spaces in the querry  
      query= query.replaceAll(' ','+');
      
     //Retriving results from google      
      String endpoint ='https://www.google.com/search?q='+query+'&oq='+query+'&aqs=chrome..69i57.2888j0j7&sourceid=chrome&es_sm=93&ie=UTF-8'; 
     
     
      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpoint);
      req.setMethod('GET');
      Http http = new Http();
      HTTPResponse res = http.send(req);            
      System.debug(res.getBody());
     // result = res.getBody().stripHtmlTags();
      str1 = res.getBody();
     
     //Parsing stored result.     
      result=Google_call.parser(str1);
      string str='';
     
     
      //Inserting records into Search object 
      try
      {
       Search__c s = new Search__c();
      // s.Querry_result__c = result;
          for(wrapperclass wp:result)
          {
            str=str+wp.title+'\n'+wp.link+'\n'+wp.description+'\n\n';
          }
     
      // s.Fquerry__c = query;
       s.Search_Query__c = str;
       s.Sender_Email_Id__c = sender_mail;
       insert s;
      }
      catch(Exception e)
      {
       system.debug('*** error in inserting in query objet');
      }
 
  //Send email with Pdf
  
              Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
              att.setContentType('application/pdf');
              att.setFileName('QueryPdf.pdf');
              att.setInline(false);
              att.Body = Blob.toPdf(str);

              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.setUseSignature(false);
              mail.setToAddresses(new String[] { pm.Sender__c });
              mail.setSubject('PDF Email Demo');
              mail.setHtmlBody('Here is the email you requested! Check the attachment!');
              mail.setFileAttachments(new Messaging.EmailFileAttachment[] { att }); 

    // Send the email
   // System.debug('****'+mail);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

 
 }
 
 
 public static list<wrapperclass> parser(String htmlbody)
       {  
        String link,descr,title;
        List<wrapperclass> lstresult=new List<wrapperclass>();
        List<String> resList = htmlbody.split('<h3 class="r">');
        resList.remove(0);
        for(String str:resList)
        {   
           if(str.contains('<cite>'))
           {
    
            
            Integer startA = str.indexOf('<a');
            Integer endA = str.indexOf('">');
    
            String remStr = str.substring(startA,endA + 2);
            str = str.replace(remStr,'');
    
            Integer slashA = str.indexOf('</a>'); 
            title = str.substring(0,slashA).replaceAll('<b>','').replaceAll('</b>','');
    
            Integer startC = str.indexOf('<cite>');
            Integer endC = str.indexOf('</cite>');
    
    
           //Replacing <b></b> with ' ''    
            if(startC < endC || startC!=-1 || endC!=-1 || startC!=endC)
            {   
    
               link = str.substring(startC+6,endC).replaceAll('<b>','').replaceAll('</b>','');
               str = str.replace(str.substring(startC, endC + 7), '');
     
               Integer startD = str.indexOf('<span class="st">');
               str = str.replace(str.substring(0,startD),'');
               Integer endD = str.indexOf('</span>');
    
               descr = str.substring(17,endD).replaceAll('<b>','').replaceAll('</b>','').replaceAll('&nbsp;','').replaceAll('<br>','');
     
            }
    
    //Printing parsed result
          if(link!=null)
          {
               lstresult.add(new wrapperclass(title,link,descr));
               system.debug(title + '------' + link + '--------' + descr);
          }
          
         }
      }
      return lstresult;
 
 
 }

}