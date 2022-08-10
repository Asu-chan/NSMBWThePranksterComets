#include <game.h>
#include <common.h>
#include <stage.h>

class LanguageAskHandler {
public:
	m2d::EmbedLayout_c layout;
	nw4r::lyt::Pane *rootPane;

	u8 data[0x2E0 - 0x19C - 8];
	u32 timer;
	bool hasPressed;
	u8 d2[3];

	u8 layoutLoaded, somethingHasBeenDone, isVisible, hasShownLuigiThing_orSomething;

	u32 currentStateID;

	u32 _2E8;

	u32 countdownToEndabilityCopy, activePlayerCountMultBy4_maybe;
	u32 batteryLevels[4];
	u32 pgCountdown;

	int setup();
	int execute();
	int draw();
	int free();

	void state0_WaitForEndOfAnimOpen();
	void state1_WaitForEndOfButtonOpen();
	void state2_WaitForPress();
	void state3_WaitForEndOfWindowClose();
};

extern u16 IsAlternateCRSINEnabled;
static nw4r::snd::StrmSoundHandle askHandle;

static const wchar_t *languageAskTitles[] = {
	L"けいこく", // JP
	L"I like Assassination Classroom", // EN
	L"Hinweis:", // GE
	L"Attention", // FR
	L"Atención", // SP
	L"Attenzione", // IT
	L"Waarschuwing", // DU
	L"???", // ??
	L"???", // TW
	L"???" // KR
};

static const wchar_t *languageAskMSGs[] = {
	L"このゲームをにほんごでプレイしようと", // JP
	L"しているようですね。",
	L"ざんねんながら、このゲームはげん",
	L"ざいえいごばんしかありませんが、もしあなたが",
	L"えいごとにほんごのりょうほうにかんのうで",
	L"あれば、わたしたちのDiscordサーバーで",
	L"きがるにゲームのほんやくをてつだってください。",

	/*L"この ゲーム を にほんご で プレイ しよ う と", // JP
	L"している よう です ね 。 ",
	L"ざんねん ながら 、 この ゲーム は げん",
	L"ざいえいごばんしかありませんが 、 もし あなた が",
	L"えいご と にほんご の りょうほう に かんのう で",
	L"あれば 、 わたしたち の Discord サーバー で",
	L"きがる に ゲーム の ほんやく を てつだって ください 。 ",*/

	L"There actually is an english version of this\n"
	L"message even though it wouldn't make any sense\n"
	L"because this is meant to non-english players.\n"
	L"Have fun finding it though :p\n"
	L"Thanks for playing BTW and I hope\n"
	L"you have fun reading through my code! ^^", // EN (Asu-chan)

	L"Du spielst dieses Spiel auf Deutsch. Leider\n"
	L"ist dieses Spiel derzeit nur auf Englisch\n"
	L"verfügbar, aber wenn du beide Sprachen,\n"
	L"also Deutsch und Englisch, verstehen\n"
	L"kannst, dann komm und hilf uns auf unserem\n"
	L"Discord-Server das Spiel zu übersetzen:\n"
	L"https://asu-chan.github.io/discord", // GE (Vadenimo)

	L"On dirait que vous essayez de jouer en\n"
	L"français. Malheureusement, ce jeu n'existe\n"
	L"qu'en anglais pour le moment, mais si vous\n"
	L"parlez à la fois anglais et français, vous\n"
	L"pouvez venir nous aider à traduire le jeu sur\n"
	L"notre serveur discord:\n"
	L"https://asu-chan.github.io/discord", // FR (Mullkaw)

	L"Parece que estás intentando jugar este\n"
	L"juego en español. Desafortunadamente,\n"
	L"este juego sólo está disponible en inglés\n"
	L"por ahora, pero si hablas español y inglés,\n"
	L"siéntete libre de ayudarnos a traducir el\n"
	L"juego en nuestro servidor de Discord:\n"
	L"https://asu-chan.github.io/discord", // SP (Bestimum)

	L"Sembra che tu stia cercando di giocare\n"
	L"in italiano.\n"
	L"Sfortunatamente questo gioco è disponibile\n"
	L"solo in inglese al momento. Se sai tradurre\n"
	L"dall'inglese all'italiano, per favore aiutaci\n"
	L"nella traduzione tramite il server discord:\n"
	L"https://asu-chan.github.io/discord", // IT (CLF78)

	L"Het lijkt erop dat je dit spel in het\n"
	L"Nederlands speelt. Helaas is dit spel\n"
	L"vooralsnog alleen beschikbaar in het Engels,\n"
	L"maar als je zowel Nederlands als Engels\n"
	L"spreekt, kun je helpen om dit spel te vertalen\n"
	L"op onze Discord server:\n"
	L"https://asu-chan.github.io/discord", // DU (Grop)

	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"https://asu-chan.github.io/discord", // ?? (??)

	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"https://asu-chan.github.io/discord", // TW (??)

	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"???\n"
	L"https://asu-chan.github.io/discord", // KR (??)
};

