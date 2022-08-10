/*---------------------------------------------------------------------------*
  Project:  WiiConnect24
  File:     NWC24Msg.h

  Copyright (C) 2006 Nintendo. All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law. They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24Msg.h,v $
  Revision 1.61  2008/05/01 10:53:09  hirose_kazuki
  Added NWC24SetSearchCondGroupId().

  Revision 1.60  2008/04/30 09:57:49  hirose_kazuki
  Added NWC24CheckUserIdRegion().

  Revision 1.59  2008/03/07 01:18:08  hirose_kazuki
  Added NWC24_USE_STANDBY.

  Revision 1.58  2007/11/16 08:17:08  hirose_kazuki
  Fixed argument names.

  Revision 1.57  2007/11/16 08:06:27  hirose_kazuki
  Added NWC24CheckMsgBoxSpace().

  Revision 1.56  2007/11/05 11:11:28  hirose_kazuki
  Added definition of NWC24MSG_MAX_DESIG_TIME.

  Revision 1.55  2007/09/03 02:51:30  seiki_masashi
  Added NWC24SetSearchCondPublic().

  Revision 1.54  2007/07/12 12:02:01  hirose_kazuki
  Changed NWC24SetSearchCondTag() to use NWC24SearchCompareMode
  as second argument type.

  Revision 1.53  2007/07/12 11:02:26  hirose_kazuki
  Removed some functions.

  Revision 1.52  2007/06/26 12:12:14  seiki_masashi
  Added NWC24Get/SetMsgSequenceNumber.

  Revision 1.51  2007/06/25 04:11:32  adachi_hiroaki
  Changed order of arguments in NWC24GetMsgExecScript()/NWC24SetMsgExecScript().

  Revision 1.50  2007/06/21 09:58:42  adachi_hiroaki
  Changed NWC24SetMsgExecScript()/NWC24GetMsgExecScript() to support TTL management.

  Revision 1.49  2007/06/20 23:54:35  seiki_masashi
  Changed the vf file names related to automatic replies

  Revision 1.48  2007/06/16 09:50:26  hirose_kazuki
  Added NWC24SetSearchCondTag().

  Revision 1.47  2007/05/30 07:34:30  adachi_hiroaki
  Added NWC24_SCRIPT_STORAGE_PATH.

  Revision 1.46  2007/05/29 08:04:33  hirose_kazuki
  Minor fix.

  Revision 1.45  2007/05/22 11:49:21  hatamoto_minoru
  Added NWC24GetMsgExecScript

  Revision 1.44  2007/05/18 10:53:02  hatamoto_minoru
  Added NWC24GetScriptVfPath and NWC24_SCRIPT_BINARY_PATH.

  Revision 1.43  2007/05/18 08:20:03  hatamoto_minoru
  Added NWC24SetMsgExecScript.

  Revision 1.42  2007/04/26 08:03:24  adachi_hiroaki
  Added NWC24SetMsgDesignatedTime().

  Revision 1.41  2007/04/02 11:51:10  hirose_kazuki
  Added NWC24MsgIconNewSign().

  Revision 1.40  2007/02/05 02:11:29  yoshioka_yasuhiro
  Added NWC24SetMsgSubjectAndTextPublic.

  Revision 1.39  2007/01/30 00:42:22  hirose_kazuki
  Added NWC24GetMsgSize().

  Revision 1.38  2007/01/25 06:43:28  hirose_kazuki
  Added NWC24_BASE64_ENCODED_SIZE macro.

  Revision 1.37  2007/01/15 08:15:10  hirose_kazuki
  Added NWC24GetMsgTextPtr() and NWC24GetMsgAttachedPtr().

  Revision 1.36  2006/12/05 02:13:12  hirose_kazuki
  Added NWC24EnableLedNotification().

  Revision 1.35  2006/11/04 12:21:05  hirose_kazuki
  Added NWC24SetMsgLedPattern().

  Revision 1.34  2006/10/30 10:05:25  seiki_masashi
  Fixed header file error.

  Revision 1.33  2006/10/30 09:17:03  seiki_masashi
  Small fix

  Revision 1.32  2006/10/29 17:31:54  seiki_masashi
  Added NWC24MSG_AUTO_ENC_CONVERT.

  Revision 1.31  2006/10/23 12:22:01  hirose_kazuki
  Set NWC24_WORK_MEM_SIZE back to 16KB.

  Revision 1.30  2006/10/19 06:28:43  hirose_kazuki
  Added NWC24ReadMsgTextEx().

  Revision 1.29  2006/10/19 04:36:30  hirose_kazuki
  Changed argument type of NWC24Check(). Added NWC24GetErrorCode().

  Revision 1.28  2006/10/16 08:22:28  hirose_kazuki
  Added NWC24Check().

  Revision 1.27  2006/09/23 09:34:25  hirose_kazuki
  Removed NWC24InitFiles().

  Revision 1.26  2006/09/22 09:03:21  hirose_kazuki
  Added definition of NWC24MSG_MAX_ALTNAME_LEN.

  Revision 1.25  2006/09/20 12:57:11  hirose_kazuki
  Deleted NWC24InitMsgBox(), added NWC24InitFiles().

  Revision 1.24  2006/09/20 07:10:22  adachi_hiroaki
  Changed NWC24_WORK_MEM_SIZE for download APIs.

  Revision 1.23  2006/09/19 01:20:01  hirose_kazuki
  Moved message board related APIs to "NWC24MsgBoard.h".

  Revision 1.22  2006/09/18 11:45:14  hirose_kazuki
  Added NWC24[Set|Read]MsgMBRegDate().

  Revision 1.21  2006/09/13 13:22:18  hirose_kazuki
  Added NWC24[Set|Read]MsgMBNoReply().

  Revision 1.20  2006/09/12 11:53:26  hirose_kazuki
  Added NWC24IsNewMsgForMenuArrived().

  Revision 1.19  2006/09/10 08:37:28  hirose_kazuki
  Added NWC24GetMsgGroupId().

  Revision 1.18  2006/09/10 02:33:37  hirose_kazuki
  Changed NWC24OpenMsgLib to NWC24OpenLib. NWC24CloseLib as well.
  Old functions still exist for compatibility.

  Revision 1.17  2006/09/04 06:40:36  adachi_hiroaki
  Added NWC24CheckUserId().

  Revision 1.16  2006/09/02 12:09:02  hirose_kazuki
  Added NWC24Msg[Get|Read]AltName(). Changed maximum size values.

  Revision 1.15  2006/08/30 04:48:09  hirose_kazuki
  Added SetMsgTag/GetMsgTag APIs and GetMsgId API.

  Revision 1.14  2006/08/19 08:45:43  hirose_kazuki
  Added initial version of search APIs.

  Revision 1.13  2006/08/16 06:08:07  hirose_kazuki
  Added NWC24CheckSendBoxVacancy().

  Revision 1.12  2006/08/09 02:22:48  hirose_kazuki
  Added const qualifier to input string pointers.

  Revision 1.11  2006/08/08 04:51:46  hirose_kazuki
  Added NWC24GetMsgDate().

  Revision 1.10  2006/08/07 06:42:57  hirose_kazuki
  Moved type definitions to NWC24Types.h.

  Revision 1.9  2006/07/31 02:51:53  hirose_kazuki
  Fixed misleading argument names.

  Revision 1.8  2006/07/26 04:25:47  adachi_hiroaki
  Fixed types.h.

  Revision 1.7  2006/07/18 04:13:04  hirose_kazuki
  Fixed a compile error on #endif.

  Revision 1.6  2006/07/18 02:17:23  hirose_kazuki
  Deleted NWC24SetMsgCharset().

  Revision 1.5  2006/07/15 00:37:53  hirose_kazuki
  Added new values for NWC24MsgType.

  Revision 1.4  2006/07/13 12:40:38  hirose_kazuki
  Changed enum value definitions. Major API spec changes for alpha3.

  Revision 1.3  2006/07/12 00:56:50  hirose_kazuki
  Moved NWC24InitMsgBox() from the admin header.
  Changed max number of 'To:' to 8.
  Changed size of NWC24MsgObj (now 256Bytes).

  Revision 1.2  2006/07/11 04:32:16  hirose_kazuki
  Yet another repository reforming.

  Revision 1.2  2006/07/06 11:02:07  hirose_kazuki
  Added NWC24ReadMsgToAddr(),
  renamed NWC24ReadMsgFrom() to NWC24ReadMsgFromAddr().

  Revision 1.1  2006/07/03 03:23:31  yosizaki
  Moved from ../ppc

  Revision 1.1  2006/06/29 12:43:43  hirose_kazuki
  Moved from another repository.

  Revision 1.2  2006/06/12 07:29:40  hirose
  Added NWC24GetMsgNumTo() and NWC24GetMsgToId().

  Revision 1.1  2006/06/10 10:34:21  hirose
  Initial check in.

 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    NWC24 Message API
 *---------------------------------------------------------------------------*/
