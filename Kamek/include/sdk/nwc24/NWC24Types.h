/*---------------------------------------------------------------------------*
  Project:  WiiConnect24
  File:     NWC24Types.h

  Copyright (C) 2006 Nintendo. All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law. They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24Types.h,v $
  Revision 1.20  2008/04/11 11:19:04  hirose_kazuki
  Merged changes of 1.17.8.1.

  Revision 1.17.8.1  2008/01/28 04:17:34  hirose_kazuki
  Added Charset/AutoEncodingType definitions for CK support.

  Revision 1.19  2007/07/12 12:00:55  hirose_kazuki
  Added type definition of NWC24SearchCompareMode.

  Revision 1.18  2007/06/30 02:00:07  hirose_kazuki
  Deleted definition of NWC24_CHJP_OPTOUT_ENABLE.

  Revision 1.17  2007/06/04 12:52:55  hirose_kazuki
  Added definition of NWC24CHJumpObj.

  Revision 1.16  2007/05/29 05:41:58  hirose_kazuki
  Added definition of NWC24MBJumpHeader.
  Deleted NWC24MIMEType definitions that were added recently.

  Revision 1.15  2007/05/24 02:00:40  hirose_kazuki
  Added definition of NWC24_LED_*_DEFAULT.
  Removed definition of NWC24_LED_PATTERN_DEFAULT instead.

  Revision 1.14  2007/05/03 09:57:44  hirose_kazuki
  Added definition of NWC24_LED_PATTERN_DEFAULT.

  Revision 1.13  2007/04/24 12:33:16  hirose_kazuki
  Added definition of NWC24_AUD_WII_SOUND.

  Revision 1.12  2007/04/18 02:51:13  hirose_kazuki
  Added definition of NWC24_APP_WII_CHJUMP.

  Revision 1.11  2007/04/10 04:37:30  adachi_hiroaki
  Supported Win32 platform.

  Revision 1.10  2006/11/08 00:54:30  torigoe_nobutaka
  Added definition of NWC24_WINDOWS_1252.

  Revision 1.9  2006/10/30 05:48:01  hirose_kazuki
  Added definition of NWC24_MUL_RELATED.

  Revision 1.8  2006/10/29 17:32:23  seiki_masashi
  Added NWC24AutoEncodingType.

  Revision 1.7  2006/10/24 01:17:24  hirose_kazuki
  Added definition of NWC24_TXT_HTML and NWC24_MUL_ALTERNATIVE.

  Revision 1.6  2006/10/09 10:34:04  hirose_kazuki
  Added enum values for NWC24Charset.

  Revision 1.5  2006/09/21 02:34:14  hirose_kazuki
  Rearrangement of message types.

  Revision 1.4  2006/09/20 12:55:31  hirose_kazuki
  Added definition of NWC24_APP_WII_MINIDATA.
  Redefined enums of NWC24MsgType.

  Revision 1.3  2006/09/02 04:25:02  hirose_kazuki
  Updated NWC24MIMEType definitions to support message board data.

  Revision 1.2  2006/08/15 01:24:00  yasu
  Added definitions of basic variables in IOP

  Revision 1.1  2006/08/07 05:57:05  hirose_kazuki
  Separated from NWC24Msg.h.
  Added new type NWC24_MSGTYPE_WII_HIDDEN to NWC24MsgType.


 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    NWC24 Message API
 *---------------------------------------------------------------------------*/
#ifndef __NWC24TYPES_H__
#define __NWC24TYPES_H__

#ifdef __MWERKS__
#pragma enumsalwaysint on
#endif // __MWERKS__

#if defined(RVL_OS) || defined(WIN32)
#endif //RVL_OS

/*---------------------------------------------------------------------------*
    Type definitions
 *---------------------------------------------------------------------------*/

typedef enum NWC24MsgType
{
    NWC24_MSGTYPE_RVL_MENU_SHARED = 0,
    NWC24_MSGTYPE_WII_MENU_SHARED = 0,
    NWC24_MSGTYPE_RVL_APP = 1,
    NWC24_MSGTYPE_WII_APP = 1,
    NWC24_MSGTYPE_RVL_MENU = 2,
    NWC24_MSGTYPE_WII_MENU = 2,
    NWC24_MSGTYPE_RVL_APP_HIDDEN = 3,
    NWC24_MSGTYPE_WII_APP_HIDDEN = 3,
    
#if 1
    NWC24_MSGTYPE_RVL = 1,              // Obsoleted: for compatibility
    NWC24_MSGTYPE_WII = 1,              // Obsoleted: for compatibility
    NWC24_MSGTYPE_RVL_APP_ONLY = 1,     // Obsoleted: for compatibility
    NWC24_MSGTYPE_WII_APP_ONLY = 1,     // Obsoleted: for compatibility
    NWC24_MSGTYPE_RVL_MENU_ONLY = 2,    // Obsoleted: for compatibility
    NWC24_MSGTYPE_WII_MENU_ONLY = 2,    // Obsoleted: for compatibility
    NWC24_MSGTYPE_RVL_HIDDEN = 3,       // Obsoleted: for compatibility
    NWC24_MSGTYPE_WII_HIDDEN = 3,       // Obsoleted: for compatibility
#endif

    NWC24_MSGTYPE_PUBLIC = 4

} NWC24MsgType;

