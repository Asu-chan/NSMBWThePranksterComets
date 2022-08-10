#ifndef __GXENUM_H__
#define __GXENUM_H__

// Source: RVL SDK
#ifdef __cplusplus
   extern "C" {
#endif /* __cplusplus */

typedef struct {
    enum Value {
        // position/normal matrix index
        PNMTXIDX,

        // texture matrix indexes
        TEX0MTXIDX,
        TEX1MTXIDX,
        TEX2MTXIDX,
        TEX3MTXIDX,
        TEX4MTXIDX,
        TEX5MTXIDX,
        TEX6MTXIDX,
        TEX7MTXIDX,

        // position/normal
        POS,
        NRM,

        // colors
        CLR0,
        CLR1,

        // input texture coordinates
        TEX0,
        TEX1,
        TEX2,
        TEX3,
        TEX4,
        TEX5,
        TEX6,
        TEX7,

        // pointers
        POS_MTX_ARRAY,
        NRM_MTX_ARRAY,
        TEX_MTX_ARRAY,
        LIGHT_ARRAY,

        // normal, bi-normal, tangent
        NBT,

        // end of list
        NONE = 0xFF,
    };
} GXAttr;

typedef struct {
    enum Value {
        NONE,
        DIRECT,
        INDEX8,
        INDEX16,
    };
} GXAttrType;

typedef struct {
    enum Value {
        TEXCOORD0,
        TEXCOORD1,
        TEXCOORD2,
        TEXCOORD3,
        TEXCOORD4,
        TEXCOORD5,
        TEXCOORD6,
        TEXCOORD7,
        NONE = 0xFF,
    };
} GXTexCoordID;

typedef struct {
    enum Value {
        POS_XY = 0,
        POS_XYZ = 1,
        NRM_XYZ = 0,
        NRM_NBT = 1, // one index per NBT
        NRM_NBT3 = 2, // one index per each of N/B/T
        CLR_RGB = 0,
        CLR_RGBA = 1,
        TEX_S = 0,
        TEX_ST = 1,
    };
} GXCompCnt;

typedef struct {
    enum Value {
        U8 = 0,
        S8 = 1,
        U16 = 2,
        S16 = 3,
        F32 = 4,

        RGB565 = 0,
        RGB8 = 1,
        RGBX8 = 2,
        RGBA4 = 3,
        RGBA6 = 4,
        RGBA8 = 5,
    };
} GXCompType;

typedef struct {
    enum Value {
        COLOR0,
        COLOR1,
        ALPHA0,
        ALPHA1,
        COLOR0A0, // Color 0 + Alpha 0
        COLOR1A1, // Color 1 + Alpha 1
        COLOR_ZERO, // RGBA = 0
        ALPHA_BUMP, // bump alpha 0-248, RGB=0
        ALPHA_BUMPN, // normalized bump alpha, 0-255, RGB=0
        COLOR_NONE = 0xFF,
    };
} GXChannelID;

typedef struct {
    enum Value {
        REG,
        VTX,
    };
} GXColorSrc;

typedef struct {
    enum Value {
        LIGHT0 = 0x001,
        LIGHT1 = 0x002,
        LIGHT2 = 0x004,
        LIGHT3 = 0x008,
        LIGHT4 = 0x010,
        LIGHT5 = 0x020,
        LIGHT6 = 0x040,
        LIGHT7 = 0x080,
        NONE = 0x000,
    };
} GXLightID;

typedef struct {
    enum Value {
        OFF,
        ON,
        ON_CLAMP,
    };
} GXDiffuseFn;

typedef struct {
    enum Value {
        SPECULAR,
        SPOTLIGHT,
        NONE,
    };
} GXAttnFn;

typedef struct {
    enum Value {
        POINTS = 0xB8,
        LINES = 0xA8,
        LINESTRIP = 0xB0,
        TRIANGLES = 0x90,
        TRIANGLESTRIP = 0x98,
        TRIANGLEFAN = 0xaA0,
        QUADS = 0x80,
    };
} GXPrimitive;

typedef struct {
    enum Value {
        TO_ZERO,
        TO_SIXTEENTH,
        TO_EIGHTH,
        TO_FOURTH,
        TO_HALF,
        TO_ONE,
    };
} GXTexOffset;

typedef struct {
    enum Value {
        NONE,
        FRONT,
        BACK,
        ALL,
   };
} GXCullMode;

typedef struct {
    enum Value {
        C4 = 0x8,
        C8 = 0x9,
        C14X2 = 0xA,
    };
} GXCITexFmt;

#define ZTF_FLAG 0x10 // Z-texture-format
#define CTF_FLAG 0x20 // copy-texture-format only

typedef struct {
    enum Value {
        I4 = 0x0,
        I8 = 0x1,
        IA4 = 0x2,
        IA8 = 0x3,
        RGB565 = 0x4,
        RGB5A3 = 0x5,
        RGBA8 = 0x6,
        CMPR = 0xE,

        CR4 = 0x0 | CTF_FLAG,
        CRA4 = 0x2 | CTF_FLAG,
        CRA8 = 0x3 | CTF_FLAG,
        CYUVA8 = 0x6 | CTF_FLAG,
        CA8 = 0x7 | CTF_FLAG,
        CR8 = 0x8 | CTF_FLAG,
        CG8 = 0x9 | CTF_FLAG,
        CB8 = 0xA | CTF_FLAG,
        CRG8 = 0xB | CTF_FLAG,
        CGB8 = 0xC | CTF_FLAG,

        Z8 = 0x1 | ZTF_FLAG,
        Z16 = 0x3 | ZTF_FLAG,
        Z24X8 = 0x6 | ZTF_FLAG,

        CZ4 = 0x0 | ZTF_FLAG | CTF_FLAG,
        CZ8M = 0x9 | ZTF_FLAG | CTF_FLAG,
        CZ8L = 0xA | ZTF_FLAG | CTF_FLAG,
        CZ16L = 0xC | ZTF_FLAG | CTF_FLAG,
    };
} GXTexFmt;

typedef struct {
    enum Value {
        TEXMAP0,
        TEXMAP1,
        TEXMAP2,
        TEXMAP3,
        TEXMAP4,
        TEXMAP5,
        TEXMAP6,
        TEXMAP7,
        NONE = 0xFF,
        DISABLE = 0x100, // mask: disables texture look up
    };
} GXTexMapID;

typedef struct {
    enum Value {
        MODULATE,
        DECAL,
        BLEND,
        REPLACE,
        PASSCLR,
    };
} GXTevMode;

typedef struct {
    enum Value {
        NONE,
        BLEND,
        LOGIC,
        SUBTRACT,
    };
} GXBlendMode;

typedef struct {
    enum Value {
        ZERO,
        ONE,
        SRCCLR,
        INVSRCCLR,
        SRCALPHA,
        INVSRCALPHA,
        DSTALPHA,
        INVDSTALPHA,
        DSTCLR = SRCCLR,
        INVDSTCLR = INVSRCCLR,
    };
} GXBlendFactor;

typedef struct {
    enum Value {
        NEVER,
        LESS,
        EQUAL,
        LEQUAL,
        GREATER,
        NEQUAL,
        GEQUAL,
        ALWAYS,
    };
} GXCompare;

typedef struct {
    enum Value {
        CLEAR,
        AND,
        REVAND,
        COPY,
        INVAND,
        NOOP,
        XOR,
        OR,
        NOR,
        EQUIV,
        INV,
        REVOR,
        INVCOPY,
        INVOR,
        NAND,
        SET,
    };
} GXLogicOp;

typedef struct {
    enum Value {
        PERSPECTIVE,
        ORTHOGRAPHIC,
    };
} GXProjectionType;

#ifdef __cplusplus
   }
#endif /* __cplusplus */

#endif