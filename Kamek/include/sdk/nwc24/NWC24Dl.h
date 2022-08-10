/*---------------------------------------------------------------------------*
  Project:  WiiConnect24
  File:     NWC24Dl.h

  Copyright (C) 2006 Nintendo  All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law. They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24Dl.h,v $
  Revision 1.30  2008/01/31 08:53:19  adachi_hiroaki
  Added NWC24_DL_URL_MAX.

  Revision 1.29  2007/10/01 08:15:47  hirose_kazuki
  Added definition of NWC24_DL_INTERVAL_MIN_2ND.

  Revision 1.28  2007/09/20 00:44:22  adachi_hiroaki
  Copied SSL-RootCA definitions from ssl.h.

  Revision 1.27  2007/09/03 06:54:13  adachi_hiroaki
  Changed definitions for priority.

  Revision 1.26  2007/08/31 09:07:57  adachi_hiroaki
  Changed NWC24_DL_INTERVAL_MIN.

  Revision 1.25  2007/08/29 04:56:34  adachi_hiroaki
  Added functions for handling multiple tasks by one application.

  Revision 1.24  2007/07/13 12:20:52  adachi_hiroaki
  Removed flags.

  Revision 1.23  2007/07/13 11:57:01  adachi_hiroaki
  Reorganized headers.

  Revision 1.22  2007/07/13 02:11:08  adachi_hiroaki
  Added NWC24GetNumRegDlTasks() and NWC24DeleteDlTasksForOptOut().

  Revision 1.21  2007/07/02 08:23:31  adachi_hiroaki
  Changed NWC24_DL_RETRYMARGIN_MIN to 30.

  Revision 1.20  2007/06/20 10:36:31  adachi_hiroaki
  Added NWC24SetDlRootCA()/NWC24GetDlRootCA().

  Revision 1.19  2007/06/09 07:06:12  adachi_hiroaki
  Added NWC24ClearDlKeys().

  Revision 1.18  2007/06/08 05:46:47  adachi_hiroaki
  Moved NWC24_DL_TASKNUM_MAX.

  Revision 1.17  2007/06/05 01:39:16  adachi_hiroaki
  Added NWC24GetNumDlTasks().

  Revision 1.16  2007/06/04 06:34:58  adachi_hiroaki
  Supported opt-in/out flags.

  Revision 1.15  2007/05/29 06:03:21  adachi_hiroaki
  Changed NWC24_DLTYPE_MAX.

  Revision 1.14  2007/05/28 05:43:37  adachi_hiroaki
  Changed default task types.

  Revision 1.13  2007/04/10 04:46:47  adachi_hiroaki
  Added some flags.

  Revision 1.12  2007/03/13 05:32:06  adachi_hiroaki
  Added NWC24GetDlError() and NWC24ClearDlError().

  Revision 1.11  2006/12/29 01:33:21  adachi_hiroaki
  Added NWC24GetDlAppId().

  Revision 1.10  2006/12/14 09:43:25  adachi_hiroaki
  Added NWC24_DL_FLAG_STANDBYMODE_ONLY.
  Changed definition of NWC24DlType for the future.

  Revision 1.9  2006/12/13 04:27:54  adachi_hiroaki
  Added definition for data encryption.

  Revision 1.8  2006/11/14 06:57:19  adachi_hiroaki
  Increased NWC24_DL_RETRYMARGIN_MAX again.

  Revision 1.7  2006/11/11 19:00:29  adachi_hiroaki
  Increased NWC24_DL_RETRYMARGIN_MAX.

  Revision 1.6  2006/10/24 01:38:36  adachi_hiroaki
  Added NWC24*DlServerInterval().

  Revision 1.5  2006/10/17 02:46:18  adachi_hiroaki
  Added NWC24_DL_FLAG_RAW_CONTENT.

  Revision 1.4  2006/10/07 05:35:00  adachi_hiroaki
  Added NWC24SetDlPublicKey(), NWC24*DlFlags().

  Revision 1.3  2006/10/04 02:44:05  adachi_hiroaki
  Added filename management functions.

  Revision 1.2  2006/09/28 11:37:58  adachi_hiroaki
  Full spec candidate.

  Revision 1.1  2006/09/20 08:19:46  adachi_hiroaki
  Initial check in.


 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    NWC24 Message API
 *---------------------------------------------------------------------------*/
#ifndef NWC24DL_H__
#define NWC24DL_H__

#include <sdk/nwc24/NWC24Types.h>
#include <sdk/nwc24/NWC24Err.h>

/*---------------------------------------------------------------------------*
    Macros
 *---------------------------------------------------------------------------*/
