#ifndef __CREDITS_CAMERA_H
#define __CREDITS_CAMERA_H

#include <game.h>
#include <common.h>
#include <g3dhax.h>

#define STD_ZOOM 1.0f//29014f

class dCreditsCamera_c : public dBase_c {
	public:
		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		dCreditsCamera_c();

		EGG::Screen screen;
		EGG::LookAtCamera camera3d;

		EGG::ProjectOrtho projection2d;
		EGG::LookAtCamera camera2d;

		Vec camPos, camTarget, camUp;

		float currentX, currentY, currentZ, zoomLevel;

		void calculateScreenGeometry();

		bool isBound;
		Vec *boundTo;
		Vec boundStart;
		Vec posStart;
		Vec bdMin, bdMax;

		bool isTargetted;
		Vec *target;


		float zoomDivisor, screenLeft, screenTop, screenWidth, screenHeight;

		bool followPlayer;
		void panToBounds(float left, float top, float right, float bottom);
		void panToPosition(float x, float y, float zoom=STD_ZOOM);
		bool panning;
		float panFromX, panFromY, panToX, panToY;
		float panFromZoom, panToZoom;
		float panCurrentStep;
		float panTotalSteps;

		void doStuff(float);
		void generateCameraMatrices();
		void updateCameras();

		static dCreditsCamera_c *build();
		static dCreditsCamera_c *instance;
};

#endif