#ifndef __NWC24MSG_H__
#define __NWC24MSG_H__

#include <sdk/nwc24/NWC24Types.h>

#ifdef RVL_OS
#include <sdk/enc.h>
#endif // RVL_OS

/*---------------------------------------------------------------------------*
    Macros
 *---------------------------------------------------------------------------*/

#define NWC24MSG_MAX_TO             8
#define NWC24MSG_MAX_ATTACH         2
#define NWC24MSG_MAX_ADDRSTR        256

#define NWC24MSG_MAX_ALTNAME_LEN    (34+1)

#define NWC24MSG_MAX_DATASIZE       148912
#define NWC24MSG_MAX_BODYSIZE       203776

#define NWC24_WORK_MEM_SIZE         16384

#define NWC24_USE_MESSAGES          0x00000001
#define NWC24_USE_DOWNLOADS         0x00000002
#define NWC24_USE_SETTINGS          0x00000004
#define NWC24_USE_STANDBY           0x00000008

#define NWC24MSG_MAX_DESIG_TIME     (60*24*10)

#ifdef ENC_CHECK_NOT_FOUND // new ENC library
#define NWC24MSG_AUTO_ENC_CONVERT   1
#endif

#define NWC24_BASE64_ENCODED_SIZE(rawSize)  \
    (((rawSize*4+2)/3)+((rawSize/57)*2)+4)