#define NWC24_DL_PRIORITY_LOWEST                255
#define NWC24_DL_PRIORITY_DEFAULT               192
#define NWC24_DL_PRIORITY_LIMIT                 128
#define NWC24_DL_PRIORITY_HIGHEST               0

#define NWC24_DL_INTERVAL_MAX                   (60*24*7)
#define NWC24_DL_INTERVAL_MIN                   (60*6)
#define NWC24_DL_INTERVAL_MIN_2ND               (60*24)
#define NWC24_DL_INTERVAL_DEFAULT               (60*24*2)

#define NWC24_DL_RETRYMARGIN_MIN                (30)
#define NWC24_DL_RETRYMARGIN_MAX                (60*24*14)
#define NWC24_DL_RETRYMARGIN_DEFAULT            (60*24)
#define NWC24_DL_RETRYMARGIN_INFINITY           (65535)

#define NWC24_DL_COUNT_MIN                      (1)
#define NWC24_DL_COUNT_MAX                      (100)
#define NWC24_DL_COUNT_DEFAULT                  (1)

#define NWC24_DL_URL_MAX                        236

#define NWC24_DL_ITOR_ASCENDING                 0x00000000UL
#define NWC24_DL_ITOR_DESCENDING                0x80000000UL

#define NWC24_DL_IT_OPERATION_MASK              0x0000ffffUL
#define NWC24_DL_IT_ORDER_MASK                  0x80000000UL

#define NWC24_DL_TASKNUM_MAX                    120         // changed from 32
#define NWC24_DL_TASK_SIZE                      512
#define NWC24_DL_VF_SIZE_MIN                    (10*1024)

#define NWC24_DL_FLAG_SEND_USERINFO             (1UL <<  0UL)
#define NWC24_DL_FLAG_USE_MYPUBLICKEY           (1UL <<  1UL)
#define NWC24_DL_FLAG_RAW_CONTENT               (1UL <<  2UL)
#define NWC24_DL_FLAG_USE_MYSECRETKEY           (1UL <<  3UL)
#define NWC24_DL_FLAG_GROUP_WRITABLE            (1UL <<  6UL)

#define NWC24_DL_FLAG_RESERVED_30               (1UL << 30UL)
#define NWC24_DL_FLAG_RESERVED_31               (1UL << 31UL)

#define NWC24_DL_STFLAG_TRAILING_FILENAME       (1UL <<  0UL)
#define NWC24_DL_STFLAG_TRAILING_URL            (1UL <<  1UL)

#define NWC24_DL_STFLAG_INTELLIGENT_UPDATE      (1UL <<  8UL)
#define NWC24_DL_STFLAG_RETICENT_UPDATE         (1UL <<  9UL)
#define NWC24_DL_STFLAG_ALWAYS_INCREMENT        (1UL << 10UL)


#define NWC24_DL_STID_INVALID                   255

#define NWC24_DL_OPTFLAG_NONE                   (0x00)
#define NWC24_DL_OPTFLAG_OPT_OUT                (0x01)
#define NWC24_DL_OPTFLAG_OPT_IN                 (0x02)
#define NWC24_DL_OPTMASK_OPT_INOUT              \
                          (NWC24_DL_OPTFLAG_OPT_OUT | NWC24_DL_OPTFLAG_OPT_IN)

/* copied from ssl.h */
#define NWC24_DL_ROOTCA_ID_NINTENDO_0           (0)
#define NWC24_DL_ROOTCA_ID_NINTENDO_1           (1)
#define NWC24_DL_ROOTCA_ID_RSA_1024             (2)
#define NWC24_DL_ROOTCA_ID_RSA_2048             (3)
#define NWC24_DL_ROOTCA_ID_MAX                  (4)

#define NWC24_DL_PUBLICKEY_LENGTH               (2048 / 8)
#define NWC24_DL_SECRETKEY_LENGTH               (128 / 8)

/*---------------------------------------------------------------------------*
    Type definitions
 *---------------------------------------------------------------------------*/

typedef enum
{
    NWC24_DLTYPE_MULTIPART_V1   = 0,
    NWC24_DLTYPE_OCTETSTREAM_V1 = 1,
    NWC24_DLTYPE_MULTIPART_V2   = 2,
    NWC24_DLTYPE_OCTETSTREAM_V2 = 3,
    NWC24_DLTYPE_MAX,
    NWC24_DLTYPE_MULTIPART      = NWC24_DLTYPE_MULTIPART_V2,
    NWC24_DLTYPE_OCTETSTREAM    = NWC24_DLTYPE_OCTETSTREAM_V2
} NWC24DlType;
#define NWC24_DLTYPE_EMPTY                      255

