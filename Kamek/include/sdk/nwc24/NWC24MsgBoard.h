/*---------------------------------------------------------------------------*
  Project:  Wii Connect 24
  File:     NWC24MsgBoard.h

  Copyright (C) 2006 Nintendo. All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law.  They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24MsgBoard.h,v $
  Revision 1.9  2007/09/21 00:33:35  hirose_kazuki
  Removed NWC24ReadMsgMBUpdateSW().

  Revision 1.8  2007/07/12 10:58:40  hirose_kazuki
  Added size value definitions for some data types.

  Revision 1.7  2007/06/04 12:54:19  hirose_kazuki
  Added channel jump data accessor functions.

  Revision 1.6  2007/05/24 12:08:37  hirose_kazuki
  Rollback. (cancelled the last change.)

  Revision 1.4  2006/11/01 13:34:37  hirose_kazuki
  Added NWC24ReadMsgMBUpdateSW().

  Revision 1.3  2006/10/04 01:37:25  hirose_kazuki
  Fixed names of arguments.

  Revision 1.2  2006/09/22 08:56:58  hirose_kazuki
  Added definition of NWC24_MINIDATA_SIZE.

  Revision 1.1  2006/09/19 01:19:07  hirose_kazuki
  Initial check in.


 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    NWC24 API for "Wii message board"
    
    These APIs give detailed control when a message is handled by
    "Wii message board" which is a part of the system menu.
 *---------------------------------------------------------------------------*/
#ifndef __NWC24MSGBOARD_H__
#define __NWC24MSGBOARD_H__

#include <sdk/nwc24/NWC24Err.h>
#include <sdk/nwc24/NWC24Types.h>

/*---------------------------------------------------------------------------*
    Macros
 *---------------------------------------------------------------------------*/
#define NWC24MSG_MB_YEAR_BASE       2000
#define NWC24MSG_MB_YEAR_LIMIT      2035

#define NWC24_MINIDATA_SIZE         128
#define NWC24_MBTEMPLATE_SIZE_MAX   (120*1024)
#define NWC24_WIIPICTURE_SIZE_MAX   (80*1024)

/*---------------------------------------------------------------------------*
    API Prototypes
 *---------------------------------------------------------------------------*/
struct OSCalendarTime;

#ifdef __cplusplus
extern "C" {
#endif

/*---------------------------------------------------------------------------*
    Message creation APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24SetMsgMBNoReply   ( NWC24MsgObj* obj, BOOL noReply );
NWC24Err NWC24SetMsgMBRegDate   ( NWC24MsgObj* obj, u16 year, u8 month, u8 day );
NWC24Err NWC24SetMsgMBDelay     ( NWC24MsgObj* obj, u8 delayHours );

/*---------------------------------------------------------------------------*
    Message read APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24ReadMsgMBNoReply  ( const NWC24MsgObj* obj, BOOL* noReply );
NWC24Err NWC24ReadMsgMBRegDate  ( const NWC24MsgObj* obj, u16* year, u8* month, u8* day );
NWC24Err NWC24ReadMsgMBDelay    ( const NWC24MsgObj* obj, u8* delayHours );


/*---------------------------------------------------------------------------*
    Channel Jump structure accessor APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24InitCHJumpObj     ( NWC24CHJumpObj* chjp, u32 dataSize );
NWC24Err NWC24CheckCHJumpObj    ( const NWC24CHJumpObj* chjp, u32 dataSize );

NWC24Err NWC24SetCHJumpTitleId  ( NWC24CHJumpObj* chjp, u64 titleId );
NWC24Err NWC24SetCHJumpOptions  ( NWC24CHJumpObj* chjp, u32 options );
NWC24Err NWC24SetCHJumpBlockData( NWC24CHJumpObj* chjp,
                                  const char* data, u32 size, u32 index );

NWC24Err NWC24GetCHJumpTotalSize( const NWC24CHJumpObj* chjp, u32* size );
NWC24Err NWC24GetCHJumpTitleId  ( const NWC24CHJumpObj* chjp, u64* titleId );
NWC24Err NWC24GetCHJumpOptions  ( const NWC24CHJumpObj* chjp, u32* options );
NWC24Err NWC24GetCHJumpBlockSize( const NWC24CHJumpObj* chjp, u32* size, u32 index );
NWC24Err NWC24GetCHJumpBlockData( const NWC24CHJumpObj* chjp,
                                  char* data, u32 size, u32 index );



/*---------------------------------------------------------------------------*/
#ifdef __cplusplus
}
#endif

#endif  // __NWC24MSGBOARD_H__

