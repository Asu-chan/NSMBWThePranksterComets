/*---------------------------------------------------------------------------*
  Project:  Wii Connect 24
  File:     NWC24Schedule.h

  Copyright (C) 2006 Nintendo  All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law.  They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24Schedule.h,v $
  Revision 1.7  2007/05/23 09:31:41  adachi_hiroaki
  Added NWC24_SCD_DL_FLAG_NONE definition

  Revision 1.6  2006/10/19 06:27:32  adachi_hiroaki
  Eliminated NWC24DownloadPages() and added NWC24ExecDownloadTask().

  Revision 1.5  2006/10/18 13:31:44  hirose_kazuki
  Comments added

  Revision 1.4  2006/09/22 10:44:21  hirose_kazuki
  Added NWC24GetSchedulerError()

  Revision 1.3  2006/07/22 12:06:13  terui
  Fixed comments.

  Revision 1.2  2006/07/18 08:21:28  terui
  Added public API definitions
  Moved private API definitions into the directory private/.

  Revision 1.1  2006/07/15 12:43:13  terui
  Initial upload

  $NoKeywords: $
 *---------------------------------------------------------------------------*/

#ifndef __NWC24SCHEDULE_H__
#define __NWC24SCHEDULE_H__
#ifdef __cplusplus
extern "C" {
#endif
/*===========================================================================*/

#include <sdk/nwc24/NWC24Err.h>

#define NWC24_SCD_DL_FLAG_NONE              (0)
#define NWC24_SCD_DL_FLAG_SPECIFY_ID        (1<<01)
#define NWC24_SCD_DL_FLAG_SPECIFY_SUBID     (1<<02)
#define NWC24_SCD_DL_FLAG_REFRESH           (1<<03)


/* subroutine prototype */
/*---------------------------------------------------------------------------*
  Name: NWC24SuspendScheduler
  Description: Temporarily stops the automatic scheduler. Block and wait until stopped.
  Arguments: None
  Returns     : s32 -   Returns the the pre-processing suspend counter.
                        Returns 0 if the automatic scheduler was in an executable state before suspension started.
                        Shows that it was in an executable state before suspension started. If a positive value is returned, it indicates that it was in a pause state was since before the start of processing.
                        
                        Returns a negative NWC24Err enum type if the process fails.
 *---------------------------------------------------------------------------*/
s32         NWC24SuspendScheduler( void );

/*---------------------------------------------------------------------------*
  Name: NWC24TrySuspendScheduler
  Description: Attempts to suspend the automatic scheduler. Unless blocking is performed until suspension, execution will fail because scheduler-based processes are running.
                
  Arguments: None
  Returns: s32 -   Returns the suspend counter if suspension is successful.
                        Returns 0 if the automatic scheduler was in an executable state before suspension started.
                        If a positive value is returned, it indicates that it was in a pause state since before the start of processing.
                        
                        Returns a negative NWC24Err enum type if the process fails.
 *---------------------------------------------------------------------------*/
s32         NWC24TrySuspendScheduler( void );

/*---------------------------------------------------------------------------*
  Name: NWC24ResumeScheduler
  Description: Resumes automatic scheduler operations.
  Arguments: None
  Returns: s32 -   Returns the counter from the pre-process start suspend.
                        Returns 0 if the automatic scheduler was in an executable state before suspension started.
                        
                        it indicates that the pause state was entered before beginning processing.
                        Returns a negative NWC24Err enum type if the process fails.
 *---------------------------------------------------------------------------*/
s32         NWC24ResumeScheduler( void );

/*---------------------------------------------------------------------------*
  Name: NWC24GetScheduleSpan
  Description: Gets the schedule span (in minutes) for the automatic scheduler.
  Arguments: pMailSpan       -   Buffer for getting the mail send/receive span.
                pDwonloadSpan   -   Buffer for getting the download span.
  Returns: NWC24Err        -   Returns the result of processing.
 *---------------------------------------------------------------------------*/
NWC24Err    NWC24GetScheduleSpan( u32* pMailSpan, u32* pDownloadSpan );

/*---------------------------------------------------------------------------*
  Name: NWC24SetScheduleSpan
  Description: Sets the schedule span (in minutes) for the automatic scheduler.
                (For testing and debugging)
  Arguments: mailSpan        -   Specifies the mail send/receive span.
                downloadSpan    -   Specifies the download span.
  Returns: NWC24Err        -   Returns the result of processing.
 *---------------------------------------------------------------------------*/
NWC24Err    NWC24SetScheduleSpan( u32 mailSpan, u32 downloadSpan );

/*---------------------------------------------------------------------------*
  Name: NWC24SendMails
  Description: Immediately sends send-reserved mail to the NAND flash.
                (For testing and debugging)
  Arguments: None
  Returns: NWC24Err        -   Returns the result of processing.
 *---------------------------------------------------------------------------*/
NWC24Err    NWC24SendMails( void );

/*---------------------------------------------------------------------------*
  Name: NWC24ReceiveMails
  Description: Immediately receives mail and stores it in the NAND flash.
                (For testing and debugging)
  Arguments: None
  Returns: NWC24Err        -   Returns the result of processing.
 *---------------------------------------------------------------------------*/
NWC24Err    NWC24ReceiveMails( void );

/*---------------------------------------------------------------------------*
  Name: NWC24ExecDownloadTask
  Description: Starts download process immediately.
  Arguments: operationFlags - Specify the task to perform with a flag.
                taskId - Specify the ID of the task to start.
                                    (Valid only when NWC24_SCD_DL_FLAG_SPECIFY_ID is specified as a flag)
                                     
                subTaskMask - Specify the subtask ID to start using the mask value.
                                    (Valid only when NWC24_SCD_DL_FLAG_SPECIFY_SUBID is specified as a flag)
                                     
  Returns: NWC24Err        -   Returns the result of processing.
 *---------------------------------------------------------------------------*/
NWC24Err    NWC24ExecDownloadTask( u32 operationFlags, u16 taskId, u32 subTaskMask );

/*---------------------------------------------------------------------------*
  Name: NWC24GetSchedulerError
  Description: Gets the error code generated by the automatic scheduler process
  Arguments: pNumErrors   -   Pointer to the variable that obtains the number of errors generated
                pErrorCode  -   Error code for the error generated most recently
  Returns: NWC24Err        -   Returns the result of processing.
                
 *---------------------------------------------------------------------------*/
NWC24Err    NWC24GetSchedulerError( s32* pNumErrors, s32* pErrorCode );

/*===========================================================================*/
#ifdef __cplusplus
}
#endif
#endif  /* __NWC24SCHEDULE_H__ */