extern "C" int GetGameLanguage();

int LanguageAskHandler::setup() {
	if(!layoutLoaded) {
		if (!layout.loadArc("languageAsk.arc", false))
			return false;

		static const char *brlanNames[10] = {
			"languageAsk_inWindow.brlan",
			"languageAsk_loopWindow.brlan",
			"languageAsk_inButton.brlan",
			"languageAsk_onButton.brlan",
			"languageAsk_idleButton.brlan",
			"languageAsk_hitButton.brlan",
			"languageAsk_offButton.brlan",
			"languageAsk_inBG.brlan",
			"languageAsk_outBG.brlan",
			"languageAsk_outWindow.brlan",
		};

		static const char *groupNames[10] = {
			"A00_inWindow", "A00_inWindow",
			"B02_centerButton", "B02_centerButton", "B02_centerButton", "B02_centerButton", "B02_centerButton",
			"C00_BG_00", "C00_BG_00",
			"A00_inWindow"
		};

		static const int groupIDs[10] = {
			0, 1,
			2, 3, 4, 5, 6,
			7, 8,
			9,
		};

		layout.build("languageAsk.brlyt");

		// if (IsWideScreen()) {
		// 	layout.layout.rootPane->scale.x = 0.7711f;
		// }

		layout.loadAnimations(brlanNames, 10);
		layout.loadGroups(groupNames, groupIDs, 10);
		layout.disableAllAnimations();

		layout.drawOrder = 140;

		layoutLoaded = true;


		layout.enableNonLoopAnim(0);
		PlaySoundWithFunctionB4(SoundRelatedClass, &askHandle, 0x7F, 1);

		if(!SelectCursorPointer) {
			// CreateParentedObject(0x2CF, (u32*)this, 0, 0); //SELECT_CURSOR
			Vec duh = (Vec){0, 0, 0};
			CreateActor(0x2CF, 0, duh, 0, 0);
		}

		this->somethingHasBeenDone = (bool)(IsAlternateCRSINEnabled & 0x0100);

		nw4r::lyt::TextBox *TitleText = this->layout.findTextBoxByName("T_otehonText_00");
		nw4r::lyt::TextBox *TitleTextS = this->layout.findTextBoxByName("T_otehonTextS_00");
		nw4r::lyt::TextBox *QuestionText = this->layout.findTextBoxByName("T_question_00");
		nw4r::lyt::TextBox *QuestionTextS = this->layout.findTextBoxByName("T_questionS_00");

		int language = GetGameLanguage();

		TitleText->SetString(languageAskTitles[language]);
		TitleTextS->SetString(languageAskTitles[language]);
		QuestionText->SetString(languageAskMSGs[language]);
		QuestionTextS->SetString(languageAskMSGs[language]);
	}

	isVisible = true;

	return true;
}

extern void callLanguageState(LanguageAskHandler* handler, u32 state);

int LanguageAskHandler::execute() {
	if(this->somethingHasBeenDone) {
		callLanguageState(this, currentStateID);
	}

	return true;
}

int LanguageAskHandler::draw() {
	if (isVisible) {
		layout.scheduleForDrawing();
	}
	return true;
}

int LanguageAskHandler::free() {
	this->somethingHasBeenDone = 0;
	return layout.free();
}


void LanguageAskHandler::state0_WaitForEndOfAnimOpen() {
	if (!layout.isAnimOn(0)) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(2);
		currentStateID = 1;
	}
}

void LanguageAskHandler::state1_WaitForEndOfButtonOpen() {
	if (!layout.isAnimOn(2)) {
		layout.disableAllAnimations();
		layout.enableNonLoopAnim(3);
		UpdateSelectCursor(this->layout.findPaneByName("N_buttonO_00"), 0, false);
		this->timer = 0;
		currentStateID = 2;
	}
}

void LanguageAskHandler::state2_WaitForPress() {
	if (!layout.isAnimOn(3) && !layout.isAnimOn(5)) {
		int nowPressed = Remocon_GetPressed(GetActiveRemocon());
		if(nowPressed & WPAD_TWO && !this->hasPressed) {
			layout.enableNonLoopAnim(5);
			PlaySoundWithFunctionB4(SoundRelatedClass, &askHandle, 0x79, 1);
			HideSelectCursor((void*)SelectCursorPointer, 0);
			this->hasPressed = true;
			return;
		}

		if(this->hasPressed) {
			this->timer++;
		}

		if(this->timer >= 30) {
			layout.disableAllAnimations();
			layout.enableNonLoopAnim(9);
			PlaySoundWithFunctionB4(SoundRelatedClass, &askHandle, 0x82, 1);
			currentStateID = 3;
		}
	}
}

void LanguageAskHandler::state3_WaitForEndOfWindowClose() {
	if (!layout.isAnimOn(9)) {
		this->somethingHasBeenDone = 0;
		IsAlternateCRSINEnabled = 1;
	}
}