typedef enum NWC24MsgBoxId
{
    NWC24_SEND_BOX,
    NWC24_RECV_BOX
    
} NWC24MsgBoxId;

typedef enum NWC24Charset
{
    NWC24_US_ASCII          = 0x00000000,
    NWC24_UTF_8             = 0x00010008,
    NWC24_UTF_16            = 0x00010010,
    NWC24_UTF_16BE          = 0x00010010,   // same
    NWC24_UTF_32            = 0x00010020,
    NWC24_UTF_32BE          = 0x00010020,   // same
    NWC24_ISO_2022_JP       = 0x00020000,
    NWC24_SHIFT_JIS         = 0x00020001,
    NWC24_EUC_JP            = 0x00020002,
    NWC24_EUC_KR            = 0x00030002,
    NWC24_ISO_8859_1        = 0x00080001,
    NWC24_ISO_8859_2        = 0x00080002,
    NWC24_ISO_8859_3        = 0x00080003,
    NWC24_ISO_8859_5        = 0x00080005,
    NWC24_ISO_8859_7        = 0x00080007,
    NWC24_ISO_8859_9        = 0x00080009,
    NWC24_ISO_8859_10       = 0x0008000A,
    NWC24_ISO_8859_15       = 0x0008000F,
    NWC24_GB_2312           = 0x000B2312,
    NWC24_WINDOWS_1252      = 0x000F1252,
    
    NWC24_CHARSET_UNKNOWN   = 0xFFFFFFFF
    
} NWC24Charset;

typedef enum NWC24Encoding
{
    NWC24_ENC_7BIT,
    NWC24_ENC_8BIT,
    NWC24_ENC_BASE64,
    NWC24_ENC_QUOTED_PRINTABLE,
    NWC24_MAX_ENCODINGS
    
} NWC24Encoding;

typedef enum NWC24MIMEType
{
    NWC24_VOID_MIMETYPE     = 0x00000000,
    NWC24_TXT_PLAIN         = 0x00010000,
    NWC24_TXT_HTML          = 0x00010001,
    NWC24_IMG_JPEG          = 0x00020000,
    NWC24_IMG_WII_PICTURE   = 0x00020001,
    NWC24_APP_OCTET_STREAM  = 0x00030000,
    NWC24_APP_WII_MSGBOARD  = 0x00030001,
    NWC24_APP_WII_MINIDATA  = 0x00030002,
    NWC24_MUL_MIXED         = 0x000F0000,
    NWC24_MUL_ALTERNATIVE   = 0x000F0001,
    NWC24_MUL_RELATED       = 0x000F0002
    
} NWC24MIMEType;

typedef enum NWC24AutoEncodingType
{
    NWC24_AUTOENCODING_JP        = 0,
    NWC24_AUTOENCODING_US        = 1,
    NWC24_AUTOENCODING_EU        = 2,
    NWC24_AUTOENCODING_KR        = 3,
    NWC24_AUTOENCODING_CN        = 4
    
} NWC24AutoEncodingType;

typedef enum NWC24SearchCompareMode
{
    NWC24_SEARCH_CMP_NEQUAL     = 0,
    NWC24_SEARCH_CMP_EQUAL      = 1,
    NWC24_SEARCH_CMP_LEQUAL     = 2,
    NWC24_SEARCH_CMP_GEQUAL     = 3,
    NWC24_SEARCH_CMP_BITMASK    = 4
} NWC24SearchCompareMode;

typedef u64 NWC24UserId;


typedef struct NWC24MsgObj
{
    // 256 bytes
    u32             data[64];
    
} NWC24MsgObj;


#define NWC24_CHJP_DATA_MAX         (512+64)
#define NWC24_CHJP_NUMBLOCKS_MAX    8

typedef struct NWC24CHJumpHeader
{
    u32             magic;
    u32             totalSize;
    u32             numBlocks;
    u32             options;
    u64             titleId;
    
} NWC24CHJumpHeader;

typedef struct NWC24CHJumpObj
{
    NWC24CHJumpHeader   header;
    char                data[NWC24_CHJP_DATA_MAX];
    
} NWC24CHJumpObj;


#define NWC24_LED_APP_DEFAULT       0x00002019U
#define NWC24_LED_SYSMENU_DEFAULT   0x00004001U

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

#endif  // __NWC24TYPES_H__

