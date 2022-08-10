/*---------------------------------------------------------------------------*
  Project:  WiiConnect24
  File:     NWC24Err.h

  Copyright (C) 2006 Nintendo. All Rights Reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law. They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.

  $Log: NWC24Err.h,v $
  Revision 1.28  2008/04/28 09:39:28  hirose_kazuki
  Added NWC24_ERR_OTHER_REGION.
  Added check for NWC24_ERR_BROKEN into NWC24_ERR_IS_FILE() macro.

  Revision 1.27  2008/03/07 01:17:13  hirose_kazuki
  Added NWC24_ERRCODE_STANDBY_DISABLED.

  Revision 1.26  2007/06/08 05:34:41  adachi_hiroaki
  Added NWC24_ERR_SCRIPT_VERSION and NWC24_ERR_GIVE_UP.

  Revision 1.25  2007/04/12 12:05:05  hirose_kazuki
  Added even more NWC24_ERRCODE_* definitions.

  Revision 1.24  2007/03/27 06:39:30  hirose_kazuki
  Added some more NWC24_ERRCODE_* definitions.

  Revision 1.23  2007/01/31 08:43:03  hirose_kazuki
  Added NWC24_ERR_OLD_SYSTEM.

  Revision 1.22  2006/11/15 08:36:48  hirose_kazuki
  Added NWC24_ERR_CANCELLED.

  Revision 1.21  2006/11/06 13:53:58  hirose_kazuki
  Added NWC24_ERRCODE_AT_CHECK() macro.

  Revision 1.20  2006/11/03 07:16:48  hirose_kazuki
  Added error grouping macros.

  Revision 1.19  2006/10/31 12:37:17  hirose_kazuki
  Added definition of NWC24_ERRCODE_AT_REGISTER.

  Revision 1.18  2006/10/29 17:30:19  seiki_masashi
  Added NWC24_ERR_INVALID_CHAR.

  Revision 1.17  2006/10/26 08:17:20  hirose_kazuki
  Defined NWC24_ERRCODE_SYSCONFIG.

  Revision 1.16  2006/10/19 04:35:32  hirose_kazuki
  Added global error code definitions.

  Revision 1.15  2006/10/16 00:50:44  adachi_hiroaki
  Added NWC24_ERR_FILE_BROKEN.

  Revision 1.14  2006/10/05 09:44:49  adachi_hiroaki
  Added NWC24_ERR_ID_NOT_REGISTERED, NWC24_ERR_VERIFY_SIGNATURE.

  Revision 1.13  2006/10/02 08:49:48  hirose_kazuki
  Renamed latest two enum definitions.

  Revision 1.12  2006/09/30 12:38:46  hirose_kazuki
  Added NWC24_ERR_INTER_PROC and NWC24_ERR_VFLIB.

  Revision 1.11  2006/09/28 11:34:54  adachi_hiroaki
  Added some error codes for the download API.

  Revision 1.10  2006/09/23 05:51:31  hirose_kazuki
  Added NWC24_ERR_NAND_CORRUPT.

  Revision 1.9  2006/09/06 01:46:36  hirose_kazuki
  Added NWC24_ERR_ID_CRC.

  Revision 1.8  2006/08/23 06:00:46  adachi_hiroaki
  Changed error codes for account creation.

  Revision 1.7  2006/08/18 02:42:22  adachi_hiroaki
  Added some error codes.

  Revision 1.6  2006/08/16 06:19:42  hirose_kazuki
  Added NWC24_ERR_NOT_READY.

  Revision 1.5  2006/08/10 13:05:57  terui
  Added NWC24_ERR_INPROGRESS definition

  Revision 1.4  2006/07/15 00:59:58  hirose_kazuki
  Added new enum values.

  Revision 1.3  2006/07/11 04:32:16  hirose_kazuki
  Yet another repository reforming.

  Revision 1.1  2006/07/03 03:23:31  yosizaki
  Moved from ../ppc

  Revision 1.2  2006/07/01 11:33:11  hirose_kazuki
  Added NWC24_ERR_BUSY.

  Revision 1.1  2006/06/29 12:43:43  hirose_kazuki
  Moved from another repository.

  Revision 1.1  2006/06/10 10:34:21  hirose
  Initial check in.

 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*
    Error codes used for NWC24 APIs
 *---------------------------------------------------------------------------*/
#ifndef __NWC24ERR_H__
#define __NWC24ERR_H__