typedef struct NWC24DlTask
{
    // 512 bytes
    u8      data[ NWC24_DL_TASK_SIZE ];
    
} NWC24DlTask;

typedef s32(*NWC24DlIterationPredicator) (u16 id);

typedef enum 
{
    NWC24_DL_ITOP_LASTACCESS            = 0,
    NWC24_DL_ITOP_LASTACCESS_ASCENDING  = NWC24_DL_ITOP_LASTACCESS | NWC24_DL_ITOR_ASCENDING,
    NWC24_DL_ITOP_LASTACCESS_DESCENDING = NWC24_DL_ITOP_LASTACCESS | NWC24_DL_ITOR_DESCENDING,
    NWC24_DL_ITOP_NEXTTIME              = 1,
    NWC24_DL_ITOP_NEXTTIME_ASCENDING    = NWC24_DL_ITOP_NEXTTIME | NWC24_DL_ITOR_ASCENDING,
    NWC24_DL_ITOP_NEXTTIME_DESCENDING   = NWC24_DL_ITOP_NEXTTIME | NWC24_DL_ITOR_DESCENDING,
    NWC24_DL_ITOP_PRIORITY              = 2,
    NWC24_DL_ITOP_PRIORITY_ASCENDING    = NWC24_DL_ITOP_PRIORITY | NWC24_DL_ITOR_ASCENDING,
    NWC24_DL_ITOP_PRIORITY_DESCENDING   = NWC24_DL_ITOP_PRIORITY | NWC24_DL_ITOR_DESCENDING
} NWC24DlIterateOperation;


typedef enum
{
    NWC24_DL_STTYPE_NONE,
    NWC24_DL_STTYPE_INCREMENT,
    NWC24_DL_STTYPE_TIME_HOUR,
    NWC24_DL_STTYPE_TIME_DAYOFWEEK,
    NWC24_DL_STTYPE_TIME_DAY,
    NWC24_DL_STTYPE_MAX
} NWC24DlSubTaskType;

typedef struct NWC24DlIterateContext
{
    s32     operation;
    s32     lastValue;
    s32     filterValue;
    s32     lastId;
    BOOL    isFirst;
    BOOL    isValid;
} NWC24DlIterateContext;

/*---------------------------------------------------------------------------*
    API Prototypes
 *---------------------------------------------------------------------------*/
