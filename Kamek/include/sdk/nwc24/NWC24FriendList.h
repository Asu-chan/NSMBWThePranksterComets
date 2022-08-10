/*---------------------------------------------------------------------------*
  Project:  Wii Connect 24
  File:     NWC24FriendList.h

  Copyright (C)2006 Nintendo  All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law.  They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24FriendList.h,v $
  Revision 1.8  2007/05/31 02:11:53  adachi_hiroaki
  Added NWC24_FL_NAME_SIZE_LIMIT and NWC24_FL_ADDR_LENGTH_LIMIT.

  Revision 1.7  2007/03/19 02:41:01  hirose_kazuki
  Added NWC24SwapFriendInfos() and NWC24GetFriendInfoStatus().

  Revision 1.6  2006/11/11 15:22:58  seiki_masashi
  Added CheckPublicMailAddr() and CheckFriendInfo().

  Revision 1.5  2006/10/17 09:01:30  hirose_kazuki
  Added prototype declaration of NWC24GetNumEstFriendInfos().

  Revision 1.4  2006/09/12 08:47:58  hirose_kazuki
  Updated the format of NWC24FriendAttr.

  Revision 1.3  2006/09/02 07:45:42  hirose_kazuki
  Added NWC24SearchFriendInfoByAddr().

  Revision 1.2  2006/08/25 06:32:36  hirose_kazuki
  Added NWC24SearchFriendInfoById().

  Revision 1.1  2006/08/24 02:33:47  hirose_kazuki
  Initial check in.


 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    NWC24 Friend List API
 *---------------------------------------------------------------------------*/
#ifndef NWC24FRIENDLIST_H__
#define NWC24FRIENDLIST_H__

#include <sdk/nwc24/NWC24Types.h>
#include <sdk/nwc24/NWC24Err.h>

/*---------------------------------------------------------------------------*
    Type definitions
 *---------------------------------------------------------------------------*/

#define NWC24_FI_TYPE_NONE          0
#define NWC24_FI_TYPE_WII           1
#define NWC24_FI_TYPE_PUBLIC        2

#define NWC24_FI_STAT_NONE          0
#define NWC24_FI_STAT_PENDING       1
#define NWC24_FI_STAT_ESTABLISHED   2
#define NWC24_FI_STAT_DECLINED      3

#define NWC24_FL_NAME_SIZE          12
#define NWC24_FL_ADDR_LENGTH        256     // RFC2821 defines max=255.

#define NWC24_FL_NAME_SIZE_LIMIT    10
#define NWC24_FL_ADDR_LENGTH_LIMIT  99

typedef struct NWC24FriendAttr
{
    u32     type;                       // Address type [4Bytes]
    u32     status;                     // Friend relation status [4Bytes]
    u16     name[NWC24_FL_NAME_SIZE];   // Nickname [24Bytes]
    u64     fdId;                       // Reserved [8Bytes]
    u32     reserved[6];                // Reserved [24Bytes]

    // 64 Bytes
} NWC24FriendAttr;

typedef union NWC24FriendAddr
{
    NWC24UserId     wiiId;
    char            mailAddr[NWC24_FL_ADDR_LENGTH];
    
    // 256 Bytes
} NWC24FriendAddr;

typedef struct NWC24FriendInfo
{
    NWC24FriendAttr     attr;
    NWC24FriendAddr     addr;
    
    // 320 Bytes
} NWC24FriendInfo;


/*---------------------------------------------------------------------------*
    API Prototypes
 *---------------------------------------------------------------------------*/
#ifdef __cplusplus
extern "C" {
#endif

/*---------------------------------------------------------------------------*/

NWC24Err NWC24ReadFriendInfo( NWC24FriendInfo* info, u32 index );
NWC24Err NWC24WriteFriendInfo( const NWC24FriendInfo* info, u32 index );
NWC24Err NWC24UpdateFriendInfo( const NWC24FriendInfo* info, u32 index );
NWC24Err NWC24DeleteFriendInfo( u32 index );
NWC24Err NWC24SwapFriendInfos( u32 index0, u32 index1 );
NWC24Err NWC24GetFriendInfoStatus( u32* type, u32* status, u32 index );

NWC24Err NWC24SearchFriendInfoById( NWC24UserId id, u32* index );
NWC24Err NWC24SearchFriendInfoByAddr( const NWC24FriendAddr* addr, u32* index );

NWC24Err NWC24GetNumFriendInfos( u32* num );
NWC24Err NWC24GetNumRegFriendInfos( u32* num );
NWC24Err NWC24GetNumEstFriendInfos( u32* num );
int      NWC24IsFriendInfoThere( u32 index );
NWC24Err NWC24CheckFriendInfo( const NWC24FriendInfo* info );
NWC24Err NWC24CheckPublicMailAddr( const char* addr );


// For debug purpose only.
void     NWC24DumpFriendInfo( const NWC24FriendInfo* info );

/*---------------------------------------------------------------------------*/

#ifdef __cplusplus
}
#endif

#endif  // NWC24FRIENDLIST_H__

