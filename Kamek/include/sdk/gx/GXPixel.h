#ifndef __GXPIXEL_H__
#define __GXPIXEL_H__

#include <sdk/gx/GXEnum.h>

#ifdef __cplusplus
   extern "C" {
#endif /* __cplusplus */

void GXSetBlendMode(GXBlendMode::Value blendMode, GXBlendFactor::Value srcFactor, GXBlendFactor::Value dstFactor, GXLogicOp::Value logicOp);

void GXSetZMode(bool compareEnable, GXCompare::Value compareFunc, bool updateEnable);
void GXSetZCompLoc(bool beforeTex);

#ifdef __cplusplus
   }
#endif /* __cplusplus */

#endif