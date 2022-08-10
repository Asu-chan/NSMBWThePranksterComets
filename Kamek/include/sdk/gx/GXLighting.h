#ifndef __GXLIGHTING_H__
#define __GXLIGHTING_H__

#ifdef __cplusplus
   extern "C" {
#endif /* __cplusplus */

void GXSetNumChans(u8 numChans);

void GXSetChanCtrl(GXChannelID::Value chan, bool enable, GXColorSrc::Value ambSrc, GXColorSrc::Value matSrc, GXLightID::Value lightMask, GXDiffuseFn::Value diffFunc, GXAttnFn::Value attnFunc);

#ifdef __cplusplus
   }
#endif /* __cplusplus */

#endif 
