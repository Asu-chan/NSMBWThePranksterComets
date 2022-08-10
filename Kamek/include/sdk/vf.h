/*---------------------------------------------------------------------------*
  Project:  Revolution Virtual File System library
  File:     vf.h

  Copyright (C) 2006 Nintendo All rights reserved.

  These coded instructions, statements, and computer programs contain
  proprietary information of Nintendo of America Inc. and/or Nintendo
  Company Ltd., and are protected by Federal copyright law.  They may
  not be disclosed to third parties or copied or duplicated in any form,
  in whole or in part, without the prior written consent of Nintendo.
 *---------------------------------------------------------------------------*/

#ifndef __VF_H__
#define __VF_H__

#ifdef  __cplusplus
extern "C" {
#endif  // __cplusplus

// #include <stddef.h>

/*---------------------------------------------------------------------------*
 * Includes
 *---------------------------------------------------------------------------*/
#if defined(RVL_OS)
// #include <revolution/types.h>
#else
// #include <revolution/vf/VFPrivate.h>
#endif


/*---------------------------------------------------------------------------*
 * Definitions
 *---------------------------------------------------------------------------*/

#define VF_IS_UNAVAILABLE       (0)
#define VF_IS_AVAILABLE         (1)

#define VF_SEEK_CUR             (0x01)
#define VF_SEEK_SET             (0x00)
#define VF_SEEK_END             (0x02)


#define VF_ERR_SUCCESS          (0)
#define VF_ERR_EPERM            (1)         /* Operation is not possible    */
#define VF_ERR_ENOENT           (2)         /* No such file or directory    */
#define VF_ERR_EIO              (5)         /* I/O Error(Driver Error)      */
#define VF_ERR_ENOEXEC          (8)         /* Not Executable by internal   */
#define VF_ERR_EBADF            (9)         /* Bad file descriptor          */
#define VF_ERR_ENOMEM           (12)        /* Not enough system memory     */
#define VF_ERR_EACCES           (13)        /* Permission denied            */
#define VF_ERR_EBUSY            (16)        /* Can not use system resouces  */
#define VF_ERR_EEXIST           (17)        /* File already exists          */
#define VF_ERR_EISDIR           (21)        /* find directory when file req */
#define VF_ERR_EINVAL           (22)        /* Invalid argument             */
#define VF_ERR_ENFILE           (23)        /* Too many open files(system)  */
#define VF_ERR_EMFILE           (24)        /* Too many open files(user)    */
#define VF_ERR_EFBIG            (27)        /* Over file size limit(4GB-1)  */
#define VF_ERR_ENOSPC           (28)        /* Device out of space          */
#define VF_ERR_ENOLCK           (46)        /* Can not lock the file        */
#define VF_ERR_ENOSYS           (88)        /* Not implement function       */
#define VF_ERR_ENOTEMPTY        (90)        /* Directory is not empty       */
//#define VF_ERR_DFNC             (0x1000)    /* Driver Error                 */
#define VF_ERR_SYSTEM           (-1)        /* system error(general error)  */

#define VF_ERR_BASE             (0xb000)
#define VF_ERR_NOT_EXIST_FILE               (VF_ERR_BASE + 0x01)
#define VF_ERR_CANNOT_ALLOC_DRV             (VF_ERR_BASE + 0x02)
#define VF_ERR_NOT_ALLOCATED_DRV            (VF_ERR_BASE + 0x03)
#define VF_ERR_ALREADY_ATTACHED_DRV_NAME    (VF_ERR_BASE + 0x04)
#define VF_ERR_ALREADY_MOUNTED_DRV_NAME     (VF_ERR_BASE + 0x05)
#define VF_ERR_VFF_FILE_FORMAT              (VF_ERR_BASE + 0x06)


#define VF_DRIVE_WORKSIZE           (16 * 1024)
#if defined(RVL_OS)
#define VF_DRIVE_MAX                (26)
#else
#define VF_DRIVE_MAX                (2)
#endif

#define VF_DRIVE_NAME_MAX           (7)
#define VF_DRIVE_NAME_MAX_INC_NULL  (VF_DRIVE_NAME_MAX + 1)

#define VF_LONG_NAME_PATH_CHARS     (260-1)
#define VF_LONG_NAME_PATH_SIZE      (VF_LONG_NAME_PATH_CHARS * 2)
#define VF_LONG_NAME_PATH_BUF_SIZE  (VF_LONG_NAME_PATH_SIZE + 2)
#define VF_PATH_BUF_SIZE            (VF_LONG_NAME_PATH_BUF_SIZE)

#define VF_SHORT_DOT_NAME_SIZE      (12)
#define VF_SHORT_NAME_BUF_SIZE      (VF_SHORT_DOT_NAME_SIZE + 1)

#define VF_SHORT_DOT_NAME_CHARS     (12)
#define VF_LONG_NAME_CHARS          (255)


//File attributes
#define VF_ATTR_RDONLY      ((u8)0x01)   /* read only            */
#define VF_ATTR_HIDDEN      ((u8)0x02)   /* hidden               */
#define VF_ATTR_SYSTEM      ((u8)0x04)   /* system               */
#define VF_ATTR_VOLUME      ((u8)0x08)   /* volume label         */
#define VF_ATTR_DIR         ((u8)0x10)   /* subdirectory         */
#define VF_ATTR_ARCH        ((u8)0x20)   /* archives             */
#define VF_ATTR_NONE        ((u8)0x40)   /* none                 */
#define VF_ATTR_ALL         ((u8)0x7f)   /* for fsfirst function */
#define VF_ATTR_CAND        ((u8)0x80)   /* AND mode             */

#define VF_DTA_GET_FILE_ATTR(dta)           ((dta).attribute)
#define VF_DTA_GET_FILE_NAME_P(dta)         ((dta).fileName)
#define VF_DTA_GET_LONG_FILE_NAME_P(dta)    ((dta).longName)
#define VF_DTA_GET_FILE_SIZE(dta)           ((dta).fileSize)
#define VF_DTA_GET_FILE_SECONDS(dta)        VFiConvertFileTimeToSeconds((dta).date, (dta).time)


//Event
#define VF_EVENT_NONE       (0x00)
#define VF_EVENT_INSERTED   (0x01)
#define VF_EVENT_EJECTED    (0x02)

//Sync Mode
#define VF_SYNC_MODE_ON     (0x00)  /* default */
#define VF_SYNC_MODE_OFF    (0x01)

//Buffering mode
#define VF_WRTSOON          (0x1)   /* write soon                    */
#define VF_NWRTSOON         (0x0)   /* not write soon                */
#define VF_AUTOSYNC         (0x2)   /* cache is not used effectively */
#define VF_NAUTOSYNC        (0x0)   /* cache is used effectively     */
#define VF_FAT_WRITE_THRU   (0x4)

#define VF_EJECT_SAFE_WITH_WRITE_THRU   (VF_WRTSOON)
#define VF_EJECT_SAFE_WITH_WRITE_BACK   (VF_NWRTSOON | VF_AUTOSYNC | VF_FAT_WRITE_THRU)
#define VF_WRITE_BACK_ON_SIGNIF_API     (VF_NWRTSOON | VF_AUTOSYNC)
#define VF_WRITE_BACK_CACHE             (VF_NWRTSOON | VF_NAUTOSYNC)

//Sync cache mode    
#define VF_INVALIDATE       (0x1)
#define VF_NINVALIDATE      (0x0)

//cache
#define VF_CACHE_SIZE_MIN   (0x2800)


/*---------------------------------------------------------------------------*
 * Types/Declarations
 *---------------------------------------------------------------------------*/

typedef void    VFFile;
typedef void    VFDir;
typedef void    VFVol;
typedef s32     VFDevErr;
typedef s32     VFErr;
typedef u16     VFWchar;
typedef u32     VFEvent;

typedef void    (*VFEventCallback)( VFEvent event );

typedef struct VFDta {
    VFFile* file;
    VFDir*  dir;
    VFVol*  vol;

    u32     parentStartCluster;
    u32     parentPos;

    u32     status;
    u8      numEntryLFNs;
    u8      ordinal;
    u8      check_sum;
    u8      attr;
    s8      regExp[VF_PATH_BUF_SIZE];

    u16     time;
    u16     date;
    u32     fileSize;

    u8      attribute;
    s8      fileName[VF_SHORT_NAME_BUF_SIZE];
    s8      longName[VF_LONG_NAME_PATH_SIZE + 2];
    s8      pad[2];
} VFDta;

typedef struct VFWDta {
    VFFile* file;
    VFDir*  dir;
    VFVol*  vol;

    u32     parentStartCluster;
    u32     parentPos;
    u32     status;
    u8      numEntryLFNs;
    u8      ordinal;
    u8      check_sum;
    u8      attr;
    s8      regExp[VF_PATH_BUF_SIZE];

    u16     time;
    u16     date;

    u32     fileSize;
    u8      attribute;
    s8      fileName[VF_SHORT_NAME_BUF_SIZE];
    s8      longName[VF_LONG_NAME_PATH_BUF_SIZE + 2];

    VFWchar regExpUni[VF_LONG_NAME_PATH_CHARS + 1];
    VFWchar fileNameUni[VF_SHORT_DOT_NAME_CHARS + 1];
    VFWchar longNameUni[VF_LONG_NAME_CHARS + 1];
    s8      pad[2];
} VFWDta;

typedef struct VFTime {
    s32     sec;
    s32     min;
    s32     hour;
    s32     day;
    s32     month;
    s32     year;
} VFTime;

typedef void    (*VFTimeStampCallback)( VFTime* time );


/*---------------------------------------------------------------------------*
 * Function Prototypes
 *---------------------------------------------------------------------------*/

extern void                VFInit       ( );
extern void                VFInitEx     ( void* heapStartAddress, u32 size );
extern void                VFFinalize   ( );
extern s32                 VFIsAvailable( );

extern VFDevErr            VFCreateSystemFileNANDFlash ( const char* sysFileName, u32 fileSize );
extern VFDevErr            VFCreateSystemFileRam       ( void* memory, u32 fileSize );

extern VFErr               VFAttachDriveNANDFlash      ( const char* drive );
extern VFErr               VFAttachDriveNANDFlashW     ( const VFWchar* drive );
extern VFErr               VFAttachDriveNANDFlashCache ( const char* drive, void* cacheAddress, u32 cacheSize );
extern VFErr               VFAttachDriveNANDFlashCacheW( const VFWchar* drive, void* cacheAddress, u32 cacheSize );
extern VFErr               VFAttachDriveRam            ( const char* drive );
extern VFErr               VFAttachDriveRamW           ( const VFWchar* drive );
extern VFErr               VFAttachDriveRamCache       ( const char* drive, void* cacheAddress, u32 cacheSize );
extern VFErr               VFAttachDriveRamCacheW      ( const VFWchar* drive, void* cacheAddress, u32 cacheSize );
extern VFErr               VFAttachDriveDVD            ( const char* drive );
extern VFErr               VFAttachDriveDVDW           ( const VFWchar* drive );
extern VFErr               VFAttachDriveDVDCache       ( const char* drive, void* cacheAddress, u32 cacheSize );
extern VFErr               VFAttachDriveDVDCacheW      ( const VFWchar* drive, void* cacheAddress, u32 cacheSize );
extern VFErr               VFDetachDrive               ( const char* drive );
extern VFErr               VFDetachDriveW              ( const VFWchar* drive );

extern VFErr               VFActivateDriveNANDFlash    ( const char* drive, const char* sysFileName );
extern VFErr               VFActivateDriveNANDFlashW   ( const VFWchar* drive, const char* sysFileName );
extern VFErr               VFActivateDriveRam          ( const char* drive, void* memory );
extern VFErr               VFActivateDriveRamW         ( const VFWchar* drive, void* memory );
extern VFErr               VFActivateDriveDVD          ( const char* drive, const char* sysFileName );
extern VFErr               VFActivateDriveDVDW         ( const VFWchar* drive, const char* sysFileName );
extern VFErr               VFInactivateDrive           ( const char* drive );
extern VFErr               VFInactivateDriveW          ( const VFWchar* drive );
extern VFErr               VFInactivateDriveForce      ( const char* drive );
extern VFErr               VFInactivateDriveForceW     ( const VFWchar* drive );

extern VFErr               VFMountDriveNANDFlash       ( const char* drive, const char* sysFileName );
extern VFErr               VFMountDriveNANDFlashW      ( const VFWchar* drive, const char* sysFileName );
extern VFErr               VFMountDriveNANDFlashCache  ( const char* drive, const char* sysFileName, void* cacheAddress, u32 cacheSize );
extern VFErr               VFMountDriveNANDFlashCacheW ( const VFWchar* drive, const char* sysFileName, void* cacheAddress, u32 cacheSize );
extern VFErr               VFMountDriveRam             ( const char* drive, void* memory );
extern VFErr               VFMountDriveRamW            ( const VFWchar* drive, void* memory );
extern VFErr               VFMountDriveRamCache        ( const char* drive, void* memory, void* cacheAddress, u32 cache_size );
extern VFErr               VFMountDriveRamCacheW       ( const VFWchar* drive, void* memory, void* cacheAddress, u32 cache_size );
extern VFErr               VFMountDriveDVD             ( const char* drive, const char* sysFileName );
extern VFErr               VFMountDriveDVDW            ( const VFWchar* drive, const char* sysFileName );
extern VFErr               VFMountDriveDVDCache        ( const char* drive, const char* sysFileName, void* cacheAddress, u32 cacheSize );
extern VFErr               VFMountDriveDVDCacheW       ( const VFWchar* drive, const char* sysFileName, void* cacheAddress, u32 cacheSize );
extern VFErr               VFUnmountDrive              ( const char* drive );
extern VFErr               VFUnmountDriveW             ( const VFWchar* drive );
extern VFErr               VFUnmountDriveForce         ( const char* drive );
extern VFErr               VFUnmountDriveForceW        ( const VFWchar* drive );

extern VFFile*             VFCreateFile                ( const char* path, u32 attr );
extern VFFile*             VFCreateFileW               ( const VFWchar* path, u32 attr );
extern VFFile*             VFOpenFile                  ( const char* path, const char* mode, u32 attr );
extern VFFile*             VFOpenFileW                 ( const VFWchar* path, const VFWchar* mode, u32 attr );
extern VFErr               VFCloseFile                 ( VFFile* file );

extern VFErr               VFSeekFile                  ( VFFile* file, s32 offset, s32 origin );
extern VFErr               VFReadFile                  ( VFFile* file, void* buf, u32 size , u32* read_size );
extern VFErr               VFWriteFile                 ( VFFile* file, const void* buf, u32 size );
extern VFErr               VFDeleteFile                ( const char* path );
extern VFErr               VFDeleteFileW               ( const VFWchar* path );
extern VFErr               VFRenameFile                ( const char* old_name, const char* new_name );
extern VFErr               VFRenameFileW               ( const VFWchar* old_name, const VFWchar* new_name );
extern VFErr               VFMoveFile                  ( const char* src_name, const char* dst_name );
extern VFErr               VFMoveFileW                 ( const VFWchar* src_name, const VFWchar* dst_name );
extern VFErr               VFRenameDir                 ( const char* old_name, const char* new_name );
extern VFErr               VFRenameDirW                ( const VFWchar* old_name, const VFWchar* new_name );
extern VFErr               VFMoveDir                   ( const char* src_name, const char* dst_name );
extern VFErr               VFMoveDirW                  ( const VFWchar* src_name, const VFWchar* dst_name );
extern VFErr               VFCreateDir                 ( const char* dirName );
extern VFErr               VFCreateDirW                ( const VFWchar* dirName );
extern VFErr               VFChangeDir                 ( const char* dirName );
extern VFErr               VFChangeDirW                ( const VFWchar* dirName );
extern VFErr               VFDeleteDir                 ( const char* dirName );
extern VFErr               VFDeleteDirW                ( const VFWchar* dirName );
extern s32                 VFGetFileSize               ( const char* path );
extern s32                 VFGetFileSizeW              ( const VFWchar* path );
extern VFErr               VFGetFileSizeU32            ( const char* path, u32* file_size );
extern VFErr               VFGetFileSizeU32W           ( const VFWchar* path, u32* file_size );
extern VFErr               VFFileSearchFirst           ( VFDta* dta, const char* path, u8 attr );
extern VFErr               VFFileSearchFirstW          ( VFWDta* dta, const VFWchar* path, u8 attr );
extern VFErr               VFFileSearchNext            ( VFDta* dta );
extern VFErr               VFFileSearchNextW           ( VFWDta* dta );

extern VFErr               VFGetLastError              ( void );

extern VFDevErr            VFGetLastDeviceError        ( const char* drive );
extern VFDevErr            VFGetLastDeviceErrorW       ( const VFWchar* drive );
extern s32                 VFGetDriveFreeSize          ( const char* drive );
extern s32                 VFGetDriveFreeSizeW         ( const VFWchar* drive );
extern VFErr               VFGetDriveFreeSizeU64       ( const char* drive, u64* free_size );
extern VFErr               VFGetDriveFreeSizeU64W      ( const VFWchar* drive, u64* free_size );
extern s32                 VFGetOffsetByFd             ( VFFile* file );
extern VFErr               VFGetOffsetU32ByFd          ( VFFile* file, u32* offset );
extern s32                 VFGetFileSizeByFd           ( VFFile* file );
extern VFErr               VFGetFileSizeU32ByFd        ( VFFile* file, u32* file_size );

extern VFErr               VFCutFileSize               ( const char* path, u32 fileSize );
extern VFErr               VFCutFileSizeW              ( const VFWchar* path, u32 fileSize );

extern VFErr               VFFormatDrive               ( const char* drive );
extern VFErr               VFFormatDriveW              ( const VFWchar* drive );

extern VFErr               VFSetSyncMode               ( const char* drive, u32 mode );
extern VFErr               VFSetSyncModeW              ( const VFWchar* drive, u32 mode );

extern VFErr               VFSync                      ( const char* drive, s32 mode );
extern VFErr               VFSyncW                     ( const VFWchar* drive, s32 mode );
extern VFErr               VFFileSync                  ( VFFile* file );

extern VFErr               VFBuffering                 ( const char* drive, s32 mode );
extern VFErr               VFBufferingW                ( const VFWchar* drive, s32 mode );

extern VFDevErr            VFDeleteSystemFileNANDFlash ( const char* sysFileName );
extern VFTimeStampCallback VFSetTimeStampCallback      ( VFTimeStampCallback i_timestamp_callback );
extern const char*         VFGetApiErrorString         ( VFErr error );

//internal function
extern s64                 VFiConvertFileTimeToSeconds ( u16 date, u16 time );
//test proc


#ifdef  __cplusplus
}
#endif  // __cplusplus
#endif  // __VF_H__
