/******************************************************************************
Version:1.0
Date:16/07/2014
Author:Hetal Tanna
Comment:Controller for VF page to search query and display the history results.
*****************************************************************************/


public with sharing class Search 
{

 //Declaration
   
 public String query {get;set;}
 public String history {get;set;}
 public List<wrapper> w {get;set;}
 public List<wrapper> que {get;set;}
 public List<Email_Details__c> q {get;set;}
 
 
 //Wrapper class to parser the results
 public class wrapper
 {
  
  public String Title {get;set;}
  public string Link {get;set;}
  public string Descr {get;set;}
 
  public wrapper()
  {
   
  }
  public wrapper(String t,String l,String d){
   Title = t;
   link = l;
   Descr = d;
  }
  
 }
 
 
//Searching the query fired by the user as GOOGLE WEBSITE
 public void searchq(){
  
  query = query.replaceAll(' ', '+');
        system.debug('****'+query);        
        String endpoint = 'https://www.google.com/search?q='+query;             
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(endpoint);
        
        
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);            
        System.debug(res.getBody()); 
      
        
        w = parser(res.getBody());
 }
 
 // Class for showing the histories sent by the users through emails
 public  Search()
 {
  //Display the query sent through emails by users
  q = [Select Body__c From Email_Details__c ORDER BY createddate DESC limit 20];
 }
 

 //Processlink method used to display the kinks on VF page onclick of the history text 
 public void processLinkClick() 
 {
        
        system.debug('**** HISTORY DISPLAY******* '+history);
        history = history.replaceAll(' ', '+');
        String endpoint = 'https://www.google.com/search?q='+history;             
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);            
        System.debug(res.getBody()); 
        que=parser(res.getBody());
        system.debug('****QUERY*************************** '+w);
 }


 //Method used for parsing the search query 
 public static List<wrapper> parser(String html)
    {
     String temp;
     List<String> templ = html.split('<h3 class="r">');
     templ.remove(0);
     String link,title,description;
     List<wrapper> wa = new List<wrapper>();
     for(String str:templ)
     {
      
      if(str.contains('<cite>') && str.contains('<span class="st">'))
      {       
       Integer stA = str.indexOf('<a');
       Integer endA = str.indexOf('">');
        
    String remStr = str.substring(stA,endA+2);
    str = str.replace(remStr,'');        
    Integer slA = str.indexOf('</a>'); 
    temp = str.substring(0,slA);
    temp = temp.replaceAll('<b>','');
    temp = temp.replaceAll('</b>','');
    title = temp;
    temp = '';
    
       
    Integer startC = str.indexOf('<cite>');
    Integer endC = str.indexOf('</cite>');
     
    if(startC < endC || startC!=-1 || endC!=-1 || startC!=endC)
    {   
     
     temp = str.substring(startC+6,endC);
     temp = temp.replaceAll('<b>','');
     temp = temp.replaceAll('</b>','');
     link = temp;
     temp ='';
     str = str.replace(str.substring(startC, endC + 7), '');
     
       
     Integer startDesc = str.indexOf('<span class="st">');
     str = str.replace(str.substring(0,startDesc),'');
     Integer endDesc = str.indexOf('</span>');
      
     temp = str.substring(17,endDesc);
     temp = temp.replaceAll('<b>','');
     temp = temp.replaceAll('</b>','');     
     temp = temp.replaceAll('<br>','');
     temp = temp.replaceAll('&#39', '');
     temp = temp.replaceAll('&nbsp', '');
     description = temp;
     temp = ''; 
        
    }
    system.debug('\n Title :- '+title+'\n Link :- '+Link+'\n Description :- '+description);
    wa.add(new wrapper(title,Link,description));
      }
      
     }     
     
     return wa;
    }

}