#ifdef __cplusplus
extern "C" {
#endif

/*---------------------------------------------------------------------------*
    Task management APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24CheckDlTask( const NWC24DlTask* taskPublic, BOOL wantWrite );
NWC24Err NWC24InitDlTask( NWC24DlTask* taskPublic, NWC24DlType type );
NWC24Err NWC24AddDlTask( NWC24DlTask* taskPublic );
NWC24Err NWC24UpdateDlTask( NWC24DlTask* taskPublic );
NWC24Err NWC24GetDlTask( NWC24DlTask* taskPublic, u16 id );
NWC24Err NWC24DeleteDlTask( NWC24DlTask* taskPublic );
NWC24Err NWC24DumpDlTask( const NWC24DlTask* taskPublic );
NWC24Err NWC24CreateDlVf( const NWC24DlTask* taskPublic, u32 size );
NWC24Err NWC24MountDlVf( NWC24DlTask* taskPublic, const char* drive );
NWC24Err NWC24MountDlVfInHome( const char* drive );
NWC24Err NWC24GetDlTaskMineEx( NWC24DlTask* taskPublic, u32 param );
NWC24Err NWC24GetDlTaskMine( NWC24DlTask* taskPublic );
NWC24Err NWC24GetDlTaskIdByAppId( u16* id, u32 appId );
NWC24Err NWC24GetDlTaskIdByAppIdEx( u16* id, u32 appId, u32 param );
NWC24Err NWC24GetDlTaskByAppId( NWC24DlTask* taskPublic, u32 appId );
NWC24Err NWC24GetDlTaskByAppIdEx( NWC24DlTask* taskPublic, u32 appId, u32 param );
void     NWC24EnableDlLaxParameterChecking( BOOL enable );
NWC24Err NWC24GetDlHomeDir( const NWC24DlTask* taskPublic, char* buf, u32 len );
NWC24Err NWC24SetDlKeys( const u8 publicKey[NWC24_DL_PUBLICKEY_LENGTH], 
                         const u8 secretKey[NWC24_DL_SECRETKEY_LENGTH] );
NWC24Err NWC24ClearDlKeys( void );

NWC24Err NWC24GetNumDlTasks( u32* numTasks );
NWC24Err NWC24GetNumRegDlTasks( u32* numTasks );
NWC24Err NWC24DeleteDlTasksForOptOut( u32 appId, BOOL all );

NWC24Err NWC24GetDlVfPath( char* buf, u32 len );
NWC24Err NWC24GetDlVfPathByTask( const NWC24DlTask* taskPublic, char* buf, u32 len );
// Obsoleted
NWC24Err NWC24SetDlPublicKey( const NWC24DlTask* taskPublic, 
                              const u8 publicKey[NWC24_DL_PUBLICKEY_LENGTH] );
NWC24Err NWC24SetDlSecretKey( const NWC24DlTask* taskPublic, 
                               const u8 secretKey[NWC24_DL_SECRETKEY_LENGTH] );
NWC24Err NWC24GetDlVfName( const NWC24DlTask* taskPublic, char* buf, u32 len );


/*---------------------------------------------------------------------------*
    Task accessor APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24GetDlId( const NWC24DlTask* taskPublic, u16 *id );
NWC24Err NWC24GetDlType( const NWC24DlTask* taskPublic, NWC24DlType *type );
NWC24Err NWC24SetDlPriority( NWC24DlTask* taskPublic, u8 priority );
NWC24Err NWC24GetDlPriority( const NWC24DlTask* taskPublic, u8* priority );
NWC24Err NWC24SetDlInterval( NWC24DlTask* taskPublic, u16 min );
NWC24Err NWC24GetDlInterval( const NWC24DlTask* taskPublic, u16* min );
NWC24Err NWC24SetDlServerInterval( const NWC24DlTask* taskPublic, u32 min );
NWC24Err NWC24GetDlServerInterval( const NWC24DlTask* taskPublic, u32* min );
NWC24Err NWC24SetDlRetryMargin( NWC24DlTask* taskPublic, u16 min );
NWC24Err NWC24GetDlRetryMargin( const NWC24DlTask* taskPublic, u16* min );
NWC24Err NWC24SetDlUrl( NWC24DlTask* taskPublic, const char* url );
NWC24Err NWC24GetDlUrl( const NWC24DlTask* taskPublic, char* url, s32 len );
NWC24Err NWC24SetDlCount( NWC24DlTask* taskPublic, s16 count );
NWC24Err NWC24GetDlCount( const NWC24DlTask* taskPublic, s16* count );
NWC24Err NWC24GetDlNextTime( NWC24DlTask* taskPublic, s64* sec );
NWC24Err NWC24GetDlLastUpdate( const NWC24DlTask* taskPublic, s64* sec );
NWC24Err NWC24SetDlFilename( NWC24DlTask* taskPublic, const char* filename );
NWC24Err NWC24GetDlFilename( const NWC24DlTask* taskPublic, char* filename, s32 len );
NWC24Err NWC24SetDlFlags( NWC24DlTask* taskPublic, u32 flags );
NWC24Err NWC24GetDlFlags( const NWC24DlTask* taskPublic, u32* flags );
NWC24Err NWC24GetDlAppId( const NWC24DlTask* taskPublic, u32* appId );
NWC24Err NWC24ClearDlError( NWC24DlTask* taskPublic );
NWC24Err NWC24GetDlError( const NWC24DlTask* taskPublic, s32* code, s32* count );

NWC24Err NWC24SetDlOptOutFlags( NWC24DlTask* taskPublic, u8 optFlags );
NWC24Err NWC24GetDlOptOutFlags( NWC24DlTask* taskPublic, u8* optFlags );

NWC24Err NWC24SetDlRootCA( NWC24DlTask* taskPublic, u8 rootCaId );
NWC24Err NWC24GetDlRootCA( NWC24DlTask* taskPublic, u8* rootCaId );

NWC24Err NWC24SetDlUserParameter( NWC24DlTask* taskPublic, u32 param );
NWC24Err NWC24GetDlUserParameter( const NWC24DlTask* taskPublic, u32* param );


/*---------------------------------------------------------------------------*
    Task iteration APIs
 *---------------------------------------------------------------------------*/
NWC24Err NWC24IterateDlTask( u16* id, BOOL isBegin );
NWC24Err NWC24InitDlIterateContext( NWC24DlIterateContext* context,
                                    NWC24DlIterateOperation operation );
NWC24Err NWC24IterateDlTaskEx( NWC24DlIterateContext* context,
                               u16* id );

/*---------------------------------------------------------------------------*/
#ifdef __cplusplus
}
#endif

#endif  // NWC24DL_H__

