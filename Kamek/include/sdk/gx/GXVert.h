#ifndef __GXVERT_H__
#define __GXVERT_H__

#ifdef __cplusplus
   extern "C" {
#endif /* __cplusplus */

// Define the write gather pipe

typedef union {
    u8 u8;
    u16 u16;
    u32 u32;
    u64 u64;
    s8 s8;
    s16 s16;
    s32 s32;
    s64 s64;
    f32 f32;
    f64 f64;
} PPCWGPipe;

/*
volatile PPCWGPipe GXWGFifo;//:0xCC008000;

// Template functions
#define __GXCDEF(prfx,n,t)  __GXCDEF##n(prfx##n##t,t,t)
#define __GXCDEFX(func,n,t) __GXCDEF##n(func,t,t)

#define __GXCDEF1(func,ts,td) \
static inline void func(const ts x) { \
    GXWGFifo.td = (td) x; \
}

#define __GXCDEF2(func,ts,td) \
static inline void func(const ts x, const ts y) { \
    GXWGFifo.td = (td) x; \
    GXWGFifo.td = (td) y; \
}

#define __GXCDEF3(func,ts,td) \
static inline void func(const ts x, const ts y, const ts z) { \
    GXWGFifo.td = (td) x; \
    GXWGFifo.td = (td) y; \
    GXWGFifo.td = (td) z; \
}

#define __GXCDEF4(func,ts,td) \
static inline void func(const ts x, const ts y, const ts z, const ts w) { \
    GXWGFifo.td = (td) x; \
    GXWGFifo.td = (td) y; \
    GXWGFifo.td = (td) z; \
    GXWGFifo.td = (td) w; \
}

// Generate inlines
// Commands
__GXCDEF(GXCmd, 1, u8)
__GXCDEF(GXCmd, 1, u16)
__GXCDEF(GXCmd, 1, u32)

// Params
__GXCDEF(GXParam, 1, u8)
__GXCDEF(GXParam, 1, u16)
__GXCDEF(GXParam, 1, u32)
__GXCDEF(GXParam, 1, s8)
__GXCDEF(GXParam, 1, s16)
__GXCDEF(GXParam, 1, s32)
__GXCDEF(GXParam, 1, f32)
__GXCDEF(GXParam, 3, f32) // for light
__GXCDEF(GXParam, 4, f32) // for matrix

// Position
__GXCDEF(GXPosition, 3, f32)
__GXCDEF(GXPosition, 3, u8)
__GXCDEF(GXPosition, 3, s8)
__GXCDEF(GXPosition, 3, u16)
__GXCDEF(GXPosition, 3, s16)
__GXCDEF(GXPosition, 2, f32)
__GXCDEF(GXPosition, 2, u8)
__GXCDEF(GXPosition, 2, s8)
__GXCDEF(GXPosition, 2, u16)
__GXCDEF(GXPosition, 2, s16)
__GXCDEFX(GXPosition1x16, 1, u16)
__GXCDEFX(GXPosition1x8,  1, u8)

// Normal
__GXCDEF(GXNormal, 3, f32)
__GXCDEF(GXNormal, 3, s16)
__GXCDEF(GXNormal, 3, s8)
__GXCDEFX(GXNormal1x16, 1, u16)
__GXCDEFX(GXNormal1x8,  1, u8)

// Color
__GXCDEF(GXColor, 4, u8)
__GXCDEF(GXColor, 1, u32)
__GXCDEF(GXColor, 3, u8)
__GXCDEF(GXColor, 1, u16)
__GXCDEFX(GXColor1x16, 1, u16)
__GXCDEFX(GXColor1x8,  1, u8)

// TexCoord
__GXCDEF(GXTexCoord, 2, f32)
__GXCDEF(GXTexCoord, 2, s16)
__GXCDEF(GXTexCoord, 2, u16)
__GXCDEF(GXTexCoord, 2, s8)
__GXCDEF(GXTexCoord, 2, u8)
__GXCDEF(GXTexCoord, 1, f32)
__GXCDEF(GXTexCoord, 1, s16)
__GXCDEF(GXTexCoord, 1, u16)
__GXCDEF(GXTexCoord, 1, s8)
__GXCDEF(GXTexCoord, 1, u8)
__GXCDEFX(GXTexCoord1x16, 1, u16)
__GXCDEFX(GXTexCoord1x8,  1, u8)

// Matrix
__GXCDEF(GXMatrixIndex, 1, u8)

// Undefine all templates
#undef  __GXCDEF
#undef  __GXCDEFX
#undef  __GXCDEF1
#undef  __GXCDEF2
#undef  __GXCDEF3
#undef  __GXCDEF4

*/

#ifdef __cplusplus
   }
#endif /* __cplusplus */

#endif