/******************************************************************************
Version:1.0
Date:16/07/2014
Author:Hetal Tanna
Comment:Creating a Schedulable class for processing the emails.(Response of the query) 
*******************************************************************************/
global class ScheduleResponse implements schedulable {
 
  global void execute(SchedulableContext sc)
    {
         ResponseMailSchedular responseMail = new ResponseMailSchedular();
         database.executebatch(responseMail);
    }
}