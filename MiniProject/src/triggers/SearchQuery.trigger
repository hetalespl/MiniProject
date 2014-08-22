/******************************************************************************
Version:1.0
Date:13/07/2014
Author:Hetal Tanna
Comment:Creating a Trigger for Firing the query on query sent by user. 
*******************************************************************************/

trigger SearchQuery on Email_Details__c (after insert)
 {


    Google_call call = new Google_call();
    String nameid = trigger.new[0].Name;
    Google_call.googlecallout(nameid);


}