/*---------------------------------------------------------------------------*/
typedef enum NWC24Err
{
    NWC24_OK                    = 0,
    NWC24_ERR_FATAL             = -1,
    NWC24_ERR_FAILED            = -2,
    NWC24_ERR_INVALID_VALUE     = -3,
    NWC24_ERR_NOT_SUPPORTED     = -4,
    NWC24_ERR_NULL              = -5,
    NWC24_ERR_FULL              = -6,
    NWC24_ERR_PROTECTED         = -7,
    NWC24_ERR_OVERFLOW          = -8,
    NWC24_ERR_LIB_NOT_OPENED    = -9,
    NWC24_ERR_LIB_OPENED        = -10,
    NWC24_ERR_NOMEM             = -11,
    NWC24_ERR_CONFIG            = -12,
    NWC24_ERR_NOT_FOUND         = -13,
    NWC24_ERR_BROKEN            = -14,
    NWC24_ERR_DONE              = -15,
    NWC24_ERR_FILE_OPEN         = -16,
    NWC24_ERR_FILE_CLOSE        = -17,
    NWC24_ERR_FILE_READ         = -18,
    NWC24_ERR_FILE_WRITE        = -19,
    NWC24_ERR_FILE_NOEXISTS     = -20,
    NWC24_ERR_FILE_OTHER        = -21,
    NWC24_ERR_MUTEX             = -22,
    NWC24_ERR_ALIGNMENT         = -23,
    NWC24_ERR_FORMAT            = -24,
    NWC24_ERR_STRING_END        = -25,
    NWC24_ERR_BUSY              = -26,
    NWC24_ERR_VER_MISMATCH      = -27,
    NWC24_ERR_HIDDEN            = -28,
    NWC24_ERR_INPROGRESS        = -29,
    NWC24_ERR_NOT_READY         = -30,
    NWC24_ERR_NETWORK           = -31,
    NWC24_ERR_SERVER            = -32,
    NWC24_ERR_CONFIG_NETWORK    = -33,
    NWC24_ERR_ID_NOEXISTS       = -34,
    NWC24_ERR_ID_GENERATED      = -35,
    NWC24_ERR_ID_REGISTERED     = -36,
    NWC24_ERR_ID_CRC            = -37,
    NWC24_ERR_NAND_CORRUPT      = -38,
    NWC24_ERR_DISABLED          = -39,
    NWC24_ERR_INVALID_OPERATION = -40,
    NWC24_ERR_FILE_EXISTS       = -41,
    NWC24_ERR_INTERNAL_IPC      = -42,
    NWC24_ERR_INTERNAL_VF       = -43,
    NWC24_ERR_ID_NOT_REGISTERED = -44,
    NWC24_ERR_VERIFY_SIGNATURE  = -45,
    NWC24_ERR_FILE_BROKEN       = -46,
    NWC24_ERR_INVALID_CHAR      = -47,
    NWC24_ERR_CANCELLED         = -48,
    NWC24_ERR_OLD_SYSTEM        = -49,
    NWC24_ERR_SCRIPT_VERSION    = -50,
    NWC24_ERR_GIVE_UP           = -51,
    NWC24_ERR_OTHER_REGION      = -52
    
} NWC24Err;

/*---------------------------------------------------------------------------*/

// Macros to distinguish error properties
#define NWC24_ERR_IS_FILE(err)  \
    ( (( err <= NWC24_ERR_FILE_OPEN ) && ( err >= NWC24_ERR_FILE_OTHER )) || \
      ( err == NWC24_ERR_NAND_CORRUPT ) || \
      ( err == NWC24_ERR_FILE_EXISTS )  || \
      ( err == NWC24_ERR_INTERNAL_VF )  || \
      ( err == NWC24_ERR_FILE_BROKEN )  || \
      ( err == NWC24_ERR_BROKEN ) )

#define NWC24_ERR_IS_FATAL(err) \
    ( ( err == NWC24_ERR_FATAL )          || \
      ( err == NWC24_ERR_NOMEM )          || \
      ( err == NWC24_ERR_INTERNAL_IPC ) )

#define NWC24_ERR_IS_RETRIABLE(err) \
    ( ( err == NWC24_ERR_MUTEX ) || \
      ( err == NWC24_ERR_BUSY )  || \
      ( err == NWC24_ERR_INPROGRESS ) )

/*---------------------------------------------------------------------------*/

// Global error codes
#define NWC24_ERRCODE_BASE                  (-109000)
#define NWC24_ERRCODE_AT_OPEN(err)          (NWC24_ERRCODE_BASE+(err))

#define NWC24_ERRCODE_CHECK                 (-109100)
#define NWC24_ERRCODE_AT_CHECK(err)         (NWC24_ERRCODE_CHECK+(err))

#define NWC24_ERRCODE_SENDBOX_FULL          (-109106)
#define NWC24_ERRCODE_PROHIBITED            (-109107)
#define NWC24_ERRCODE_SYSCONFIG             (-109112)
#define NWC24_ERRCODE_NCD                   (-109133)
#define NWC24_ERRCODE_DISABLED              (-109139)
#define NWC24_ERRCODE_STANDBY_DISABLED      (-109140)
#define NWC24_ERRCODE_ID_NOT_REGISTERED     (-109144)

#define NWC24_ERRCODE_REGISTER              (-109200)
#define NWC24_ERRCODE_AT_REGISTER(err)      (NWC24_ERRCODE_REGISTER+(err))

#define NWC24_ERRCODE_COMMIT                (-109300)
#define NWC24_ERRCODE_AT_COMMIT(err)        (NWC24_ERRCODE_COMMIT+(err))

#define NWC24_ERRCODE_MSGBOX_OPS            (-109400)
#define NWC24_ERRCODE_AT_MSGBOX_OPS(err)    (NWC24_ERRCODE_MSGBOX_OPS+(err))

#define NWC24_ERRCODE_DLTASK_OPS            (-109500)
#define NWC24_ERRCODE_AT_DLTASK_OPS(err)    (NWC24_ERRCODE_DLTASK_OPS+(err))

#define NWC24_ERRCODE_FLIST_OPS             (-109600)
#define NWC24_ERRCODE_AT_FLIST_OPS(err)     (NWC24_ERRCODE_FLIST_OPS+(err))

#define NWC24_ERRCODE_SCD_OPS               (-109700)
#define NWC24_ERRCODE_AT_SCD_OPS(err)       (NWC24_ERRCODE_SCD_OPS+(err))

#define NWC24_ERRCODE_UNDEFINED             (-109999)

/*---------------------------------------------------------------------------*/

#endif  // __NWC24ERR_H__