/*---------------------------------------------------------------------------*
    API Prototypes
 *---------------------------------------------------------------------------*/
struct OSCalendarTime;

#ifdef __cplusplus
extern "C" {
#endif

/*---------------------------------------------------------------------------*
    Management APIs
 *---------------------------------------------------------------------------*/
int      NWC24IsNewMsgArrived( void );
int      NWC24IsNewMsgForMenuArrived( void );

/*---------------------------------------------------------------------------*/
NWC24Err NWC24OpenLib( void* workMemory );
NWC24Err NWC24CloseLib( void );

NWC24Err NWC24Check( u32 usageType );
s32      NWC24GetErrorCode( void );

NWC24Err NWC24GetMyUserId( NWC24UserId *userId );
NWC24Err NWC24CheckUserId( NWC24UserId userId );
NWC24Err NWC24CheckUserIdRegion( NWC24UserId userId );

NWC24Err NWC24EnableLedNotification( BOOL enable );


/*---------------------------------------------------------------------------*/
/* For compatibility with Alpha version. Not recommended for use. */
NWC24Err NWC24OpenMsgLib( void* workMemory );
NWC24Err NWC24CloseMsgLib( void );

/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    Message creation APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24InitMsgObj    ( NWC24MsgObj* obj, NWC24MsgType type );

/*---------------------------------------------------------------------------*/

NWC24Err NWC24SetMsgToId        ( NWC24MsgObj* obj, NWC24UserId userId );
NWC24Err NWC24SetMsgToAddr      ( NWC24MsgObj* obj, const char* addr, u32 length );

NWC24Err NWC24SetMsgSubject     ( NWC24MsgObj* obj, const char* subject, u32 size );
#ifdef NWC24MSG_AUTO_ENC_CONVERT
NWC24Err NWC24SetMsgSubjectPublic( NWC24MsgObj* obj, const u16* subject, u32 length,
                                  NWC24AutoEncodingType autoEnc, u16 altChar,
                                  u8* work, u32 workSize );
#endif
NWC24Err NWC24SetMsgText        ( NWC24MsgObj* obj, const char* text, u32 size,
                                  NWC24Charset charset, NWC24Encoding encoding );
#ifdef NWC24MSG_AUTO_ENC_CONVERT
NWC24Err NWC24SetMsgTextPublic  ( NWC24MsgObj* obj, const u16* text, u32 length,
                                  NWC24AutoEncodingType autoEnc, u16 altChar,
                                  u8* work, u32 workSize );
NWC24Err NWC24SetMsgSubjectAndTextPublic( NWC24MsgObj* obj,
                                          const u16* subject, u32 subjLen,
                                          const u16* text, u32 textLen,
                                          NWC24AutoEncodingType autoEnc, u16 altChar,
                                          u8* work, u32 workSize );
#endif
NWC24Err NWC24SetMsgAttached        ( NWC24MsgObj* obj, const char* data, u32 size, NWC24MIMEType type );

NWC24Err NWC24SetMsgAltName         ( NWC24MsgObj* obj, const u16* name, u32 length );
NWC24Err NWC24SetMsgTag             ( NWC24MsgObj* obj, u16 tag );
NWC24Err NWC24SetMsgLedPattern      ( NWC24MsgObj* obj, u16 pattern );
NWC24Err NWC24SetMsgIconNewSign     ( NWC24MsgObj* obj, BOOL enable );
NWC24Err NWC24SetMsgDesignatedTime  ( NWC24MsgObj* obj, s32 elapsedTime );

/*---------------------------------------------------------------------------*
    Message read APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24GetMsgType        ( const NWC24MsgObj* obj, NWC24MsgType* type );
NWC24Err NWC24GetMsgSize        ( const NWC24MsgObj* obj, u32* size );
NWC24Err NWC24GetMsgFromId      ( const NWC24MsgObj* obj, NWC24UserId* userId );
NWC24Err NWC24GetMsgNumTo       ( const NWC24MsgObj* obj, u32* numTo );
NWC24Err NWC24GetMsgSubjectSize ( const NWC24MsgObj* obj, u32* size );
NWC24Err NWC24GetMsgTextSize    ( const NWC24MsgObj* obj, u32* size );
NWC24Err NWC24GetMsgNumAttached ( const NWC24MsgObj* obj, u32* numAttached );
NWC24Err NWC24GetMsgAttachedSize( const NWC24MsgObj* obj, u32 index, u32* size );
NWC24Err NWC24GetMsgAttachedType( const NWC24MsgObj* obj, u32 index, NWC24MIMEType* type );
NWC24Err NWC24GetMsgDate        ( const NWC24MsgObj* obj, struct OSCalendarTime* cTime );
NWC24Err NWC24GetMsgTag         ( const NWC24MsgObj* obj, u16* tag );

NWC24Err NWC24GetMsgTextPtr     ( const NWC24MsgObj* obj, const char** text );
NWC24Err NWC24GetMsgAttachedPtr ( const NWC24MsgObj* obj, u32 index, const char** data );

NWC24Err NWC24GetMsgId          ( const NWC24MsgObj* obj, u32* msgId );
NWC24Err NWC24GetMsgAppId       ( const NWC24MsgObj* obj, u32* appId );
NWC24Err NWC24GetMsgGroupId     ( const NWC24MsgObj* obj, u16* groupId );

/*---------------------------------------------------------------------------*/

NWC24Err NWC24ReadMsgFromAddr   ( const NWC24MsgObj* obj, char* buffer, u32 bufSize );
NWC24Err NWC24ReadMsgToId       ( const NWC24MsgObj* obj, u32 index, NWC24UserId* userId );
NWC24Err NWC24ReadMsgToAddr     ( const NWC24MsgObj* obj, u32 index, char* buffer, u32 bufSize );
NWC24Err NWC24ReadMsgSubject    ( const NWC24MsgObj* obj, char* buffer, u32 bufSize );
#ifdef NWC24MSG_AUTO_ENC_CONVERT
NWC24Err NWC24ReadMsgSubjectPublic( const NWC24MsgObj* obj, u16* subject, u32* length,
                                   NWC24AutoEncodingType autoEnc, u16 altChar,
                                   u8* work, u32 workSize );
#endif
NWC24Err NWC24ReadMsgText       ( const NWC24MsgObj* obj, char* buffer, u32 bufSize,
                                  NWC24Charset* charset, NWC24Encoding* encoding );
NWC24Err NWC24ReadMsgTextEx     ( const NWC24MsgObj* obj, char* buffer, u32 bufSize,
                                  char* csNameBuf, u32 csNameSize );
#ifdef NWC24MSG_AUTO_ENC_CONVERT
NWC24Err NWC24ReadMsgTextPublic ( const NWC24MsgObj* obj, u16* text, u32* length,
                                  NWC24AutoEncodingType autoEnc, u16 altChar,
                                  u8* work, u32 workSize );
#endif
NWC24Err NWC24ReadMsgAttached   ( const NWC24MsgObj* obj, u32 index, char* buffer, u32 bufSize );
NWC24Err NWC24ReadMsgAltName    ( const NWC24MsgObj* obj, u16* name, u32 length );

/*---------------------------------------------------------------------------*
    Message box access APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24CommitMsg         ( NWC24MsgObj* obj );

NWC24Err NWC24GetNumMsgs        ( NWC24MsgBoxId mboxId, u32* numMsgs );
NWC24Err NWC24GetMsgIdList      ( NWC24MsgBoxId mboxId, u32* idTable, u32 size );
NWC24Err NWC24GetMsgObj         ( NWC24MsgObj* obj, NWC24MsgBoxId mboxId, u32 msgId );
NWC24Err NWC24DeleteMsg         ( NWC24MsgBoxId mboxId, u32 msgId );

NWC24Err NWC24CheckMsgBoxSpace  ( NWC24MsgBoxId mboxId, u32 numMsgs, u32 size );

/*---------------------------------------------------------------------------*
    Message box search APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24InitSearchConds           ( void );

NWC24Err NWC24SetSearchCondMsgBox       ( NWC24MsgBoxId mBoxId );
NWC24Err NWC24SetSearchCondForMenu      ( void );
NWC24Err NWC24SetSearchCondPublic       ( BOOL includePublic );
NWC24Err NWC24SetSearchCondFromAddrId   ( NWC24UserId userId );
NWC24Err NWC24SetSearchCondAppId        ( u32 appId );
NWC24Err NWC24SetSearchCondGroupId      ( u16 groupId );
NWC24Err NWC24SetSearchCondTag          ( u16 tag, NWC24SearchCompareMode mode );

NWC24Err NWC24SearchMsgs                ( NWC24MsgObj* msgObjArray, u32 arraySize,
                                          u32* numStored, u32* numRemain );


/*---------------------------------------------------------------------------*/
#ifdef __cplusplus
}
#endif

#endif  // __NWC24MSG_H__

