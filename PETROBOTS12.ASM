;PETSCII Robots (PET 4032 version)
;by David Murray 2020 (last update 7-15-2022)
;dfwgreencars@gmail.com

!to "petrobots",cbm

*=$0401              ;START ADDRESS IS $0401
DESTRUCT_PATH	=$5000	;Destruct path array (256 bytes)
TILE_ATTRIB	=$5100	;Tile attrib array (256 bytes)
TILE_DATA_TL	=$5200	;Tile character top-left (256 bytes)
TILE_DATA_TM	=$5300	;Tile character top-middle (256 bytes)
TILE_DATA_TR	=$5400	;Tile character top-right (256 bytes)
TILE_DATA_ML	=$5500	;Tile character middle-left (256 bytes)
TILE_DATA_MM	=$5600	;Tile character middle-middle (256 bytes)
TILE_DATA_MR	=$5700	;Tile character middle-right (256 bytes)
TILE_DATA_BL	=$5800	;Tile character bottom-left (256 bytes)
TILE_DATA_BM	=$5900	;Tile character bottom-middle (256 bytes)
TILE_DATA_BR	=$5A00	;Tile character bottom-right (256 bytes)

;***These arrays can go anywhere in RAM***
UNIT_TIMER_A	=$5B00	;Primary timer for units (64 bytes)
UNIT_TIMER_B	=$5B40	;Secondary timer for units (64 bytes)
UNIT_TILE	=$5B80	;Current tile assigned to unit (32 bytes)
;UNIT_ALT_MOVE	=$5BA0	;For moving around objects (32 bytes)
;UNIT_DEST_X	=$5BC0	;Destination X coordinate (32 bytes)
;UNIT_DEST_Y	=$5BE0	;Destination X coordinate (32 bytes)
EXP_BUFFER	=$5C00	;Explosion Buffer (16 bytes)
MAP_PRECALC	=$5C10	;Stores pre-calculated objects for map window (77 bytes)

;The following addresses are used to store the current 
;state of the SNES buttons.
SNES_B		=$5C5D
SNES_Y		=$5C5E
SNES_SELECT	=$5C5F
SNES_START	=$5C60
SNES_UP		=$5C61
SNES_DOWN	=$5C62
SNES_LEFT	=$5C63
SNES_RIGHT	=$5C64
SNES_A		=$5C65
SNES_X		=$5C66
SNES_BACK_L	=$5C67
SNES_BACK_R	=$5C68
;The following addresses are used to store the last
;state of the SNES buttons so that we can determine
;if a button was released.
LAST_B		=$5C69
LAST_Y		=$5C6A
LAST_SELECT	=$5C6B
LAST_START	=$5C6C
LAST_UP		=$5C6D
LAST_DOWN	=$5C6E
LAST_LEFT	=$5C6F
LAST_RIGHT	=$5C70
LAST_A		=$5C71
LAST_X		=$5C72
LAST_BACK_L	=$5C73
LAST_BACK_R	=$5C74

;The following addresses are used to store new
;presses of the SNES buttons.  Once they are set
;as a 1, it requires the game to reset them to
;0 when it is ready to be read again.
NEW_B		=$5C75
NEW_Y		=$5C76
NEW_SELECT	=$5C77
NEW_START	=$5C78
NEW_UP		=$5C79
NEW_DOWN	=$5C7A
NEW_LEFT	=$5C7B
NEW_RIGHT	=$5C7C
NEW_A		=$5C7D
NEW_X		=$5C7E
NEW_BACK_L	=$5C7F
NEW_BACK_R	=$5C80

;The following are the locations where the current
;key controls are stored.  These must be set before
;the game can start.
KEY_MOVE_UP		=$5C81
KEY_MOVE_DOWN		=$5C82
KEY_MOVE_LEFT		=$5C83
KEY_MOVE_RIGHT		=$5C84
KEY_FIRE_UP		=$5C85
KEY_FIRE_DOWN		=$5C86
KEY_FIRE_LEFT		=$5C87
KEY_FIRE_RIGHT		=$5C88
KEY_CYCLE_WEAPONS	=$5C89
KEY_CYCLE_ITEMS		=$5C8A
KEY_USE			=$5C8B
KEY_SEARCH		=$5C8C
KEY_MOVE		=$5C8D

;***MAP FILES CONSIST OF EVERYTHING FROM THIS POINT ON***
UNIT_TYPE	=$5D00	;Unit type 0=none (64 bytes)	
UNIT_LOC_X	=$5D40	;Unit X location (64 bytes)
UNIT_LOC_Y	=$5D80	;Unit X location (64 bytes)
UNIT_A		=$5DC0	
UNIT_B		=$5E00
UNIT_C		=$5E40
UNIT_D		=$5E80
UNIT_HEALTH	=$5EC0	;Unit health (0 to 11) (64 bytes)
MAP		=$6000	;Location of MAP (8K)
;***END OF MAP FILE***

;*** Zero Page locations used ***
TILE		=$23	;The tile number to be plotted
TEMP_X		=$24	;Temporarily used for loops
TEMP_Y		=$25	;Temporarily used for loops
MAP_X		=$26	;Current X location on map
MAP_Y		=$27	;Current Y location on map
MAP_WINDOW_X	=$28	;Top left location of what is displayed in map window
MAP_WINDOW_Y	=$29	;Top left location of what is displayed in map window
DECNUM		=$2A	;a decimal number to be displayed onscreen as 3 digits.
ATTRIB		=$2B	;Tile attribute value
UNIT		=$2C	;Current unit being processed
TEMP_A		=$2D	;used within some routines
TEMP_B		=$2E	;used within some routines
TEMP_C		=$2F	;used within some routines
TEMP_D		=$30	;used within some routines
CURSOR_X	=$31	;For on-screen cursor
CURSOR_Y	=$32	;For on-screen cursor
CURSOR_ON	=$33	;Is cursor active or not? 1=yes 0=no
REDRAW_WINDOW	=$34	;1=yes 0=no
MOVE_RESULT	=$35	;1=Move request success, 0=fail.
UNIT_FIND	=$36	;255=no unit present.
MOVE_TYPE	=$37	;%00000001=WALK %00000010=HOVER
PRECALC_COUNT	=$39	;part of screen draw routine
CUR_PATTERN_L	=$3A	;stores the memory location of the current
CUR_PATTERN_H	=$3B	;musical pattern being played.

BASIC:	!BYTE $0B,$04,$01,$00,$9E,$31,$30,$33,$37,$00,$00,$00
	;Adds BASIC line:  1 SYS 1037
	LDA	#%00101000	;Pins 3 & 5 are output
	STA	$E843	;Data-direction-register for userport
	LDA	#12
	STA	$E84C	; Turn on upper-case+graphics character set
	LDA	#0	;RESET SOUND TO ZERO
	STA	$E84A	;RESET SOUND TO ZERO
	STA	$E848	;RESET SOUND TO ZERO
	LDA	#16	;turn on sound port
	STA	$E84B	;turn on sound port
	JSR	DETECT_ROM_VERSION
;	JSR	DISPLAY_WARNING
	JSR	$FFE4	;No idea why this is needed, but the files won't load without it.
	JSR	DISPLAY_LOAD_MESSAGE1
	JSR	TILE_LOAD_ROUTINE
	JSR	$FFE4	;No idea why this is needed, but the files won't load without it.
	JSR	SETUP_INTERRUPT
	JSR	SET_CONTROLS	;copy initial key controls
	JMP	INTRO_SCREEN
INIT_GAME:
	LDA	#0
	STA	SCREEN_SHAKE
	JSR	RESET_KEYS_AMMO
	JSR	DISPLAY_GAME_SCREEN
	JSR	DISPLAY_LOAD_MESSAGE2
	JSR	$FFE4	;No idea why this is needed, but the files won't load without it.
	JSR	MAP_LOAD_ROUTINE
	JSR	SET_DIFF_LEVEL
	JSR	ANIMATE_PLAYER
	JSR	CACULATE_AND_REDRAW
	JSR	DRAW_MAP_WINDOW
	JSR	DISPLAY_PLAYER_HEALTH
	JSR	DISPLAY_KEYS
	JSR	DISPLAY_WEAPON
	LDA	#1
	STA	UNIT_TYPE
	JSR	SET_INITIAL_TIMERS
	JSR	PRINT_INTRO_MESSAGE
	LDA	#30
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP

TILENAME  	!PET"tileset.pet"
MAPNAME  	!PET"level-a"
SNDNAME  	!PET"pdrv-pet"
LOADMSG1	!PET"loading tiles...",13
LOADMSG2	!PET 147,"loading map...",13
KEYS		!BYTE 	00	;bit0=spade bit2=heart bit3=star
AMMO_PISTOL	!BYTE	00	;how much ammo for the pistol
AMMO_PLASMA	!BYTE	00	;how many shots of the plasmagun
INV_BOMBS	!BYTE	00	;How many bombs do we have
INV_EMP		!BYTE	00	;How many EMPs do we have
INV_MEDKIT	!BYTE	00	;How many medkits do we have?
INV_MAGNET	!BYTE	00	;How many magnets do we have?
SELECTED_WEAPON	!BYTE	00	;0=none 1=pistol 2=plasmagun
SELECTED_ITEM	!BYTE	00	;0=none 1=bomb 2=emp 3=medkit 4=magnet
SELECT_TIMEOUT	!BYTE	00	;can only change weapons once it hits zero
ANIMATE		!BYTE 	01	;0=DISABLED 1=ENABLED
BIG_EXP_ACT	!BYTE	00	;0=No explosion active 1=big explosion active
MAGNET_ACT	!BYTE	00	;0=no magnet active 1=magnet active
PLASMA_ACT	!BYTE	00	;0=No plasma fire active 1=plasma fire active
RANDOM		!BYTE	00	;used for random number generation
BORDER		!BYTE 	00	;Used for border flash timing
SCREEN_SHAKE	!BYTE	00	;1=shake 0=no shake
CONTROL		!BYTE	00	;0=keyboard 1=custom keys 2=snes
BASICROM	!BYTE	04	;which ROM is detected?
INTRO_MESSAGE	!SCR"welcome to pet-robots v1.1!",255
		!SCR"by david murray 2022",255
		!SCR"map on clr/home key.",0
MSG_CANTMOVE	!SCR"can't move that!",0
MSG_BLOCKED	!SCR"blocked!",0
MSG_SEARCHING	!SCR"searching",0
MSG_NOTFOUND	!SCR"nothing found here.",0
MSG_FOUNDKEY	!SCR"you found a key card!",0
MSG_FOUNDGUN	!SCR"you found a pistol!",0
MSG_FOUNDEMP	!SCR"you found an emp device!",0
MSG_FOUNDBOMB	!SCR"you found a timebomb!",0
MSG_FOUNDPLAS	!SCR"you found a plasma gun!",0
MSG_FOUNDMED	!SCR"you found a medkit!",0
MSG_FOUNDMAG	!SCR"you found a magnet!",0
MSG_MUCHBET	!SCR"ahhh, much better!",0
MSG_EMPUSED	!SCR"emp activated!",255
		!SCR"nearby robots are rebooting.",0
MSG_TERMINATED	!SCR"you're terminated!",0
MSG_TRANS1	!SCR"transporter will not activate",255
		!SCR"until all robots destroyed.",0
MSG_ELEVATOR	!SCR"[ elevator panel ]  down",255
		!SCR"[  select level  ]  opens",0
MSG_LEVELS	!SCR"[                ]  door",0
MSG_PAUSED	!SCR"game paused.",255
		!SCR"exit game (y/n)",0
MSG_MUSICON	!SCR"music on.",0
MSG_MUSICOFF	!SCR"music off.",0
SELECTED_MAP	!BYTE	00
MAP_NAMES	!SCR"01-research lab "
		!SCR"02-headquarters "
		!SCR"03-the village  "
		!SCR"04-the islands  "
		!SCR"05-downtown     "
		!SCR"06-pi university"
		!SCR"07-more islands "
		!SCR"08-robot hotel  "
		!SCR"09-forest moon  "
		!SCR"10-death tower  "
		!SCR"11-bunker       "
		!SCR"12-castle robot "
		!SCR"13-rocket center"
		!SCR"14-pilands      "
;***THE FOLLOWING ARE USED BY THE SOUND SYSTEM***
TEMPO_TIMER	!BYTE	00	;used for counting down to the next tick
TEMPO		!BYTE	07	;How many IRQs between ticks
DATA_LINE	!BYTE	00	;used for playback to keep track of which line we are executing.
ARP_MODE	!BYTE	00	;0=no 1=major 2=minor 3=sus4
CHORD_ROOT	!BYTE	00	;root note of the chord
MUSIC_ON	!BYTE	00	;0=off 1=on
SOUND_EFFECT	!BYTE	$FF	;FF=OFF or number of effect in progress

DETECT_ROM_VERSION:
	LDA	$C353
	CMP	#160
	BEQ	DET0
	LDA	#50
	STA	DETECTMSG+9
	LDA	#2
	STA	BASICROM
	LDA	#$22
	STA	LDR1+1
	STA	LDR2+1
	;NOW DISLPAY MESSAGE
DET0:	LDY	#0
DET1:	LDA	DETECTMSG,Y
	CMP	#0
	BEQ	DET2
	JSR	$FFD2
	INY
	JMP	DET1
DET2:	RTS
DETECTMSG:	!BYTE 13,13
		!PET"basic v4 detected!",13,0

DISPLAY_LOAD_MESSAGE1:
	LDY	#0
DLM1:	LDA	LOADMSG1,Y
	JSR	$FFD2
	INY
	CPY	#17
	BNE	DLM1
	RTS

;Displays loading message for map.
DISPLAY_LOAD_MESSAGE2:
	LDY	#0
DLM2:	LDA	LOAD_MSG2,Y
	STA	$8190,Y
	INY
	CPY	#12
	BNE	DLM2
	JSR	CALC_MAP_NAME
DLM3:	LDA	($FB),Y
	STA	$819C,Y
	INY
	CPY	#16
	BNE	DLM3	
	RTS
LOAD_MSG2:	!SCR"loading map:"

SETUP_INTERRUPT:
	SEI			; Disable interrupt routine
	LDA	$0090		; get old address
	STA	IRQ31+1		
	LDA	$0091		; get old address
	STA	IRQ31+2	
	LDA	#<RUNIRQ	; Setup IRQ to visit my routine RUNIRQ before
	STA	$0090		; doing the usual IRQ routine.
	LDA	#>RUNIRQ
	STA	$0091
	CLI			; Reenable routine.
	RTS

;This is the routine that runs every 60 seconds from the IRQ.
;BGTIMER1 is always set to 1 every cycle, after which the main
;program will reset it to 0 when it is done with it's work for
;that cycle.  BGTIMER2 is a count-down to zero and then stays
;there.
RUNIRQ:
	;LDA	ARP_MODE	;ARP ROUTINE DISABLED
	;CMP	#00		;SINCE NO MUSIC IS USING IT
	;BEQ	IRQ20
	;JSR	CYCLE_ARP
IRQ20:	JSR	MUSIC_ROUTINE
	JSR	UPDATE_GAME_CLOCK
	JSR	ANIMATE_WATER
	LDA	#1
	STA	BGTIMER1
	LDA	BGTIMER2
	CMP	#0
	BEQ	IRQ1
	DEC	BGTIMER2
IRQ1:	LDA	KEYTIMER
	CMP	#0
	BEQ	IRQ30
	DEC	KEYTIMER
IRQ30:	LDA	BORDER
	CMP	#0
	BEQ	IRQ31
	DEC	BORDER
IRQ31:	JMP	$E455		; Back to usual IRQ routine
BGTIMER1	!BYTE 00
BGTIMER2	!BYTE 00
KEYTIMER	!BYTE 00	;Used for repeat of movement

;Since the PET has no real-time clock, and the Jiffy clock
;is a pain to read from assembly language, I have created my own.
UPDATE_GAME_CLOCK:
	LDA	CLOCK_ACTIVE
	CMP	#1
	BNE	UGC5
	INC	CYCLES
	LDA	CYCLES
	CMP	#50	;60 for ntsc or 50 for pal
	BNE	UGC5
	LDA	#0
	STA	CYCLES
	INC	SECONDS
	LDA	SECONDS
	CMP	#60	
	BNE	UGC5
	LDA	#0
	STA	SECONDS
	INC	MINUTES
	LDA	MINUTES
	CMP	#60	
	BNE	UGC5
	LDA	#0
	STA	SECONDS
	STA	MINUTES
	INC	HOURS
UGC5:	RTS

HOURS		!BYTE	00
MINUTES		!BYTE	00
SECONDS		!BYTE	00
CYCLES		!BYTE	00
CLOCK_ACTIVE	!BYTE	00

SNES_CONTROLER_READ:
	;First copy last time's results to the LAST variables.
	LDY	#0
SNCL:	LDA	SNES_B,Y
	STA	LAST_B,Y
	;STA	$8398,Y		;TESTCODE
	INY
	CPY	#12
	BNE	SNCL
	;now latch data
	LDA	#%00100000	;latch on pin 5
	STA	$E841	
	LDA	#%00000000
	STA	$E841	
	LDX	#0
	;Now read in bits
SRLOOP:	LDA	$E841
	AND	#%01000000	;READ pin 6
	CMP	#%01000000
	BEQ	SRL1
	LDA	#1
	JMP	SRL5
SRL1:	LDA	#0
SRL5:	STA	SNES_B,X
	;pulse the clock line
	LDA	#%00001000	;CLOCK on pin 3
	STA	$E841
	LDA	#%00000000
	STA	$E841
	INX
	CPX	#12
	BNE	SRLOOP
	;now process any new presses
	LDY	#0
SRL09:	LDA	NEW_B,Y
	CMP	#1
	BEQ	SRL10
	LDA	SNES_B,Y
	CMP	#1
	BNE	SRL10
	LDA	LAST_B,Y
	CMP	#0
	BNE	SRL10
	LDA	#1
	STA	NEW_B,Y
	;STA	$83C0,Y		;TEST CODE
SRL10:	INY
	CPY	#12
	BNE	SRL09
	RTS

;This routine clears any new-button-presses
;that are pending.
CLEAR_SNES_PAD:
	LDA	#0
	STA	NEW_UP
	STA	NEW_DOWN
	STA	NEW_LEFT
	STA	NEW_RIGHT
	STA	NEW_A
	STA	NEW_B
	STA	NEW_X
	STA	NEW_Y
	STA	NEW_BACK_L
	STA	NEW_BACK_R
	RTS

;This routine spaces out the timers so that not everything
;is running out once. It also starts the game_clock.
SET_INITIAL_TIMERS:
	LDA	#1
	STA	CLOCK_ACTIVE
	LDX	#01
SIT1	TXA
	STA	UNIT_TIMER_A,X
	LDA	#0
	STA	UNIT_TIMER_B,X
	INX	
	CPX	#48
	BNE	SIT1
	RTS

MAIN_GAME_LOOP:
MG0A:	JSR	PET_SCREEN_SHAKE
	JSR	BACKGROUND_TASKS
	LDA	UNIT_TYPE
	CMP	#1	;Is player unit alive
	BEQ	MG00
	JMP	GAME_OVER
MG00:	LDA	CONTROL
	CMP	#2
	BNE	KY01
	JMP	SC01
KY01:	;Keyboard controls here.
	JSR	KEY_REPEAT
	JSR	$FFE4
	CMP	#$00
	BEQ	MAIN_GAME_LOOP	
	LDX	#5
	STX	KEYTIMER
MG01:	CMP	#$1D	;CURSOR RIGHT
	BNE	MG02
MG01A:	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_RIGHT
	JMP	AFTER_MOVE
MG02:	CMP	#$9D	;CURSOR LEFT
	BNE	MG03
MG02A:	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_LEFT
	JMP	AFTER_MOVE
MG03:	CMP	#$11	;CURSOR DOWN
	BNE	MG04
MG03A:	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_DOWN
	JMP	AFTER_MOVE
MG04:	CMP	#$91	;CURSOR UP
	BNE	MG05
MG04A:	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_UP
	JMP	AFTER_MOVE
MG05:	CMP	KEY_CYCLE_WEAPONS
	BNE	MG06
	JSR	CYCLE_WEAPON
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG06:	CMP	KEY_CYCLE_ITEMS
	BNE	MG07
	JSR	CYCLE_ITEM
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG07:	CMP	KEY_MOVE
	BNE	MG08
	JSR	MOVE_OBJECT
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP	
MG08:	CMP	KEY_SEARCH
	BNE	MG09
	JSR	SEARCH_OBJECT
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG09:	CMP	KEY_USE
	BNE	MG10
	JSR	USE_ITEM
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG10:	CMP	KEY_MOVE_LEFT
	BNE	MG11
	JMP	MG02A	
MG11:	CMP	KEY_MOVE_DOWN
	BNE	MG12
	JMP	MG03A
MG12:	CMP	KEY_MOVE_RIGHT
	BNE	MG13
	JMP	MG01A
MG13:	CMP	KEY_MOVE_UP
	BNE	MG14
	JMP	MG04A
MG14:	CMP	KEY_FIRE_UP
	BNE	MG15
	JSR	FIRE_UP
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG15:	CMP	KEY_FIRE_LEFT
	BNE	MG16
	JSR	FIRE_LEFT
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG16:	CMP	KEY_FIRE_DOWN
	BNE	MG17
	JSR	FIRE_DOWN
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG17:	CMP	KEY_FIRE_RIGHT
	BNE	MG18
	JSR	FIRE_RIGHT
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG18:	CMP	#03	;RUN/STOP
	BNE	MG19
	JMP	PAUSE_GAME
MG19:	CMP	#195	;SHIFT-C
	BNE	MG20
	JSR	CHEATER
	JMP	MAIN_GAME_LOOP
MG20:	CMP	#205	;SHIFT-M
	BNE	MG21
	JSR	TOGGLE_MUSIC
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG21:	CMP	#19	;HOME
	BNE	MG22
	JSR	DISPLAY_MAP	
MG22:	JMP	MAIN_GAME_LOOP

SC01:	;SNES CONTROLLER starts here
	JSR	SNES_CONTROLER_READ
	;check keytimer for repeat time.
	LDA	KEYTIMER
	CMP	#0
	BEQ	SC02
	JMP	SC40
SC02:	LDA	#0
	STA	NEW_UP
	STA	NEW_DOWN
	STA	NEW_LEFT
	STA	NEW_RIGHT
	STA	SNES_UP
	STA	SNES_DOWN
	STA	SNES_LEFT
	STA	SNES_RIGHT
	JSR	SNES_CONTROLER_READ
SC05:	;first we start with the 4 directional buttons.
	LDA	NEW_LEFT
	CMP	#01
	BNE	SC10
	LDA	SNES_SELECT	;find out if select is being held down
	CMP	#0
	BEQ	SC06
	LDA	#0
	STA	NEW_LEFT
	JSR	DISPLAY_MAP
	JMP	MAIN_GAME_LOOP
SC06:	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_LEFT
	JMP	AFTER_MOVE_SNES	
SC10:	LDA	NEW_RIGHT
	CMP	#01
	BNE	SC20
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_RIGHT
	JMP	AFTER_MOVE_SNES
SC20:	LDA	NEW_UP
	CMP	#01
	BNE	SC30
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_UP
	JMP	AFTER_MOVE_SNES
SC30:	LDA	NEW_DOWN
	CMP	#01
	BNE	SC35
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_DOWN
	JMP	AFTER_MOVE_SNES
SC35:	LDA	#0
	STA	KEY_FAST
SC40:	;Now check for non-repeating buttons
	LDA	NEW_Y
	CMP	#1
	BNE	SC45
	JSR	FIRE_LEFT
	LDA	#0
	STA	NEW_Y
SC45:	LDA	NEW_A
	CMP	#1
	BNE	SC50
	JSR	FIRE_RIGHT
	LDA	#0
	STA	NEW_A
SC50:	LDA	NEW_X
	CMP	#1
	BNE	SC55
	JSR	FIRE_UP
	LDA	#0
	STA	NEW_X
SC55:	LDA	NEW_B
	CMP	#1
	BNE	SC60
	JSR	FIRE_DOWN
	LDA	#0
	STA	NEW_B
SC60:	LDA	NEW_BACK_L
	CMP	#1
	BNE	SC65
	LDA	SNES_SELECT
	CMP	#1
	BNE	SC62
	JSR	CYCLE_ITEM
	JMP	SC63
SC62:	JSR	SEARCH_OBJECT
SC63:	LDA	#0
	STA	NEW_BACK_L
	LDA	#15
	STA	KEYTIMER
SC65:	LDA	NEW_BACK_R
	CMP	#1
	BNE	SC70
	LDA	SNES_SELECT
	CMP	#1
	BNE	SC67
	JSR	CYCLE_WEAPON
	JMP	SC68
SC67:	JSR	MOVE_OBJECT
SC68:	LDA	#0
	STA	NEW_BACK_R
	LDA	#15
	STA	KEYTIMER
SC70:	LDA	NEW_START
	CMP	#1
	BNE	SC75
	JSR	USE_ITEM
	LDA	#0
	STA	NEW_START
	LDA	#15
	STA	KEYTIMER
SC75:	;STILL USE KEYBOARD TO CHECK FOR RUN/STOP AND OTHERS
	JSR	$FFE4
	CMP	#03	;RUN/STOP
	BNE	SC80
	JMP	PAUSE_GAME
SC80:	CMP	#205	;SHIFT-M
	BNE	SC81
	JSR	TOGGLE_MUSIC
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
SC81:	CMP	#19	;HOME
	BNE	SC82
	JSR	DISPLAY_MAP
SC82:	JMP	MAIN_GAME_LOOP


;This routine handles things that are in common to
;all 4 directions of movement.
AFTER_MOVE_SNES:
	LDA	MOVE_RESULT
	CMP	#1
	BNE	AMS01
	JSR	ANIMATE_PLAYER
	JSR	CACULATE_AND_REDRAW
AMS01:	LDA	KEY_FAST
	CMP	#0
	BNE	AMS02
	LDA	#15
	STA	KEYTIMER
	LDA	#1
	STA	KEY_FAST
	JMP	AMS03
AMS02:	LDA	#6
	STA	KEYTIMER
	LDA	#0
	STA	NEW_UP
	STA	NEW_DOWN
	STA	NEW_LEFT
	STA	NEW_RIGHT
AMS03:	JMP	MAIN_GAME_LOOP

TOGGLE_MUSIC:
	LDA	MUSIC_ON
	CMP	#1
	BNE	TGMUS1
	LDA	#<MSG_MUSICOFF
	STA	$FB
	LDA	#>MSG_MUSICOFF
	STA	$FC
	JSR	PRINT_INFO
	LDA	#0
	STA	MUSIC_ON
	STA	$E848	;turn off sound
	STA	$E84A	;turn off sound
	RTS
TGMUS1:	LDA	#<MSG_MUSICON
	STA	$FB
	LDA	#>MSG_MUSICON
	STA	$FC
	JSR	PRINT_INFO
	LDA	#1
	STA	MUSIC_ON
	JSR	START_IN_GAME_MUSIC
	RTS

START_IN_GAME_MUSIC:
	LDA	#1
	STA	MUSIC_ON
	LDA	SOUND_EFFECT
	CMP	#$FF	;FF=NO sound effect in progress
	BNE	SIGM1
	LDA	#0
	STA	DATA_LINE
	LDA	#<IN_GAME_MUSIC1
	STA	CUR_PATTERN_L
	LDA	#>IN_GAME_MUSIC1
	CLC
	LDY	SELECTED_MAP
	ADC	LEVEL_MUSIC,Y
	STA	CUR_PATTERN_H
	RTS
SIGM1:	;apparently a sound-effect is active, so we do things differently.
	LDA	#0
	STA	DATA_LINE_TEMP
	LDA	#<IN_GAME_MUSIC1	
	STA	PATTERN_L_TEMP	
	LDA	#>IN_GAME_MUSIC1
	CLC
	LDY	SELECTED_MAP
	ADC	LEVEL_MUSIC,Y
	STA	PATTERN_H_TEMP	
	LDA	#0
	STA	DATA_LINE_TEMP
	RTS
LEVEL_MUSIC:	!BYTE 0,1,2,0,1,2,0,1,2,0,1,2,0,1

;TEMP ROUTINE TO GIVE ME ALL ITEMS AND WEAPONS
CHEATER:
	LDA	#7
	STA	KEYS			
	LDA	#100
	STA	AMMO_PISTOL	
	STA	AMMO_PLASMA	
	STA	INV_BOMBS	
	STA	INV_EMP		
	STA	INV_MEDKIT	
	STA	INV_MAGNET
	LDA	#1	
	STA	SELECTED_WEAPON		
	STA	SELECTED_ITEM	
	JSR	DISPLAY_KEYS
	JSR	DISPLAY_WEAPON
	JSR	DISPLAY_ITEM	
	RTS
PAUSE_GAME:
	LDA	#15
	JSR	PLAY_SOUND
	;pause clock
	LDA	#0
	STA	CLOCK_ACTIVE
	;display message to user
	JSR	SCROLL_INFO
	LDA	#<MSG_PAUSED
	STA	$FB
	LDA	#>MSG_PAUSED
	STA	$FC
	JSR	PRINT_INFO
	LDA	#0
	STA	BGTIMER1
PG0:	LDA	BGTIMER1	;to prevent double-tap of run/stop
	CMP	#1
	BNE	PG0
	JSR	CLEAR_KEY_BUFFER
PG1:	JSR	$FFE4
	CMP	#$00
	BEQ	PG1
	CMP	#03	;RUN/STOP
	BEQ	PG5
	CMP	#78	;N-KEY
	BEQ	PG5	
	CMP	#89	;Y-KEY
	BEQ	PG6
	JMP	PG1
PG5:	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	CLEAR_KEY_BUFFER
	LDA	#1
	STA	CLOCK_ACTIVE
	LDA	#15
	JSR	PLAY_SOUND
	JMP	MAIN_GAME_LOOP
PG6:	LDA	#0
	STA	UNIT_TYPE	;make player dead
	LDA	#15
	JSR	PLAY_SOUND
	JMP	GOM4

CLEAR_KEY_BUFFER:
	LDA	#0
	STA	$009E	;CLEAR KEYBOARD BUFFER
	LDA	#20
	STA	KEYTIMER
	RTS

USE_ITEM:
	;check select timeout to prevent accidental double-tap
	LDA	SELECT_TIMEOUT
	CMP	#0
	BEQ	UI01
	RTS
	;First figure out which item to use.
UI01:	LDA	SELECTED_ITEM
	CMP	#1	;BOMB
	BNE	UI02
	JMP	USE_BOMB
UI02:	CMP	#2	;EMP
	BNE	UI03	
	JMP	USE_EMP
UI03:	CMP	#3	;MEDKIT
	BNE	UI04
	JMP	USE_MEDKIT
UI04:	CMP	#4	;MAGNET
	BNE	UI05
	JMP	USE_MAGNET
UI05:	RTS

USE_BOMB:
	JSR	USER_SELECT_OBJECT
	;NOW TEST TO SEE IF THAT SPOT IS OPEN
	JSR	BOMB_MAGNET_COMMON1
	BEQ	BM30	
	JMP	BM3A				;If not, then exit routine.
BM30:	;Now scan for any units at that location:
	JSR	CHECK_FOR_UNIT
	LDA	UNIT_FIND
	CMP	#255			;255 means no unit found.
	BEQ	BM31
BM3A:	JMP	BOMB_MAGNET_COMMON2
BM31:	LDX	#28	;Start of weapons units
BOMB1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	BOMB2
	INX
	CPX	#32
	BNE	BOMB1
	RTS	;no slots available right now, abort.
BOMB2:	LDA	#6	;bomb AI
	STA	UNIT_TYPE,X
	LDA	#130	;bomb tile
	STA	UNIT_TILE,X
	LDA	MAP_X
	STA	UNIT_LOC_X,X
	LDA	MAP_Y
	STA	UNIT_LOC_Y,X
	LDA	#100		;How long until exposion?
	STA	UNIT_TIMER_A,X
	LDA	#0
	STA	UNIT_A,X
	DEC	INV_BOMBS
	JSR	DISPLAY_ITEM
	LDA	#01
	STA	REDRAW_WINDOW
	LDA	#3	;3 cycles before next item can be used
	STA	SELECT_TIMEOUT ;pet version only
	LDA	#06		;move sound
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS

USE_MAGNET:
	LDA	MAGNET_ACT	;only one magnet active at a time.
	CMP	#0
	BEQ	MG32
	RTS
MG32:	JSR	USER_SELECT_OBJECT
	;NOW TEST TO SEE IF THAT SPOT IS OPEN
	JSR	BOMB_MAGNET_COMMON1
	BEQ	MG31	
	JMP	BOMB_MAGNET_COMMON2
MG31:	LDX	#28	;Start of weapons units
MAG1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	MAG2
	INX
	CPX	#32
	BNE	MAG1
	RTS	;no slots available right now, abort.
MAG2:	LDA	#20	;MAGNET AI
	STA	UNIT_TYPE,X
	LDA	#134	;MAGNET tile
	STA	UNIT_TILE,X
	LDA	MAP_X
	STA	UNIT_LOC_X,X
	LDA	MAP_Y
	STA	UNIT_LOC_Y,X
	LDA	#1		;How long until ACTIVATION
	STA	UNIT_TIMER_A,X
	LDA	#255		;how long does it live -A
	STA	UNIT_TIMER_B,X
	LDA	#3		;how long does it live -B
	STA	UNIT_A,X
	LDA	#1
	STA	MAGNET_ACT	;only one magnet allowed at a time.
	DEC	INV_MAGNET
	JSR	DISPLAY_ITEM
	LDA	#01
	STA	REDRAW_WINDOW
	LDA	#06		;move sound
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS

BOMB_MAGNET_COMMON1:
	LDA	#0
	STA	CURSOR_ON
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	LDA	CURSOR_X
	CLC
	ADC	MAP_WINDOW_X
	STA	MAP_X
	STA	MOVTEMP_UX
	LDA	CURSOR_Y
	CLC
	ADC	MAP_WINDOW_Y
	STA	MAP_Y
	STA	MOVTEMP_UY
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	TAY
	LDA	TILE_ATTRIB,Y
	AND	#%00000001		;is that spot available	
	CMP	#%00000001		;for something to move onto it?
	RTS

BOMB_MAGNET_COMMON2:
	LDA	#<MSG_BLOCKED
	STA	$FB
	LDA	#>MSG_BLOCKED
	STA	$FC
	JSR	PRINT_INFO
	LDA	#11		;ERROR SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS	

USE_EMP:
	JSR	EMP_FLASH
	LDA	#0
	STA	REDRAW_WINDOW	;attempt to delay window redrawing (pet only)
	LDA	#3		;EMP sound
	JSR	PLAY_SOUND	;SOUND PLAY
	DEC	INV_EMP
	JSR	DISPLAY_ITEM
	LDX	#1	;start with unit#1 (skip player)
EMP1:	;CHECK THAT UNIT EXISTS
	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	EMP5
	;CHECK HORIZONTAL POSITION
	LDA	UNIT_LOC_X,X
	CMP	MAP_WINDOW_X
	BCC	EMP5
	LDA	MAP_WINDOW_X
	CLC
	ADC	#10
	CMP	UNIT_LOC_X,X
	BCC	EMP5
	;NOW CHECK VERTICAL
	LDA	UNIT_LOC_Y,X
	CMP	MAP_WINDOW_Y
	BCC	EMP5
	LDA	MAP_WINDOW_Y
	CLC
	ADC	#6
	CMP	UNIT_LOC_Y,X
	BCC	EMP5
	LDA	#255
	STA	UNIT_TIMER_A,X
	;test to see if unit is above water
	LDA	UNIT_LOC_X,X
	STA	MAP_X
	LDA	UNIT_LOC_Y,X
	STA	MAP_Y
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	CMP	#204	;WATER
	BNE	EMP5
	LDA	#5
	STA	UNIT_TYPE,X
	STA	UNIT_TIMER_A,X
	LDA	#60	;how long to show sparks.
	STA	UNIT_A,X
	LDA	#140	;Electrocuting tile
	STA	UNIT_TILE,X
EMP5:	INX	
	CPX	#28
	BNE	EMP1
	LDA	#<MSG_EMPUSED
	STA	$FB
	LDA	#>MSG_EMPUSED
	STA	$FC
	JSR	PRINT_INFO
	LDA	#3	;3 cycles before next item can be used
	STA	SELECT_TIMEOUT
	RTS

USE_MEDKIT:
	LDA	UNIT_HEALTH
	CMP	#12	;Do we even need the medkit?
	BNE	UMK1
	RTS
UMK1:	;Now figure out how many HP we need to be healthy.
	LDA	#12
	SEC
	SBC	UNIT_HEALTH
	STA	TEMP_A		;how many we need.
	LDA	INV_MEDKIT	;how many do we have?
	SEC
	SBC	TEMP_A
	BCC	UMK2
	;we had more than we need, so go to full health.
	LDA	#12
	STA	UNIT_HEALTH
	LDA	INV_MEDKIT
	SEC
	SBC	TEMP_A
	STA	INV_MEDKIT
	JMP	UMK3
UMK2:	;we had less than we need, so we'll use what is available.
	LDA	INV_MEDKIT
	CLC
	ADC	UNIT_HEALTH
	STA	UNIT_HEALTH
	LDA	#0
	STA	INV_MEDKIT
UMK3:	JSR	DISPLAY_PLAYER_HEALTH
	JSR	DISPLAY_ITEM
	LDA	#2		;MEDKIT SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	LDA	#<MSG_MUCHBET
	STA	$FB
	LDA	#>MSG_MUCHBET
	STA	$FC
	JSR	PRINT_INFO
	RTS

FIRE_UP:
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRU0
	RTS
FRU0:	CMP	#1
	BNE	FRU1
	JMP	FIRE_UP_PISTOL
FRU1:	JMP	FIRE_UP_PLASMA

FIRE_UP_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FU00
	RTS
FU00:	LDX	#28
FU01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FU02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FU01
	RTS
FU02:	LDA	#12	;Fire pistol up AI routine
	STA	UNIT_TYPE,X
	LDA	#244	;tile for vertical weapons fire
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE	

FIRE_UP_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FUP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FUP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FUP0
FUP3:	RTS
FUP0:	LDX	#28
FUP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FUP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FUP1
	RTS
FUP2:	LDA	#12	;Fire pistol up AI routine
	STA	UNIT_TYPE,X
	LDA	#240	;tile for vertical plasma bolt
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

FIRE_DOWN:
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRD0
	RTS
FRD0:	CMP	#1
	BNE	FRD1
	JMP	FIRE_DOWN_PISTOL
FRD1:	JMP	FIRE_DOWN_PLASMA

FIRE_DOWN_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FD00
	RTS
FD00:	LDX	#28
FD01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FD02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FD01
	RTS	
FD02:	LDA	#13	;Fire pistol DOWN AI routine
	STA	UNIT_TYPE,X
	LDA	#244	;tile for vertical weapons fire
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_DOWN_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FDP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FDP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FDP0
FDP3:	RTS
FDP0:	LDX	#28
FDP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FDP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FDP1
	RTS	
FDP2:	LDA	#13	;Fire pistol DOWN AI routine
	STA	UNIT_TYPE,X
	LDA	#240	;tile for vertical weapons fire
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

FIRE_LEFT:
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRL0
	RTS
FRL0:	CMP	#1
	BNE	FRL1
	JMP	FIRE_LEFT_PISTOL
FRL1:	JMP	FIRE_LEFT_PLASMA

FIRE_LEFT_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FL00
	RTS
FL00:	LDX	#28
FL01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FL02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FL01
	RTS	
FL02:	LDA	#14	;Fire pistol LEFT AI routine
	STA	UNIT_TYPE,X
	LDA	#245	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_LEFT_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FLP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FLP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FLP0
FLP3:	RTS
FLP0:	LDX	#28
FLP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FLP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FLP1
	RTS	
FLP2:	LDA	#14	;Fire pistol LEFT AI routine
	STA	UNIT_TYPE,X
	LDA	#241	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

FIRE_RIGHT:
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRR0
	RTS
FRR0:	CMP	#1
	BNE	FRR1
	JMP	FIRE_RIGHT_PISTOL
FRR1:	JMP	FIRE_RIGHT_PLASMA
	
FIRE_RIGHT_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FR00
	RTS
FR00:	LDX	#28
FR01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FR02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FR01
	RTS	
FR02:	LDA	#15	;Fire pistol RIGHT AI routine
	STA	UNIT_TYPE,X
	LDA	#245	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_RIGHT_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FRP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FRP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FRP0
FRP3:	RTS
FRP0:	LDX	#28
FRP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FRP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FRP1
	RTS	
FRP2:	LDA	#15	;Fire pistol RIGHT AI routine
	STA	UNIT_TYPE,X
	LDA	#241	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

AFTER_FIRE:
	LDA	#0
	STA	UNIT_TIMER_A,X
	LDA	UNIT_LOC_X
	STA	UNIT_LOC_X,X
	LDA	UNIT_LOC_Y
	STA	UNIT_LOC_Y,X
	STX	UNIT
	LDA	SELECTED_WEAPON
	CMP	#2
	BEQ	AF01
	LDA	#09		;PISTOL-SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	DEC	AMMO_PISTOL
	JSR	DISPLAY_WEAPON
	RTS
AF01:	LDA	#08		;PLASMA-GUN-SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	DEC	AMMO_PLASMA
	JSR	DISPLAY_WEAPON
	RTS

;This routine checks KEYTIMER to see if it has
;reached zero yet.  If so, it clears the LSTX
;variable used by the kernal, so that it will
;register a new keypress.

KEY_REPEAT:
	LDA	KEYTIMER
	CMP	#0
	BNE	KEYR2
	LDA	$97
	CMP	#255	;no key pressed
	BEQ	KEYR1
	LDA	#255	;clear LSTX register
	STA	$97	;clear LSTX register
	LDA	#6
	STA	KEYTIMER
	RTS
KEYR1:	;No key pressed, reset all to defaults
	LDA	#0	
	STA	KEY_FAST
	LDA	#6
	STA	KEYTIMER
KEYR2:	RTS

;This routine handles things that are in common to
;all 4 directions of movement.
AFTER_MOVE:
	LDA	MOVE_RESULT
	CMP	#1
	BNE	AM01
	JSR	ANIMATE_PLAYER
	JSR	CACULATE_AND_REDRAW
AM01:	;now reset key-repeat rate
	LDA	KEY_FAST
	CMP	#0
	BNE	KEYR3
	;FIRST REPEAT
	LDA	#13
	STA	KEYTIMER
	INC	KEY_FAST
KEYR4:	JMP	MAIN_GAME_LOOP
KEYR3:	;SUBSEQUENT REPEATS
	LDA	#6
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
KEY_FAST	!BYTE	0	;0=DEFAULT STATE

;This routine is invoked when the user presses S to search
;an object such as a crate, chair, or plant.
SEARCH_OBJECT:
	JSR	USER_SELECT_OBJECT
	LDA	#1
	STA	REDRAW_WINDOW
CHS1:	;first check of object is searchable
	JSR	CALC_COORDINATES
	JSR	GET_TILE_FROM_MAP
	LDX	TILE
	LDA	TILE_ATTRIB,X
	AND	#%01000000	;can search attribute
	CMP	#%01000000
	BEQ	CHS2
	LDA	#0
	STA	CURSOR_ON
	JMP	CHS3
CHS2:	;is the tile a crate?
	LDX	TILE
	CPX	#041	;BIG CRATE
	BEQ	CHS2B
	CPX	#045	;small CRATE
	BEQ	CHS2B
	CPX	#199	;"Pi" CRATE
	BEQ	CHS2B
	JMP	CHS2C
CHS2B:	LDA	DESTRUCT_PATH,X
	STA	TILE
	JSR	PLOT_TILE_TO_MAP
CHS2C	;Now check if there is an object there.
	LDA	#0
	STA	SEARCHBAR
	LDA	#<MSG_SEARCHING
	STA	$FB
	LDA	#>MSG_SEARCHING
	STA	$FC
	JSR	PRINT_INFO
SOBJ1:	LDA	#18	;delay time between search periods
	STA	BGTIMER2
SOBJ2:	JSR	PET_SCREEN_SHAKE
	JSR	BACKGROUND_TASKS
	LDA	BGTIMER2
	CMP	#0
	BNE	SOBJ2
	LDX	SEARCHBAR
	LDA	#46	;PERIOD
	STA	$83C9,X
	INC	SEARCHBAR
	LDA	SEARCHBAR
	CMP	#8
	BNE	SOBJ1
	LDA	#0
	STA	CURSOR_ON
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	JSR	CALC_COORDINATES
	JSR	CHECK_FOR_HIDDEN_UNIT
	LDA	UNIT_FIND
	CMP	#255
	BNE	SOBJ5
CHS3:	LDA	#<MSG_NOTFOUND
	STA	$FB
	LDA	#>MSG_NOTFOUND
	STA	$FC
	JSR	PRINT_INFO
	RTS
SOBJ5:	LDX	UNIT_FIND
	LDA	UNIT_TYPE,X
	STA	TEMP_A		;store object type
	LDA	UNIT_A,X
	STA	TEMP_B		;store secondary info
	LDA	#0	;DELETE ITEM ONCE FOUND
	STA	UNIT_TYPE,X
	;***NOW PROCESS THE ITEM FOUND***
	LDA	#10		;ITEM-FOUND-SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	LDA	TEMP_A
	CMP	#128	;key
	BEQ	SOBJ10
	JMP	SOBJ15
SOBJ10:	LDA	TEMP_B		;WHICH SORT OF KEY?
	CMP	#00
	BNE	SOBJK1
	LDA	KEYS
	ORA	#%00000001	;Add spade key
	STA	KEYS
	JMP	SOBJ12
SOBJK1:	CMP	#01
	BNE	SOBJK2
	LDA	KEYS
	ORA	#%00000010	;Add heart key
	STA	KEYS
	JMP	SOBJ12
SOBJK2:	LDA	KEYS
	ORA	#%00000100	;Add star key
	STA	KEYS
SOBJ12:	LDA	#<MSG_FOUNDKEY
	STA	$FB
	LDA	#>MSG_FOUNDKEY
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_KEYS
	RTS
SOBJ15:	CMP	#129	;TIME BOMB
	BNE	SOBJ17
	LDA	TEMP_B
	CLC
	ADC	INV_BOMBS
	STA	INV_BOMBS
	LDA	#<MSG_FOUNDBOMB
	STA	$FB
	LDA	#>MSG_FOUNDBOMB
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
	RTS	
SOBJ17:	CMP	#130	;EMP	
	BNE	SOBJ20
	LDA	TEMP_B
	CLC
	ADC	INV_EMP
	STA	INV_EMP
	LDA	#<MSG_FOUNDEMP
	STA	$FB
	LDA	#>MSG_FOUNDEMP
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
	RTS	
SOBJ20:	CMP	#131	;PISTOL
	BNE	SOBJ21
	LDA	TEMP_B
	CLC
	ADC	AMMO_PISTOL
	STA	AMMO_PISTOL
	BCC	SOBJ2A	;If we rolled over past 255
	LDA	#255	;set it to 255.
	STA	AMMO_PISTOL
SOBJ2A:	LDA	#<MSG_FOUNDGUN
	STA	$FB
	LDA	#>MSG_FOUNDGUN
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_WEAPON	
SOBJ21:	CMP	#132	;PLASMA GUN
	BNE	SOBJ22
	LDA	TEMP_B
	CLC
	ADC	AMMO_PLASMA
	STA	AMMO_PLASMA
	LDA	#<MSG_FOUNDPLAS
	STA	$FB
	LDA	#>MSG_FOUNDPLAS
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_WEAPON
SOBJ22:	CMP	#133	;MEDKIT
	BNE	SOBJ23
	LDA	TEMP_B
	CLC
	ADC	INV_MEDKIT
	STA	INV_MEDKIT
	LDA	#<MSG_FOUNDMED
	STA	$FB
	LDA	#>MSG_FOUNDMED
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
SOBJ23:	CMP	#134	;MAGNET
	BNE	SOBJ99
	LDA	TEMP_B
	CLC
	ADC	INV_MAGNET
	STA	INV_MAGNET
	LDA	#<MSG_FOUNDMAG
	STA	$FB
	LDA	#>MSG_FOUNDMAG
	STA	$FC
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
SOBJ99:	;ADD CODE HERE FOR OTHER OBJECT TYPES
	RTS
SEARCHBAR	!BYTE 00	;to count how many periods to display.

;combines cursor location with window location
;to determine coordinates for MAP_X and MAP_Y
CALC_COORDINATES:
	LDA	CURSOR_X
	CLC
	ADC	MAP_WINDOW_X
	STA	MAP_X
	LDA	CURSOR_Y
	CLC
	ADC	MAP_WINDOW_Y
	STA	MAP_Y
	RTS

;This routine is called by routines such as the move, search,
;or use commands.  It displays a cursor and allows the user
;to pick a direction of an object.
USER_SELECT_OBJECT:
	LDA	#16		;beep sound
	JSR	PLAY_SOUND	;SOUND PLAY
	LDA	#5
	STA	CURSOR_X
	LDA	#3
	STA	CURSOR_Y
	LDA	#1
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	;First ask user which object to move
MV01:	JSR	PET_SCREEN_SHAKE
	JSR	BACKGROUND_TASKS
	LDA	UNIT_TYPE
	CMP	#0	;Did player die wile moving something?
	BNE	MVCONT
	LDA	#0
	STA	CURSOR_ON
	RTS
MVCONT:	LDA	CONTROL
	CMP	#2
	BNE	MV01A
	JMP	MVSNES
MV01A:	JSR	$FFE4
	CMP	#$00
	BEQ	MV02
MV02:	CMP	#$1D	;CURSOR RIGHT
	BNE	MV03
	INC	CURSOR_X
	RTS
MV03:	CMP	#$9D	;CURSOR LEFT
	BNE	MV04
	DEC	CURSOR_X
	RTS	
MV04:	CMP	#$11	;CURSOR DOWN
	BNE	MV05
	INC	CURSOR_Y
	RTS
MV05:	CMP	#$91	;CURSOR UP
	BNE	MV06
	DEC	CURSOR_Y
	RTS
MV06:	CMP	KEY_MOVE_LEFT
	BNE	MV07
	DEC	CURSOR_X
	RTS	
MV07:	CMP	KEY_MOVE_DOWN
	BNE	MV08
	INC	CURSOR_Y
	RTS
MV08:	CMP	KEY_MOVE_RIGHT
	BNE	MV09
	INC	CURSOR_X
	RTS
MV09:	CMP	KEY_MOVE_UP
	BNE	MV0A
	DEC	CURSOR_Y
	RTS
MV0A:	JMP	MV01

MVSNES:	;SNES controls for this routine
	JSR	SNES_CONTROLER_READ
	LDA	NEW_RIGHT
	CMP	#1
	BNE	MVS03
	INC	CURSOR_X
	LDA	#0
	STA	NEW_RIGHT
	RTS
MVS03:	LDA	NEW_LEFT
	CMP	#1
	BNE	MVS04
	DEC	CURSOR_X
	LDA	#0
	STA	NEW_LEFT
	RTS	
MVS04:	LDA	NEW_DOWN
	CMP	#1
	BNE	MVS05
	INC	CURSOR_Y
	LDA	#0
	STA	NEW_DOWN
	RTS
MVS05:	LDA	NEW_UP
	CMP	#1
	BNE	MVS06
	DEC	CURSOR_Y
	LDA	#0
	STA	NEW_UP
	RTS
MVS06:	JMP	MV01
	
MOVE_OBJECT:
	JSR	USER_SELECT_OBJECT
	LDA	UNIT
	;now test that object to see if it
	;is allowed to be moved.
MV10:	LDA	#0
	STA	CURSOR_ON
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	JSR	CALC_COORDINATES
	JSR	CHECK_FOR_HIDDEN_UNIT
	LDA	UNIT_FIND
	STA	MOVTEMP_U
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	TAY
	LDA	TILE_ATTRIB,Y
	AND	#%00000100		;can it be moved?	
	CMP	#%00000100		
	BEQ	MV11
	LDA	#<MSG_CANTMOVE
	STA	$FB
	LDA	#>MSG_CANTMOVE
	STA	$FC
	JSR	PRINT_INFO
	LDA	#11		;ERROR SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS
MV11:	LDA	TILE
	STA	MOVTEMP_O	;Store which tile it is we are moving
	LDA	MAP_X
	STA	MOVTEMP_X	;Store original location of object
	LDA	MAP_Y
	STA	MOVTEMP_Y
	LDA	#1
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	;NOW ASK THE USER WHICH DIRECTION TO MOVE IT TO
MV15:	JSR	PET_SCREEN_SHAKE
	JSR	BACKGROUND_TASKS
	LDA	UNIT_TYPE
	CMP	#0	;Did player die wile moving something?
	BNE	MVCONT2
	LDA	#0
	STA	CURSOR_ON
	RTS	
MVCONT2:	;which controller are we using?
	LDA	CONTROL
	CMP	#2
	BNE	MV15B
	JMP	SMV30
MV15B:	;keyboard control
	JSR	$FFE4
	CMP	#$00
	BEQ	MV15
MV16:	CMP	#$1D	;CURSOR RIGHT
	BNE	MV17
	INC	CURSOR_X
	JMP	MV25
MV17:	CMP	#$9D	;CURSOR LEFT
	BNE	MV18
	DEC	CURSOR_X
	JMP	MV25	
MV18:	CMP	#$11	;CURSOR DOWN
	BNE	MV19
	INC	CURSOR_Y
	JMP	MV25
MV19:	CMP	#$91	;CURSOR UP
	BNE	MV20
	DEC	CURSOR_Y
	JMP	MV25
MV20:	CMP	KEY_MOVE_LEFT
	BNE	MV2A
	DEC	CURSOR_X
	JMP	MV25
MV2A:	CMP	KEY_MOVE_DOWN
	BNE	MV2B
	INC	CURSOR_Y
	JMP	MV25
MV2B:	CMP	KEY_MOVE_RIGHT
	BNE	MV2C
	INC	CURSOR_X
	JMP	MV25
MV2C:	CMP	KEY_MOVE_UP
	BNE	MV2D
	DEC	CURSOR_Y
	JMP	MV25
MV2D:	JMP	MV15	
SMV30:	;SNES controls
	JSR	SNES_CONTROLER_READ
	LDA	NEW_RIGHT
	CMP	#1
	BNE	SMV31
	INC	CURSOR_X
	LDA	#0
	STA	NEW_RIGHT
	JMP	MV25
SMV31:	LDA	NEW_LEFT
	CMP	#1
	BNE	SMV32
	DEC	CURSOR_X
	LDA	#0
	STA	NEW_LEFT
	JMP	MV25	
SMV32:	LDA	NEW_DOWN
	CMP	#1
	BNE	SMV33
	INC	CURSOR_Y
	LDA	#0
	STA	NEW_DOWN
	JMP	MV25
SMV33:	LDA	NEW_UP
	CMP	#1
	BNE	SMV34
	DEC	CURSOR_Y
	LDA	#0
	STA	NEW_UP
	JMP	MV25
SMV34:	JMP	MV15

	;NOW TEST TO SEE IF THAT SPOT IS OPEN
MV25:	LDA	#0
	STA	CURSOR_ON
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	LDA	CURSOR_X
	CLC
	ADC	MAP_WINDOW_X
	STA	MAP_X
	STA	MOVTEMP_UX
	LDA	CURSOR_Y
	CLC
	ADC	MAP_WINDOW_Y
	STA	MAP_Y
	STA	MOVTEMP_UY
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	TAY
	LDA	TILE_ATTRIB,Y
	AND	#%00100000		;is that spot available	
	CMP	#%00100000		;for something to move onto it?
	BEQ	MV30	
	JMP	MV3A				;If not, then exit routine.
MV30:	;Now scan for any units at that location:
	JSR	CHECK_FOR_UNIT
	LDA	UNIT_FIND
	CMP	#255			;255 means no unit found.
	BEQ	MV31
MV3A:	LDA	#<MSG_BLOCKED
	STA	$FB
	LDA	#>MSG_BLOCKED
	STA	$FC
	JSR	PRINT_INFO
	LDA	#11		;ERROR SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS
MV31:	LDA	#06		;move sound
	JSR	PLAY_SOUND	;SOUND PLAY
	LDY	#0
	LDA	($FD),Y			;Grab current object
	STA	MOVTEMP_D
	LDA	MOVTEMP_O
	STA	($FD),Y			;replace with obect we are moving	
	LDA	MOVTEMP_X		;RETRIEVE original location of object
	STA	MAP_X
	LDA	MOVTEMP_Y
	STA	MAP_Y
	JSR	GET_TILE_FROM_MAP
	LDA	MOVTEMP_D
	CMP	#148		;trash compactor tile
	BNE	MV31A
	LDA	#09		;Floor tile
MV31A:	STA	($FD),Y			;Replace former location
	LDA	#1
	STA	REDRAW_WINDOW		;See the result
	LDA	MOVTEMP_U
	CMP	#255
	BNE	MV32
	RTS	
MV32:	LDX	MOVTEMP_U
	LDA	MOVTEMP_UX
	STA	UNIT_LOC_X,X
	LDA	MOVTEMP_UY
	STA	UNIT_LOC_Y,X
	RTS
MOVTEMP_O:	!BYTE 00	;origin tile
MOVTEMP_D:	!BYTE 00	;destination tile
MOVTEMP_X:	!BYTE 00	;x-coordinate
MOVTEMP_Y:	!BYTE 00	;y-coordinate
MOVTEMP_U:	!BYTE 00	;unit number (255=none)
MOVTEMP_UX	!BYTE 00
MOVTEMP_UY	!BYTE 00

CACULATE_AND_REDRAW:
	LDA	UNIT_LOC_X	;no index needed since it's player unit
	SEC
	SBC	#5
	STA	MAP_WINDOW_X
	LDA	UNIT_LOC_Y	;no index needed since it's player unit
	SEC
	SBC	#3
	STA	MAP_WINDOW_Y
	LDA	#1
	STA	REDRAW_WINDOW
	RTS

;This routine checks all units from 0 to 31 and figures out if it should be dislpayed
;on screen, and then grabs that unit's tile and stores it in the MAP_PRECALC array
;so that when the window is drawn, it does not have to search for units during the
;draw, speeding up the display routine.
MAP_PRE_CALCULATE:
	;CLEAR OLD BUFFER
	LDA	#0
	LDY	#0
PREC0:	STA	MAP_PRECALC,Y
	INY
	CPY	#77
	BNE	PREC0
	LDX	#0
	JMP	PREC2	;skip the check for unit zero, always draw it.
PREC1:	;CHECK THAT UNIT EXISTS
	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	PREC5
	;CHECK HORIZONTAL POSITION
	LDA	UNIT_LOC_X,X
	CMP	MAP_WINDOW_X
	BCC	PREC5
	LDA	MAP_WINDOW_X
	CLC
	ADC	#10
	CMP	UNIT_LOC_X,X
	BCC	PREC5
	;NOW CHECK VERTICAL
	LDA	UNIT_LOC_Y,X
	CMP	MAP_WINDOW_Y
	BCC	PREC5
	LDA	MAP_WINDOW_Y
	CLC
	ADC	#6
	CMP	UNIT_LOC_Y,X
	BCC	PREC5
	;Unit found in map window, now add that unit's
	;tile to the precalc map.
PREC2:	LDA	UNIT_LOC_Y,X
	SEC
	SBC	MAP_WINDOW_Y
	TAY
	LDA	UNIT_LOC_X,X
	SEC
	SBC	MAP_WINDOW_X
	CLC
	ADC	PRECALC_ROWS,Y	
	TAY
	LDA	UNIT_TILE,X
	CMP	#130	;is it a bomb
	BEQ	PREC6
	CMP	#134	;is it a magnet?
	BEQ	PREC6
PREC4:	STA	MAP_PRECALC,Y
PREC5:	;continue search
	INX	
	CPX	#32
	BNE	PREC1
	RTS
PREC6:	;What to do in case of bomb or magnet that should
	;go underneath the unit or robot.
	LDA	MAP_PRECALC,Y
	CMP	#0
	BNE	PREC5
	LDA	UNIT_TILE,X
	JMP	PREC4		

PRECALC_ROWS:	!BYTE	0,11,22,33,44,55,66

;This routine is where the MAP is displayed on the screen
;This is a temporary routine, taken from the map editor.
DRAW_MAP_WINDOW:
	JSR	MAP_PRE_CALCULATE
	LDA	#0
	STA	REDRAW_WINDOW
	STA	TEMP_X
	STA	TEMP_Y
	STA	PRECALC_COUNT
DM01:	;FIRST CALCULATE WHERE THE BYTE IS STORED IN THE MAP
	LDY	#0
	LDA	TEMP_Y
	CLC
	ADC	MAP_WINDOW_Y	
	ROR
	PHP
	CLC
	ADC	#>MAP
	STA	$FE	;HIGH BYTE OF MAP SOURCE
	LDA	#$0
	PLP
	ROR
	CLC
	ADC	TEMP_X
	ADC	MAP_WINDOW_X
	STA	$FD	;LOW BYTE OF MAP SOURCE
	LDA	($FD),Y
	STA	TILE
	;NOW FIGURE OUT WHERE TO PLACE IT ON SCREEN.
	LDX	TEMP_Y
	LDA	MAP_CHART_L,X
	STA	$FB	;LOW BYTE OF SCREEN AREA
	LDA	MAP_CHART_H,X
	STA	$FC	;HIGH BYTE OF SCREEN AREA
	LDA	TEMP_X
	ASL	;MULTIPLY BY 2
	CLC
	ADC	TEMP_X	;ADD ANOTHER TO MAKE X3
	ADC	$FB
	STA	$FB
	LDA	$FC
	ADC	#00	;CARRY FLAG
	STA	$FC
	JSR	PLOT_TILE
	;now check for sprites in this location
	LDY	PRECALC_COUNT
	LDA	MAP_PRECALC,Y
	CMP	#00
	BEQ	DM02
	STA	TILE
	LDX	TEMP_Y
	LDA	MAP_CHART_L,X
	STA	$FB	;LOW BYTE OF SCREEN AREA
	LDA	MAP_CHART_H,X
	STA	$FC	;HIGH BYTE OF SCREEN AREA
	LDA	TEMP_X
	ASL	;MULTIPLY BY 2
	CLC
	ADC	TEMP_X	;ADD ANOTHER TO MAKE X3
	ADC	$FB
	STA	$FB
	LDA	$FC
	ADC	#00	;CARRY FLAG
	STA	$FC
	JSR	PLOT_TRANSPARENT_TILE
DM02:	INC	TEMP_X
	INC	PRECALC_COUNT
	LDA	TEMP_X
	CMP	#11
	BNE	DM01
	;CHECK FOR CURSOR
DM03:	LDA	CURSOR_ON
	CMP	#1	;Is cursor even on?
	BNE	DM04
	LDA	TEMP_Y
	CMP	CURSOR_Y	;is cursor on the same row that were drawing?
	BNE	DM04
	JSR	REVERSE_TILE
DM04:	LDA	#0
	STA	TEMP_X
	INC	TEMP_Y
	LDA	TEMP_Y
	CMP	#7
	BEQ	DM10
	JMP	DM01
DM10:	RTS

;This routine plots a 3x3 tile from the tile database anywhere
;on screen.  But first you must define the tile number in the
;TILE variable, as well as the starting screen address must
;be defined in $FB.
PLOT_TILE:
	LDX	TILE
	;DRAW THE TOP 3 CHARACTERS
	LDA	TILE_DATA_TL,X
	LDY	#0
	STA	($FB),Y
	LDA	TILE_DATA_TM,X
	INY
	STA	($FB),Y	
	LDA	TILE_DATA_TR,X
	INY
	STA	($FB),Y	
	;MOVE DOWN TO NEXT LINE
;	LDA	$FB
;	CLC
;	ADC	#40
;	STA	$FB
;	LDA	$FC
;	ADC	#00
;	STA	$FC
	;DRAW THE MIDDLE 3 CHARACTERS
	LDA	TILE_DATA_ML,X
	LDY	#40
	STA	($FB),Y
	LDA	TILE_DATA_MM,X
	INY
	STA	($FB),Y	
	LDA	TILE_DATA_MR,X
	INY
	STA	($FB),Y	
	;MOVE DOWN TO NEXT LINE
;	LDA	$FB
;	CLC
;	ADC	#40
;	STA	$FB
;	LDA	$FC
;	ADC	#00
;	STA	$FC
	;DRAW THE BOTTOM 3 CHARACTERS
	LDA	TILE_DATA_BL,X
	LDY	#80
	STA	($FB),Y
	LDA	TILE_DATA_BM,X
	INY
	STA	($FB),Y	
	LDA	TILE_DATA_BR,X
	INY
	STA	($FB),Y	
	RTS

;This routine plots a transparent tile from the tile database
;anywhere on screen.  But first you must define the tile number
;in the TILE variable, as well as the starting screen address must
;be defined in $FB.  Also, this routine is slower than the usual
;tile routine, so is only used for sprites.  The ":" character ($3A)
;is not drawn.
PLOT_TRANSPARENT_TILE:
	LDX	TILE
	;DRAW THE TOP 3 CHARACTERS
	LDA	TILE_DATA_TL,X
	LDY	#0
	CMP	#$3A
	BEQ	PTT01
	STA	($FB),Y
PTT01:	LDA	TILE_DATA_TM,X
	INY
	CMP	#$3A
	BEQ	PTT02
	STA	($FB),Y	
PTT02:	LDA	TILE_DATA_TR,X
	INY
	CMP	#$3A
	BEQ	PTT03
	STA	($FB),Y	
	;MOVE DOWN TO NEXT LINE
PTT03:	;LDA	$FB
	;CLC
	;ADC	#40
	;STA	$FB
	;LDA	$FC
	;ADC	#00
	;STA	$FC
	;DRAW THE MIDDLE 3 CHARACTERS
	LDA	TILE_DATA_ML,X
	LDY	#40
	CMP	#$3A
	BEQ	PTT04
	STA	($FB),Y
PTT04:	LDA	TILE_DATA_MM,X
	INY
	CMP	#$3A
	BEQ	PTT05
	STA	($FB),Y	
PTT05:	LDA	TILE_DATA_MR,X
	INY
	CMP	#$3A
	BEQ	PTT06
	STA	($FB),Y	
	;MOVE DOWN TO NEXT LINE
PTT06:	;LDA	$FB
	;CLC
	;ADC	#40
	;STA	$FB
	;LDA	$FC
	;ADC	#00
	;STA	$FC
	;DRAW THE BOTTOM 3 CHARACTERS
	LDA	TILE_DATA_BL,X
	LDY	#80
	CMP	#$3A
	BEQ	PTT07
	STA	($FB),Y
PTT07:	LDA	TILE_DATA_BM,X
	INY
	CMP	#$3A
	BEQ	PTT08
	STA	($FB),Y	
PTT08:	LDA	TILE_DATA_BR,X
	INY
	CMP	#$3A
	BEQ	PTT09
	STA	($FB),Y	
PTT09:	RTS

REVERSE_TILE:
	LDX	CURSOR_Y
	LDA	MAP_CHART_L,X
	STA	$FB	;LOW BYTE OF SCREEN AREA
	LDA	MAP_CHART_H,X
	STA	$FC	;HIGH BYTE OF SCREEN AREA
	LDA	CURSOR_X
	ASL	;MULTIPLY BY 2
	CLC
	ADC	CURSOR_X	;ADD ANOTHER TO MAKE X3
	ADC	$FB
	STA	$FB
	LDA	$FC
	ADC	#00	;CARRY FLAG
	STA	$FC
	LDY	#00
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY	
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
;	TYA
;	CLC
;	ADC	#38
;	TAY
	LDY	#40
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY	
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
;	TYA
;	CLC
;	ADC	#38
;	TAY	
	LDY	#80
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY	
	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	RTS

;This routine checks to see if UNIT is occupying any space
;that is currently visible in the window.  If so, the
;flag for redrawing the window will be set.
CHECK_FOR_WINDOW_REDRAW:
	LDX	UNIT
	;FIRST CHECK HORIZONTAL
	LDA	UNIT_LOC_X,X
	CMP	MAP_WINDOW_X
	BCC	CFR1
	LDA	MAP_WINDOW_X
	CLC
	ADC	#10
	CMP	UNIT_LOC_X,X
	BCC	CFR1
	;NOW CHECK VERTICAL
	LDA	UNIT_LOC_Y,X
	CMP	MAP_WINDOW_Y
	BCC	CFR1
	LDA	MAP_WINDOW_Y
	CLC
	ADC	#6
	CMP	UNIT_LOC_Y,X
	BCC	CFR1
	LDA	#1
	STA	REDRAW_WINDOW
CFR1:	RTS

DECWRITE:
	LDA	#$00
	STA	SCREENPOS
	LDA	DECNUM
	LDX 	#2
	LDY 	#$4C
DEC1:	STY 	DECB
	LSR
DEC2:	ROL
	BCS 	DEC3
	CMP	DECA,X
	BCC 	DEC4
DEC3:	SBC 	DECA,X
	SEC
DEC4:	ROL 	DECB
	BCC 	DEC2
	STA	DECTEMP
	LDA 	DECB
	LDY	SCREENPOS
	STA	($FB),Y
	INC	SCREENPOS
	LDA	DECTEMP
	LDY 	#$13
	DEX
	BPL 	DEC1
	RTS
DECA		!BYTE  	128,160,200
DECB		!BYTE  	1
SCREENPOS	!BYTE	$00
DECTEMP		!BYTE	$00

; The following routine loads the tileset from disk
TILE_LOAD_ROUTINE:	
	LDA	#11	;LENGTH OF FILENAME
	STA	$D1	;LENGTH OF FILENAME
	LDA	#<TILENAME
	STA	$DA	;LOW BYTE OF FILENAME
	LDA	#>TILENAME
	STA	$DB	;HIGH BYTE OF FILENAME
	LDA	#08	;DEVICE NUMBER 8
	STA	$D4	;DEVICE NUMBER
	LDA	#$00
	STA	$9D	;load/verify (0=load 1=verify)
LDR1:	JSR	$F356 	;LOAD ROUTINE (USE $F322 IN BASIC 2)
	RTS
; The following routine loads the tileset from disk

;SOUND_LOAD_ROUTINE:	
;	LDA	#8	;LENGTH OF FILENAME
;	STA	$D1	;LENGTH OF FILENAME
;	LDA	#<SNDNAME
;	STA	$DA	;LOW BYTE OF FILENAME
;	LDA	#>SNDNAME
;	STA	$DB	;HIGH BYTE OF FILENAME
;	LDA	#08	;DEVICE NUMBER 8
;	STA	$D4	;DEVICE NUMBER
;	LDA	#$00
;	STA	$9D	;load/verify (0=load 1=verify)
;	JSR	$F356 	;LOAD ROUTINE (USE $F322 IN BASIC 2)
;	RTS

; The following routine loads the map from disk
MAP_LOAD_ROUTINE:	
	LDA	#7	;LENGTH OF FILENAME
	STA	$D1	;LENGTH OF FILENAME
	LDA	#<MAPNAME
	STA	$DA	;LOW BYTE OF FILENAME
	LDA	#>MAPNAME
	STA	$DB	;HIGH BYTE OF FILENAME
	LDA	#08	;DEVICE NUMBER 8
	STA	$D4	;DEVICE NUMBER
	LDA	#$00
	STA	$9D	;load/verify (0=load 1=verify)
LDR2:	JSR	$F356 	;LOAD ROUTINE (USE $F322 IN BASIC 2)
	RTS

DISPLAY_GAME_SCREEN:
	LDA	#<SCR_TEXT
	STA	$FB
	LDA	#>SCR_TEXT
	STA	$FC
	JSR	DECOMPRESS_SCREEN
	RTS

DISPLAY_INTRO_SCREEN:
	LDA	#<INTRO_TEXT
	STA	$FB
	LDA	#>INTRO_TEXT
	STA	$FC
	JSR	DECOMPRESS_SCREEN
	RTS

DISPLAY_ENDGAME_SCREEN:
	LDA	#<SCR_ENDGAME
	STA	$FB
	LDA	#>SCR_ENDGAME
	STA	$FC
	JSR	DECOMPRESS_SCREEN
	;display map name
	JSR	CALC_MAP_NAME
DEG3:	LDA	($FB),Y
	STA	$812E,Y
	INY
	CPY	#16
	BNE	DEG3	
	;display elapsed time
	LDA	HOURS
	STA	DECNUM
	LDA	#$81
	STA	$FC
	LDA	#$7D
	STA	$FB
	JSR	DECWRITE
	LDA	MINUTES
	STA	DECNUM
	LDA	#$81
	STA	$FC
	LDA	#$80
	STA	$FB
	JSR	DECWRITE
	LDA	SECONDS
	STA	DECNUM
	LDA	#$81
	STA	$FC
	LDA	#$83
	STA	$FB
	JSR	DECWRITE
	LDA	#32	;SPACE
	STA	$817D
	LDA	#58	;COLON
	STA	$8180
	STA	$8183
	;count robots remaining
	LDX	#1
	LDA	#0
	STA	DECNUM
DEG7:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	DEG8
	INC	DECNUM
DEG8:	INX
	CPX	#28
	BNE	DEG7
	LDA	#$81
	STA	$FC
	LDA	#$CE
	STA	$FB
	JSR	DECWRITE
	;Count secrets remaining
	LDA	#0
	STA	DECNUM
	LDX	#48
DEG9:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	DEG10
	INC	DECNUM
DEG10:	INX
	CPX	#64
	BNE	DEG9
	LDA	#$82
	STA	$FC
	LDA	#$1E
	STA	$FB
	JSR	DECWRITE
	;display difficulty level
	LDY	DIFF_LEVEL
	LDA	DIFF_LEVEL_LEN,Y
	TAY	
	LDX	#0
DEG11:	LDA	DIFF_LEVEL_WORDS,Y
	CMP	#0
	BEQ	DEG12
	STA	$826E,X
	INY
	INX
	JMP	DEG11
DEG12:	RTS

DIFF_LEVEL_WORDS:
	!SCR "easy",0,"normal",0,"hard",0
DIFF_LEVEL_LEN:
	!BYTE 0,5,12

DECOMPRESS_SCREEN:
	LDA	#$00
	STA	$FD
	LDA	#$80
	STA	$FE
	LDY	#00
DGS1:	LDA	($FB),Y
	CMP	#96	;REPEAT FLAG
	BEQ	DGS10	
DGS2:	STA	($FD),Y
	;CHECK TO SEE IF WE REACHED $83E7 YET.	
DGS4:	LDA	$FE
	CMP	#$83
	BNE	DGS3
	LDA	$FD
	CMP	#$E7
	BNE	DGS3
	RTS
DGS3:	JSR	INC_SOURCE
	JSR	INC_DEST
	JMP	DGS1
DGS10:	;REPEAT CODE
	JSR	INC_SOURCE
	LDA	($FB),Y
	STA	RPT
	JSR	INC_SOURCE
	LDA	($FB),Y
	TAX
DGS11:	LDA	RPT
	STA	($FD),Y
	JSR	INC_DEST
	DEX
	CPX	#$FF
	BNE	DGS11
	LDA	$FD
	SEC
	SBC	#01
	STA	$FD
	LDA	$FE
	SBC	#00
	STA	$FE
	JMP	DGS4	
INC_SOURCE:
	LDA	$FB
	CLC
	ADC	#01
	STA	$FB
	LDA	$FC
	ADC	#00
	STA	$FC
	RTS
INC_DEST:
	LDA	$FD
	CLC
	ADC	#01
	STA	$FD
	LDA	$FE
	ADC	#00
	STA	$FE
	RTS
RPT	!BYTE 00	;repeat value

DISPLAY_PLAYER_HEALTH:
	LDA	UNIT_HEALTH	;No index needed because it is the player
	LSR			;divide by two
	STA	TEMP_A
	LDY	#00
DPH01:	CPY	TEMP_A
	BEQ	DPH02	
	LDA	#$66		;GRAY BLOCK
	STA	$83BA,Y
	INY	
	JMP	DPH01	
DPH02:	LDA	UNIT_HEALTH
	AND	#%00000001
	CMP	#%00000001
	BNE	DPH03
	LDA	#$5C		;HALF GRAY BLOCK
	STA	$83BA,Y
	INY
DPH03:	CPY	#6
	BEQ	DPH04
	LDA	#$20		;SPACE
	STA	$83BA,Y	
	INY
	JMP	DPH03
DPH04:	RTS

CYCLE_ITEM:
	LDA	#13		;CHANGE-ITEM-SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	LDA	SELECT_TIMEOUT
	CMP	#0
	BEQ	CYIT0
	RTS
CYIT0:	LDA	#3
	STA	SELECT_TIMEOUT	;RESET THE TIMEOUT
	LDA	#20
	STA	KEYTIMER
	INC	SELECTED_ITEM
	LDA	SELECTED_ITEM
	CMP	#5
	BEQ	CYIT1
	JMP	DISPLAY_ITEM
CYIT1:	LDA	#0
	STA	SELECTED_ITEM
	JMP	DISPLAY_ITEM

DISPLAY_ITEM:
	JSR	PRESELECT_ITEM
DSIT00:	LDA	SELECTED_ITEM
	CMP	#0	;no items to show
	BNE	DSIT01
	;add routine to draw blank space
	RTS
DSIT01:	CMP	#5	;number too high!
	BNE	DSIT0A
	LDA	#0
	STA	SELECTED_ITEM
	RTS
DSIT0A:	CMP	#1	;bomb
	BNE	DSIT03
	LDA	INV_BOMBS
	CMP	#0	;did we run out?
	BNE	DSIT02
	INC	SELECTED_ITEM
	JMP	DSIT00
DSIT02:	JSR	DISPLAY_TIMEBOMB
	RTS
DSIT03:	CMP	#2	;emp
	BNE	DSIT05
	LDA	INV_EMP
	CMP	#0	;did we run out?
	BNE	DSIT04
	INC	SELECTED_ITEM
	JMP	DSIT00
DSIT04:	JSR	DISPLAY_EMP
	RTS
DSIT05:	CMP	#3	;medkit
	BNE	DSIT07
	LDA	INV_MEDKIT
	CMP	#0	;did we run out?
	BNE	DSIT06
	INC	SELECTED_ITEM
	JMP	DSIT00
DSIT06:	JSR	DISPLAY_MEDKIT
	RTS
DSIT07:	CMP	#4	;magnet
	BNE	DSIT09
	LDA	INV_MAGNET
	CMP	#0	;did we run out?
	BNE	DSIT08
	INC	SELECTED_ITEM
	JMP	DSIT09
DSIT08:	JSR	DISPLAY_MAGNET
	RTS
DSIT09:	LDA	#0
	STA	SELECTED_ITEM
	JSR	PRESELECT_ITEM
	JMP	DISPLAY_ITEM

;This routine checks to see if currently selected
;item is zero.  And if it is, then it checks inventories
;of other items to decide which item to automatically
;select for the user.
PRESELECT_ITEM:
	LDA	SELECTED_ITEM
	CMP	#0		;If item already selected, return
	BEQ	PRSI01
	RTS	
PRSI01:	LDA	INV_BOMBS
	CMP	#0
	BEQ	PRSI02
	LDA	#1	;BOMB
	STA	SELECTED_ITEM
	RTS
PRSI02:	LDA	INV_EMP
	CMP	#0
	BEQ	PRSI03
	LDA	#2	;EMP
	STA	SELECTED_ITEM
	RTS
PRSI03:	LDA	INV_MEDKIT
	CMP	#0
	BEQ	PRSI04
	LDA	#3	;MEDKIT
	STA	SELECTED_ITEM
	RTS
PRSI04:	LDA	INV_MAGNET
	CMP	#0
	BEQ	PRSI05
	LDA	#4	;MAGNET
	STA	SELECTED_ITEM
	RTS
PRSI05:	;Nothing found in inventory at this point, so set
	;selected-item to zero.
	LDA	#0	;nothing in inventory
	STA	SELECTED_ITEM
	JSR	DISPLAY_BLANK_ITEM
	RTS

DISPLAY_TIMEBOMB:
	LDY	#0
DTB1:	LDA	TBOMB1A,Y
	STA	$8162,Y
	LDA	TBOMB1B,Y
	STA	$818A,Y
	LDA	TBOMB1C,Y
	STA	$81B2,Y
	LDA	TBOMB1D,Y
	STA	$81DA,Y
	INY
	CPY	#6
	BNE	DTB1
	LDA	INV_BOMBS
	STA	DECNUM
	LDA	#$05
	STA	$FB
	LDA	#$82
	STA	$FC
	JSR	DECWRITE	
	RTS

DISPLAY_EMP:
	LDY	#0
DEM1:	LDA	EMP1A,Y
	STA	$8162,Y
	LDA	EMP1B,Y
	STA	$818A,Y
	LDA	EMP1C,Y
	STA	$81B2,Y
	LDA	EMP1D,Y
	STA	$81DA,Y
	INY
	CPY	#6
	BNE	DEM1
	LDA	INV_EMP
	STA	DECNUM
	LDA	#$05
	STA	$FB
	LDA	#$82
	STA	$FC
	JSR	DECWRITE	
	RTS

DISPLAY_MEDKIT:
	LDY	#0
DMK1:	LDA	MED1A,Y
	STA	$8162,Y
	LDA	MED1B,Y
	STA	$818A,Y
	LDA	MED1C,Y
	STA	$81B2,Y
	LDA	MED1D,Y
	STA	$81DA,Y
	INY
	CPY	#6
	BNE	DMK1
	LDA	INV_MEDKIT
	STA	DECNUM
	LDA	#$05
	STA	$FB
	LDA	#$82
	STA	$FC
	JSR	DECWRITE	
	RTS

DISPLAY_MAGNET:
	LDY	#0
DMG1:	LDA	MAG1A,Y
	STA	$8162,Y
	LDA	MAG1B,Y
	STA	$818A,Y
	LDA	MAG1C,Y
	STA	$81B2,Y
	LDA	MAG1D,Y
	STA	$81DA,Y
	INY
	CPY	#6
	BNE	DMG1
	LDA	INV_MAGNET
	STA	DECNUM
	LDA	#$05
	STA	$FB
	LDA	#$82
	STA	$FC
	JSR	DECWRITE	
	RTS

DISPLAY_BLANK_ITEM:
	LDY	#0
DBI1:	LDA	#32
	STA	$8162,Y
	STA	$818A,Y
	STA	$81B2,Y
	STA	$81DA,Y
	STA	$8202,Y
	INY
	CPY	#6
	BNE	DBI1	
	RTS

CYCLE_WEAPON:
	LDA	#12		;CHANGE WEAPON-SOUND
	JSR	PLAY_SOUND	;SOUND PLAY
	LDA	SELECT_TIMEOUT
	CMP	#0
	BEQ	CYWE0
	RTS
CYWE0:	LDA	#3
	STA	SELECT_TIMEOUT	;RESET THE TIMEOUT
	LDA	#20
	STA	KEYTIMER
	INC	SELECTED_WEAPON
	LDA	SELECTED_WEAPON
	CMP	#2
	BNE	CYWE1
	JMP	DISPLAY_WEAPON
CYWE1:	LDA	#0
	STA	SELECTED_WEAPON
	JMP	DISPLAY_WEAPON

DISPLAY_WEAPON:
	JSR	PRESELECT_WEAPON
	LDA	SELECTED_WEAPON
	CMP	#0	;no weapon to show
	BNE	DSWP01
	;add routine to draw blank space
	RTS
DSWP01:	CMP	#1	;PISTOL
	BNE	DSWP03
	LDA	AMMO_PISTOL
	CMP	#0	;did we run out?
	BNE	DSWP02
	LDA	#0
	STA	SELECTED_WEAPON
	JMP	DISPLAY_WEAPON
DSWP02:	JSR	DISPLAY_PISTOL
	RTS
DSWP03:	CMP	#2	;PLASMA GUN
	BNE	DSWP05
	LDA	AMMO_PLASMA
	CMP	#0	;did we run out?
	BNE	DSWP04
	LDA	#0
	STA	SELECTED_WEAPON
	JMP	DISPLAY_WEAPON
DSWP04:	JSR	DISPLAY_PLASMA_GUN
	RTS
DSWP05:	LDA	#0
	STA	SELECTED_WEAPON	;should never happen
	JMP	DISPLAY_WEAPON
	
;This routine checks to see if currently selected
;weapon is zero.  And if it is, then it checks inventories
;of other weapons to decide which item to automatically
;select for the user.
PRESELECT_WEAPON:
	LDA	SELECTED_WEAPON
	CMP	#0		;If item already selected, return
	BEQ	PRSW01
	RTS	
PRSW01:	LDA	AMMO_PISTOL
	CMP	#0
	BEQ	PRSW02
	LDA	#1	;PISTOL
	STA	SELECTED_WEAPON
	RTS
PRSW02:	LDA	AMMO_PLASMA
	CMP	#0
	BEQ	PRSW04
	LDA	#2	;PLASMAGUN
	STA	SELECTED_WEAPON
	RTS
PRSW04:	;Nothing found in inventory at this point, so set
	;selected-item to zero.
	LDA	#0	;nothing in inventory
	STA	SELECTED_WEAPON
	JSR	DISPLAY_BLANK_WEAPON
	RTS

DISPLAY_PLASMA_GUN:
	LDY	#0
DW1:	LDA	WEAPON1A,Y
	STA	$804A,Y
	LDA	WEAPON1B,Y
	STA	$8072,Y
	LDA	WEAPON1C,Y
	STA	$809A,Y
	LDA	WEAPON1D,Y
	STA	$80C2,Y
	INY
	CPY	#6
	BNE	DW1
	LDA	AMMO_PLASMA
	STA	DECNUM
	LDA	#$ED
	STA	$FB
	LDA	#$80
	STA	$FC
	JSR	DECWRITE	
	RTS

DISPLAY_PISTOL:
	LDY	#0
DW2:	LDA	PISTOL1A,Y
	STA	$804A,Y
	LDA	PISTOL1B,Y
	STA	$8072,Y
	LDA	PISTOL1C,Y
	STA	$809A,Y
	LDA	PISTOL1D,Y
	STA	$80C2,Y
	INY
	CPY	#6
	BNE	DW2
	LDA	AMMO_PISTOL
	STA	DECNUM
	LDA	#$ED
	STA	$FB
	LDA	#$80
	STA	$FC
	JSR	DECWRITE	
	RTS

DISPLAY_BLANK_WEAPON:
	LDY	#0
DBW2:	LDA	#32
	STA	$804A,Y
	STA	$8072,Y
	STA	$809A,Y
	STA	$80C2,Y
	STA	$80EA,Y
	INY
	CPY	#6
	BNE	DBW2
	RTS	

DISPLAY_KEYS:
	LDA	#32
	STA	$827A	;ERASE ALL 3 SPOTS
	STA	$827B
	STA	$827C
	STA	$827D
	STA	$827E
	STA	$827F
	STA	$82A2
	STA	$82A3
	STA	$82A4
	STA	$82A5
	STA	$82A6
	STA	$82A7
	LDA	KEYS
	AND	#%00000001
	CMP	#%00000001	;Spade key
	BNE	DKS1
	LDA	#$63
	STA	$827A
	LDA	#$4D
	STA	$827B
	LDA	#$41
	STA	$82A2	
	LDA	#$67
	STA	$82A3
DKS1:	LDA	KEYS
	AND	#%00000010
	CMP	#%00000010	;heart key
	BNE	DKS2
	LDA	#$63
	STA	$827C
	LDA	#$4D
	STA	$827D
	LDA	#$53
	STA	$82A4
	LDA	#$67
	STA	$82A5
DKS2:	LDA	KEYS
	AND	#%00000100
	CMP	#%00000100	;star key
	BNE	DKS3
	LDA	#$63
	STA	$827E
	LDA	#$4D
	STA	$827F
	LDA	#$2A
	STA	$82A6
	LDA	#$67
	STA	$82A7
DKS3:	RTS

GAME_OVER:
	;stop game clock
	LDA	#0
	STA	CLOCK_ACTIVE
	;disable music
	LDA	#0
	STA	MUSIC_ON
	STA	$E848	;turn off sound
	STA	$E84A	;turn off sound
	;Did player die or win?
	LDA	UNIT_TYPE
	CMP	#0
	BNE	GOM0
	LDA	#111	;dead player tile
	STA	UNIT_TILE
	LDA	#100
	STA	KEYTIMER
GOM0:	JSR	PET_SCREEN_SHAKE
	JSR	BACKGROUND_TASKS
	LDA	KEYTIMER
	CMP	#0
	BNE	GOM0
	LDX	#0
GOM1:	LDA	GAMEOVER1,X
	STA	$8173,X
	LDA	GAMEOVER2,X
	STA	$819B,X
	LDA	GAMEOVER3,X
	STA	$81C3,X
	INX
	CPX	#11
	BNE	GOM1
	LDA	#100
	STA	KEYTIMER
GOM2:	LDA	KEYTIMER
	CMP	#0
	BNE	GOM2
	LDA	#0
	STA	$009E	;CLEAR KEYBOARD BUFFER
	JSR	CLEAR_SNES_PAD
GOM3:	JSR	SNES_CONTROLER_READ
	LDA	NEW_B
	CMP	#1
	BEQ	GOM4
	JSR	$FFE4
	CMP	#$00
	BEQ	GOM3
GOM4:	LDA	#0
	STA	$009E	;CLEAR KEYBOARD BUFFER
	JSR	CLEAR_SNES_PAD
	LDA	#0
	STA	MUSIC_ON
	JSR	DISPLAY_ENDGAME_SCREEN
	JSR	DISPLAY_WIN_LOSE
GOM5:	JSR	SNES_CONTROLER_READ
	LDA	NEW_B
	CMP	#1
	BEQ	GOM6
	JSR	$FFE4
	CMP	#$00
	BEQ	GOM5
	;LDA	#0
	;STA	$009E	;CLEAR KEYBOARD BUFFER
GOM6:	JMP	INTRO_SCREEN

GAMEOVER1:	!BYTE	$70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$6e
GAMEOVER2:	!BYTE	$5d,$07,$01,$0d,$05,$20,$0f,$16,$05,$12,$5d
GAMEOVER3:	!BYTE	$6d,$40,$40,$40,$40,$40,$40,$40,$40,$40,$7d

DISPLAY_WIN_LOSE:
	JSR	STOP_SONG
	LDX	#0
	LDA	UNIT_TYPE
	CMP	#0
	BEQ	DWL5
DWL1:	;WIN MESSAGE
	LDA	WIN_MSG,X
	STA	$8088,X
	INX
	CPX	#8
	BNE	DWL1
	LDA	#18	;win music
	JSR	PLAY_SOUND
	RTS
DWL5:	;LOSE MESSAGE
	LDA	LOS_MSG,X
	STA	$8088,X
	INX
	CPX	#9
	BNE	DWL5
	LDA	#19	;LOSE music
	JSR	PLAY_SOUND
	RTS

WIN_MSG:	!SCR"you win!"
LOS_MSG:	!SCR"you lose!"

PRINT_INTRO_MESSAGE:
	LDA	#<INTRO_MESSAGE
	STA	$FB
	LDA	#>INTRO_MESSAGE
	STA	$FC
	JSR	PRINT_INFO
	RTS

;This routine will print something to the "information" window
;at the bottom left of the screen.  You must first define the 
;source of the text in $FB. The text should terminate with
;a null character.
PRINT_INFO:
	JSR	SCROLL_INFO	;New text always causes a scroll
	LDY	#0
	STY	PRINTX
PI01:	LDA	($FB),Y
	CMP	#0	;null terminates string
	BNE	PI02
	RTS
PI02:	CMP	#255	;return
	BNE	PI03
	LDX	#0
	STX	PRINTX
	JSR	SCROLL_INFO
	JMP	PI04
PI03:	LDX	PRINTX
	STA	$83C0,X
	INC	PRINTX
PI04:	INY
	JMP	PI01
PRINTX:	!BYTE 00	;used to store X-cursor location

;This routine scrolls the info screen by one row, clearing
;a new row at the bottom.
SCROLL_INFO:
	LDX	#0
SCI1:	LDA	$8398,X
	STA	$8370,X
	LDA	$83C0,X	;BOTTOM ROW
	STA	$8398,X
	INX
	CPX	#33
	BNE	SCI1
	;NOW CLEAR BOTTOM ROW
	LDX	#0
	LDA	#32
SCI2:	STA	$83C0,X;BOTTOM ROW
	INX
	CPX	#33
	BNE	SCI2
	RTS

RESET_KEYS_AMMO:
	LDA	#$00
	STA	KEYS
	STA	AMMO_PISTOL
	STA	AMMO_PLASMA
	STA	INV_BOMBS
	STA	INV_EMP		
	STA	INV_MEDKIT
	STA	INV_MAGNET	
	STA	SELECTED_WEAPON
	STA	SELECTED_ITEM
	STA	MAGNET_ACT
	STA	PLASMA_ACT
	STA	BIG_EXP_ACT
	STA	CYCLES
	STA	SECONDS
	STA	MINUTES
	STA	HOURS
	RTS

INTRO_SCREEN:
	JSR	DISPLAY_INTRO_SCREEN
	JSR	DISPLAY_MAP_NAME
	JSR	CHANGE_DIFFICULTY_LEVEL
	JSR	START_INTRO_MUSIC
	LDA	#0
	STA	MENUY
	JSR	REVERSE_MENU_OPTION
	JSR	CLEAR_SNES_PAD
	JSR	CLEAR_KEY_BUFFER
ISLOOP	JSR	$FFE4	;SCAN for key presses
	CMP	#00
	BEQ	IS011	;If none found, try SNES
	CMP	#$11	;CURSOR DOWN
	BNE	IS001
	JSR	MENU_DOWN
	JMP	ISLOOP
IS001:	CMP	#$91	;CURSOR UP
	BNE	IS002
	JSR	MENU_UP
	JMP	ISLOOP
IS002:	CMP	#32	;SPACE
	BNE	IS003
	JMP	EXEC_COMMAND
IS003:	CMP	KEY_MOVE_UP
	BNE	IS004
	JSR	MENU_UP
	JMP	ISLOOP
IS004:	CMP	KEY_MOVE_DOWN
	BNE	IS005
	JSR	MENU_DOWN
	JMP	ISLOOP
IS005:	CMP	#13	;RETURN
	BNE	IS006
	LDA	#15 		;menu beep
	JSR	PLAY_SOUND	;SOUND PLAY
	JMP	EXEC_COMMAND	
IS006:	JMP	ISLOOP
IS011:	;Now check SNES status for menu
	JSR	SNES_CONTROLER_READ
	LDA	NEW_UP
	CMP	#1
	BNE	IS012
	JSR	MENU_UP
	LDA	#0
	STA	NEW_UP
	JMP	ISLOOP
IS012:	LDA	NEW_DOWN
	CMP	#1
	BNE	IS013
	JSR	MENU_DOWN
	LDA	#0
	STA	NEW_DOWN
	JMP	ISLOOP
IS013:	LDA	NEW_B
	CMP	#1
	BNE	IS014
	LDA	#0
	STA	NEW_B
	JMP	EXEC_COMMAND
IS014:	JMP	ISLOOP

MENU_UP:
	LDA	MENUY
	CMP	#0
	BNE	MENUP1
	RTS
MENUP1:	JSR	REVERSE_MENU_OPTION
	DEC	MENUY
	JSR	REVERSE_MENU_OPTION
	LDA	#15		;MENU BEEP
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS

MENU_DOWN:
	LDA	MENUY
	CMP	#3
	BNE	MENDN1
	RTS
MENDN1:	JSR	REVERSE_MENU_OPTION
	INC	MENUY
	JSR	REVERSE_MENU_OPTION
	LDA	#15		;menu beep
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS

START_INTRO_MUSIC:
	LDA	#0
	STA	DATA_LINE
	LDA	#$FF
	STA	SOUND_EFFECT
	LDA	#<INTRO_MUSIC
	STA	CUR_PATTERN_L
	LDA	#>INTRO_MUSIC
	STA	CUR_PATTERN_H
	LDA	#1
	STA	MUSIC_ON
	RTS

EXEC_COMMAND:
	LDA	MENUY
	CMP	#00	;START GAME
	BNE	EXEC1
	JSR	SET_CONTROLS
	LDA	#0
	STA	MUSIC_ON
	STA	$E848	;turn off sound
	STA	$E84A	;turn off sound
	JMP	INIT_GAME
EXEC1:	CMP	#2	;DIFF LEVEL
	BNE	EXEC05
	INC	DIFF_LEVEL
	LDA	DIFF_LEVEL
	CMP	#3
	BNE	EXEC02
	LDA	#0
	STA	DIFF_LEVEL
EXEC02:	JSR	CHANGE_DIFFICULTY_LEVEL
	LDA	#15	;menu beep
	JSR	PLAY_SOUND
	JMP	ISLOOP
EXEC05:	CMP	#1	;cycle map
	BNE	EXEC06
	LDA	#15	;menu beep
	JSR	PLAY_SOUND
	JSR	CYCLE_MAP
	JMP	ISLOOP
EXEC06:	CMP	#3
	BNE	EXEC07
	JSR	CYCLE_CONTROLS
	LDA	#15	;menu beep
	JSR	PLAY_SOUND
EXEC07:	JMP	ISLOOP

CYCLE_CONTROLS:
	LDA	#0
	STA	KEYS_DEFINED
	INC	CONTROL
	LDA	CONTROL
	CMP	#3
	BNE	CCON2
	LDA	#0
	STA	CONTROL
CCON2:	;display control method on screen
	LDY	CONTROL
	LDA	CONTROLSTART,Y
	TAY
	LDX	#0
CCON3:	LDA	CONTROLTEXT,Y
	ORA	#%10000000
	STA	$80CC,X
	INX
	INY
	CPX	#10
	BNE	CCON3
	RTS

CONTROLTEXT:	!SCR"keyboard  "
		!SCR"custom key"
		!SCR"snes pad  "
CONTROLSTART:	!BYTE 00,10,20

CYCLE_MAP:
	INC	SELECTED_MAP
	LDA	SELECTED_MAP
	CMP	#14	;Maximum number of maps
	BNE	CYM1
	LDA	#0
	STA	SELECTED_MAP
CYM1:	JSR	DISPLAY_MAP_NAME
	RTS

DISPLAY_MAP_NAME:
	JSR	CALC_MAP_NAME
DMN1:	LDA	($FB),Y
	STA	$816A,Y
	INY
	CPY	#16
	BNE	DMN1
	;now set the mapname for the filesystem load
	LDA	SELECTED_MAP
	CLC
	ADC	#65
	STA	MAPNAME+6
	RTS

CALC_MAP_NAME:
	;FIND MAP NAME
	LDA	SELECTED_MAP
	STA	$FB
	LDA	#0
	STA	$FC
	;multiply by 16 by shifting 4 times to left.
	ASL	$FB
	ROL	$FC
	ASL	$FB
	ROL	$FC
	ASL	$FB
	ROL	$FC
	ASL	$FB
	ROL	$FC
	;now add offset for mapnames	
	LDA	$FB
	CLC
	ADC	#<MAP_NAMES
	STA	$FB
	LDA	$FC
	ADC	#>MAP_NAMES
	STA	$FC
	LDY	#0
	RTS

REVERSE_MENU_OPTION:
	LDY	MENUY
	LDA	MENU_CHART_L,Y
	STA	$FB
	LDA	#$80
	STA	$FC
	LDY	#0
RMO1:	LDA	($FB),Y
	EOR	#%10000000
	STA	($FB),Y
	INY
	CPY	#10
	BNE	RMO1	
	RTS
MENUY	!BYTE	$00	;CURRENT MENU SELECTION
MENU_CHART_L:
	!BYTE $54,$7C,$A4,$CC

CHANGE_DIFFICULTY_LEVEL:
	LDY	DIFF_LEVEL
	LDA	FACE_LEVEL,Y
	TAY
	;DO CHARACTERS FIRST
	LDA	ROBOT_FACE,Y
	STA	$80DD
	INY
	LDA	ROBOT_FACE,Y
	STA	$80DE
	INY
	LDA	ROBOT_FACE,Y
	STA	$80DF
	INY
	LDA	ROBOT_FACE,Y
	STA	$80E1
	INY
	LDA	ROBOT_FACE,Y
	STA	$80E2
	INY
	LDA	ROBOT_FACE,Y
	STA	$80E3
	INY
	LDA	ROBOT_FACE,Y
	STA	$8107
	INY
	LDA	ROBOT_FACE,Y
	STA	$8109
	RTS
DIFF_LEVEL	!BYTE 01	;default medium

ROBOT_FACE:
	!BYTE	$3A,$43,$49,$55,$43,$3A,$49,$55	;EASY LEVEL
	!BYTE	$40,$40,$6E,$70,$40,$40,$49,$55	;MEDIUM LEVEL
	!BYTE	$3A,$4D,$3A,$3A,$4E,$3A,$4D,$4E	;HARD LEVEL
FACE_LEVEL:
	!BYTE	0,8,16

;This routine is run after the map is loaded, but before the
;game starts.  If the diffulcty is set to normal, nothing 
;actually happens.  But if it is set to easy or hard, then
;some changes occur accordingly.
SET_DIFF_LEVEL:
	LDA	DIFF_LEVEL
	CMP	#0	;easy
	BNE	SDLE1
	JMP	SET_DIFF_EASY
SDLE1:	CMP	#2	;hard
	BNE	SDLE2
	JMP	SET_DIFF_HARD
SDLE2:	RTS

SET_DIFF_EASY:
	;Find all hidden items and double the quantity.
	LDX	#48
SDE1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	SDE2
	CMP	#128	;KEY
	BEQ	SDE2
	ASL	UNIT_A,X	;item qty
SDE2:	INX
	CPX	#64
	BNE	SDE1	
	RTS

SET_DIFF_HARD:
	;Find all hoverbots and change AI
	LDX	#0
SDH1:	LDA	UNIT_TYPE,X
	CMP	#2	;hoverbot left/right
	BEQ	SDH4
	CMP	#3	;hoverbot up/down
	BEQ	SDH4
SDH2:	INX	
	CPX	#28
	BNE	SDH1
	RTS
SDH4:	LDA	#4	;hoverbot attack mode
	STA	UNIT_TYPE,X
	JMP	SDH2

;This chart contains the left-most staring position for each
;row of tiles on the map-editor. 7 Rows.
MAP_CHART_L:
	!BYTE $00,$78,$F0,$68,$E0,$58,$D0

MAP_CHART_H:
	!BYTE $80,$80,$80,$81,$81,$82,$82

EMP_FLASH:
	LDY	#0
EMPF1:	LDA	$8000,Y		;screen row 00
	EOR	#%10000000
	STA	$8000,Y		;screen row 00
	LDA	$8028,Y		;screen row 01
	EOR	#%10000000
	STA	$8028,Y		;screen row 01
	LDA	$8050,Y		;screen row 02
	EOR	#%10000000
	STA	$8050,Y		;screen row 02
	LDA	$8078,Y		;screen row 03
	EOR	#%10000000
	STA	$8078,Y		;screen row 03
	LDA	$80A0,Y		;screen row 04
	EOR	#%10000000
	STA	$80A0,Y		;screen row 04
	LDA	$80C8,Y		;screen row 05
	EOR	#%10000000
	STA	$80C8,Y		;screen row 05
	LDA	$80F0,Y		;screen row 06
	EOR	#%10000000
	STA	$80F0,Y		;screen row 06
	LDA	$8118,Y		;screen row 07
	EOR	#%10000000
	STA	$8118,Y		;screen row 07
	LDA	$8140,Y		;screen row 08
	EOR	#%10000000
	STA	$8140,Y		;screen row 08
	LDA	$8168,Y		;screen row 09
	EOR	#%10000000
	STA	$8168,Y		;screen row 09
	LDA	$8190,Y		;screen row 10
	EOR	#%10000000
	STA	$8190,Y		;screen row 10
	LDA	$81B8,Y		;screen row 11
	EOR	#%10000000
	STA	$81B8,Y		;screen row 11
	LDA	$81E0,Y		;screen row 12
	EOR	#%10000000
	STA	$81E0,Y		;screen row 12
	LDA	$8208,Y		;screen row 13
	EOR	#%10000000
	STA	$8208,Y		;screen row 13
	LDA	$8230,Y		;screen row 14
	EOR	#%10000000
	STA	$8230,Y		;screen row 14
	LDA	$8258,Y		;screen row 15
	EOR	#%10000000
	STA	$8258,Y		;screen row 15
	LDA	$8280,Y		;screen row 16
	EOR	#%10000000
	STA	$8280,Y		;screen row 16
	LDA	$82A8,Y		;screen row 17
	EOR	#%10000000
	STA	$82A8,Y		;screen row 17
	LDA	$82D0,Y		;screen row 18
	EOR	#%10000000
	STA	$82D0,Y		;screen row 18
	LDA	$82F8,Y		;screen row 19
	EOR	#%10000000
	STA	$82F8,Y		;screen row 19
	LDA	$8320,Y		;screen row 20
	EOR	#%10000000
	STA	$8320,Y		;screen row 20
	INY
	CPY	#33
	BEQ	EMPF2
	JMP	EMPF1
EMPF2:	RTS

;This routine animates the tile #204 (water) 
;and also tile 148 (trash compactor)
ANIMATE_WATER:
	LDA	ANIMATE
	CMP	#1
	BEQ	AW00
	RTS
AW00:	INC	WATER_TIMER
	LDA	WATER_TIMER
	CMP	#20
	BEQ	AW01
	RTS
AW01:	LDA	#0
	STA	WATER_TIMER
	LDA	TILE_DATA_BR+204
	STA	WATER_TEMP1
	LDA	TILE_DATA_MM+204
	STA	TILE_DATA_BR+204
	STA	TILE_DATA_BR+221
	LDA	TILE_DATA_TL+204
	STA	TILE_DATA_MM+204
	LDA	WATER_TEMP1
	STA	TILE_DATA_TL+204

	LDA	TILE_DATA_BL+204
	STA	WATER_TEMP1
	LDA	TILE_DATA_MR+204
	STA	TILE_DATA_BL+204
	STA	TILE_DATA_BL+221
	LDA	TILE_DATA_TM+204
	STA	TILE_DATA_MR+204
	LDA	WATER_TEMP1
	STA	TILE_DATA_TM+204
	STA	TILE_DATA_TM+221

	LDA	TILE_DATA_BM+204
	STA	WATER_TEMP1
	LDA	TILE_DATA_ML+204
	STA	TILE_DATA_BM+204
	STA	TILE_DATA_BM+221
	LDA	TILE_DATA_TR+204
	STA	TILE_DATA_ML+204
	LDA	WATER_TEMP1
	STA	TILE_DATA_TR+204
	STA	TILE_DATA_TR+221

	;now do trash compactor
	LDA	TILE_DATA_TR+148
	STA	WATER_TEMP1
	LDA	TILE_DATA_TM+148
	STA	TILE_DATA_TR+148
	LDA	TILE_DATA_TL+148
	STA	TILE_DATA_TM+148
	LDA	WATER_TEMP1
	STA	TILE_DATA_TL+148

	LDA	TILE_DATA_MR+148
	STA	WATER_TEMP1
	LDA	TILE_DATA_MM+148
	STA	TILE_DATA_MR+148
	LDA	TILE_DATA_ML+148
	STA	TILE_DATA_MM+148
	LDA	WATER_TEMP1
	STA	TILE_DATA_ML+148

	LDA	TILE_DATA_BR+148
	STA	WATER_TEMP1
	LDA	TILE_DATA_BM+148
	STA	TILE_DATA_BR+148
	LDA	TILE_DATA_BL+148
	STA	TILE_DATA_BM+148
	LDA	WATER_TEMP1
	STA	TILE_DATA_BL+148
	;Now do HVAC fan
	LDA	HVAC_STATE
	CMP	#0
	BEQ	HVAC1
	LDA	#$CD
	STA	TILE_DATA_MM+196
	STA	TILE_DATA_TL+201
	LDA	#$CE
	STA	TILE_DATA_ML+197
	STA	TILE_DATA_TM+200
	LDA	#$A0
	STA	TILE_DATA_MR+196	
	STA	TILE_DATA_BM+196	
	STA	TILE_DATA_BL+197
	STA	TILE_DATA_TR+200
	LDA	#0
	STA	HVAC_STATE
	JMP	HVAC2
HVAC1:
	LDA	#$A0
	STA	TILE_DATA_MM+196
	STA	TILE_DATA_TL+201
	STA	TILE_DATA_ML+197
	STA	TILE_DATA_TM+200
	LDA	#$C2
	STA	TILE_DATA_MR+196
	STA	TILE_DATA_TR+200
	LDA	#$C0
	STA	TILE_DATA_BM+196	
	STA	TILE_DATA_BL+197
	LDA	#1
	STA	HVAC_STATE
HVAC2:	;now do cinema screen tiles
	;FIRST COPY OLD LETTERS TO THE LEFT.
	LDA	TILE_DATA_MR+20	;#2
	STA	TILE_DATA_MM+20	;#1
	LDA	TILE_DATA_ML+21	;#3
	STA	TILE_DATA_MR+20	;#2
	LDA	TILE_DATA_MM+21	;#4
	STA	TILE_DATA_ML+21	;#3
	LDA	TILE_DATA_MR+21	;#5
	STA	TILE_DATA_MM+21	;#4
	LDA	TILE_DATA_ML+22	;#6
	STA	TILE_DATA_MR+21	;#5
	;now insert new character.
	LDY	CINEMA_STATE
	LDA	CINEMA_MESSAGE,Y
	STA	TILE_DATA_ML+22	;#6

	INC	CINEMA_STATE
	LDA	CINEMA_STATE
	CMP	#197
	BNE	CINE2
	LDA	#0
	STA	CINEMA_STATE
CINE2:	;Now animate light on server computers
	LDA	TILE_DATA_MR+143
	CMP	#$D7
	BNE	CINE3
	LDA	#$D1
	JMP	CINE4
CINE3:	LDA	#$D7
CINE4:	STA	TILE_DATA_MR+143
	LDA	#1
	STA	REDRAW_WINDOW
	RTS
WATER_TIMER	!BYTE 00
WATER_TEMP1	!BYTE 00
HVAC_STATE	!BYTE 00
CINEMA_STATE	!BYTE 00

;This is the routine that allows a person to select
;a level and highlights the selection in the information
;display. It is unique to each computer since it writes
;to the screen directly.
ELEVATOR_SELECT:
	JSR	DRAW_MAP_WINDOW
	LDX	UNIT
	LDA	UNIT_D,X	;get max levels
	STA	ELEVATOR_MAX_FLOOR
	;Now draw available levels on screen
	LDY	#0
	LDA	#$31
ELS1:	STA	$83C6,Y
	CLC
	ADC	#01
	INY
	CPY	ELEVATOR_MAX_FLOOR
	BNE	ELS1
	LDA	UNIT_C,X		;what level are we on now?
	STA	ELEVATOR_CURRENT_FLOOR
	;Now highlight current level
	JSR	ELEVATOR_INVERT
	;Now get user input
	LDA	CONTROL	
	CMP	#2
	BNE	ELS5
	JMP	SELS5
ELS5:	;KEYBOARD INPUT
	JSR	$FFE4
	CMP	#$00
	BEQ	ELS5
	CMP	KEY_MOVE_LEFT
	BNE	ELS6
	JSR	ELEVATOR_DEC
	JMP	ELS5
ELS6:	CMP	KEY_MOVE_RIGHT
	BNE	ELS7
	JSR	ELEVATOR_INC
	JMP	ELS5
ELS7:	CMP	#$9D	;CURSOR LEFT
	BNE	ELS8
	JSR	ELEVATOR_DEC
	JMP	ELS5
ELS8:	CMP	#$1D	;CURSOR RIGHT
	BNE	ELS9
	JSR	ELEVATOR_INC
	JMP	ELS5
ELS9:	CMP	#$11	;CURSOR DOWN
	BNE	ELS10
ELS9B:	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	CLEAR_KEY_BUFFER
	RTS
ELS10:	CMP	KEY_MOVE_DOWN
	BEQ	ELS9B
ELS11:	JMP	ELS5
	
SELS5:	;SNES INPUT
	JSR	SNES_CONTROLER_READ
	LDA	NEW_LEFT
	CMP	#1	
	BNE	SELS8
	JSR	ELEVATOR_DEC
	LDA	#0
	STA	NEW_LEFT
	JMP	SELS5
SELS8:	LDA	NEW_RIGHT
	CMP	#1
	BNE	SELS9
	JSR	ELEVATOR_INC
	LDA	#0
	STA	NEW_RIGHT
	JMP	SELS5
SELS9:	LDA	NEW_DOWN
	CMP	#1	
	BNE	SELS10
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	LDA	#15
	STA	KEYTIMER
	LDA	#0
	STA	NEW_DOWN
	RTS
SELS10:	JMP	SELS5

ELEVATOR_MAX_FLOOR	!BYTE 00
ELEVATOR_CURRENT_FLOOR	!BYTE 00

ELEVATOR_INVERT:
	LDY	ELEVATOR_CURRENT_FLOOR
	LDA	$83C5,Y
	EOR	#%10000000
	STA	$83C5,Y	
	RTS
ELEVATOR_INC:
	LDA	ELEVATOR_CURRENT_FLOOR
	CMP	ELEVATOR_MAX_FLOOR
	BNE	ELVIN1
	RTS
ELVIN1:	JSR	ELEVATOR_INVERT
	INC	ELEVATOR_CURRENT_FLOOR
	JSR	ELEVATOR_INVERT
	JSR	ELEVATOR_FIND_XY
	RTS
ELEVATOR_DEC:
	LDA	ELEVATOR_CURRENT_FLOOR
	CMP	#1
	BNE	ELVDE1
	RTS
ELVDE1:	JSR	ELEVATOR_INVERT
	DEC	ELEVATOR_CURRENT_FLOOR
	JSR	ELEVATOR_INVERT
	JSR	ELEVATOR_FIND_XY
	RTS

ELEVATOR_FIND_XY:
	LDX	#32	;start of doors
ELXY1:	LDA	UNIT_TYPE,X
	CMP	#19	;elevator
	BNE	ELXY5
	LDA	UNIT_C,X
	CMP	ELEVATOR_CURRENT_FLOOR
	BNE	ELXY5
	JMP	ELXY10
ELXY5:	INX
	CPX	#48
	BNE	ELXY1
	RTS
ELXY10:	LDA	UNIT_LOC_X,X	;new elevator location
	STA	UNIT_LOC_X	;player location
	SEC
	SBC	#5
	STA	MAP_WINDOW_X
	LDA	UNIT_LOC_Y,X	;new elevator location
	STA	UNIT_LOC_Y	;player location
	DEC	UNIT_LOC_Y
	SEC
	SBC	#4
	STA	MAP_WINDOW_Y
	JSR	DRAW_MAP_WINDOW
	LDA	#17	;elevator sound
	JSR	PLAY_SOUND	;SOUND PLAY
	RTS

SET_CONTROLS:
	LDA	CONTROL
	CMP	#1	;CUSTOM KEYS
	BNE	SETC1
	JSR	SET_CUSTOM_KEYS
	RTS		
SETC1:	;load standard values for key controls
	LDY	#0
SETC2:	LDA	STANDARD_CONTROLS,Y
	STA	KEY_MOVE_UP,Y
	INY
	CPY	#13
	BNE	SETC2
	RTS

STANDARD_CONTROLS:
	!BYTE	56	;MOVE UP
	!BYTE	50	;MOVE DOWN
	!BYTE	52	;MOVE LEFT
	!BYTE	54	;MOVE RIGHT
	!BYTE	87	;FIRE UP
	!BYTE	83	;FIRE DOWN
	!BYTE	65	;FIRE LEFT
	!BYTE	68	;FIRE RIGHT
	!BYTE	60	;CYCLE WEAPONS
	!BYTE	62	;CYCLE ITEMS
	!BYTE	32	;USE ITEM
	!BYTE	90	;SEARCH OBEJCT
	!BYTE	77	;MOVE OBJECT

SET_CUSTOM_KEYS:
	LDA	KEYS_DEFINED
	CMP	#0
	BEQ	SCK00
	RTS
SCK00:	LDA	#<SCR_CUSTOM_KEYS
	STA	$FB
	LDA	#>SCR_CUSTOM_KEYS
	STA	$FC
	JSR	DECOMPRESS_SCREEN
	LDA	#0
	STA	TEMP_A
	LDA	#$81
	STA	$FC
	LDA	#$51
	STA	$FB
SCK01:	JSR	$FFE4
	CMP	#00
	BEQ	SCK01
	LDY	TEMP_A
	STA	KEY_MOVE_UP,Y
	STA	DECNUM
	JSR	DECWRITE
	LDA	$FB
	CLC
	ADC	#40
	STA	$FB
	LDA	$FC
	ADC	#00
	STA	$FC
	INC	TEMP_A
	LDA	TEMP_A
	CMP	#13
	BNE	SCK01
	LDA	#01
	STA	KEYS_DEFINED
	RTS

KEYS_DEFINED		!BYTE	00	;DEFAULT 0

PET_SCREEN_SHAKE:
	LDA	BGTIMER1
	CMP	#1
	BEQ	PSS4
	RTS
PSS4:	LDA	SELECT_TIMEOUT	;shoehorned this into the screenshake routine
	CMP	#0		;this is to prevent accidental double-taps
	BEQ	PSS4A		;on cycle weapons or items.
	DEC	SELECT_TIMEOUT
PSS4A:	JSR	PET_BORDER_FLASH
	LDA	SCREEN_SHAKE
	CMP	#1
	BEQ	PSS0
	RTS
PSS0:	LDY	#0
	LDX	#0
	LDA	#01
	STA	PSS1+1
	LDA	#00
	STA	PSS2+1
	LDA	#$80
	STA	PSS1+2
	STA	PSS2+2
PSS1:	LDA	$8001,X	;self modifying code
PSS2:	STA	$8000,X	;self modifying code
	INX
	CPX	#32
	BNE	PSS1
	LDX	#0
	LDA	PSS1+1
	CLC
	ADC	#40
	STA	PSS1+1
	LDA	PSS1+2
	ADC	#00
	STA	PSS1+2
	LDA	PSS2+1
	CLC
	ADC	#40
	STA	PSS2+1
	LDA	PSS2+2
	ADC	#00
	STA	PSS2+2
	INY
	CPY	#21	
	BNE	PSS1
	LDA	#1
	STA	REDRAW_WINDOW
	RTS

;So, it doesn't really flash the PET border, instead it
;flashes the health screen.
PET_BORDER_FLASH:
	LDA	BORDER
	CMP	#0
	BNE	PBF10
	LDA	FLASH_STATE
	CMP	#0
	BEQ	PBF5
	JMP	PBF20
PBF5:	RTS
PBF10:	;border flash should be active
	LDA	FLASH_STATE
	CMP	#1	;Is it already flashing?
	BNE	PBF11
	RTS
PBF11:	;copy flash message to screen
	LDX	#0
PBF12:	LDA	OUCH1,X
	STA	$82F2,X
	LDA	OUCH2,X
	STA	$831A,X
	LDA	OUCH3,X
	STA	$8342,X
	INX	
	CPX	#6
	BNE	PBF12
	LDA	#1
	STA	FLASH_STATE
	RTS
PBF20:	;Remove message from screen
	LDX	#0
PBF21:	LDA	#32
	STA	$82F2,X
	STA	$831A,X
	STA	$8342,X
	INX	
	CPX	#6
	BNE	PBF21
	LDA	#0
	STA	FLASH_STATE
	RTS

FLASH_STATE	!BYTE 00
OUCH1	!BYTE $CD,$A0,$A0,$A0,$A0,$CE
OUCH2	!BYTE $A0,$8F,$95,$83,$88,$A0
OUCH3	!BYTE $CE,$A0,$A0,$A0,$A0,$CD

;This is actually part of a background routine, but it has to be in the main
;source because the screen effects used are unique on each system.
DEMATERIALIZE:
	LDX	UNIT
	LDA	UNIT_TIMER_B,X
	AND	#%00000001
	CLC
	ADC	#252	;dematerialize tile
	STA	UNIT_TILE
	LDA	UNIT_TIMER_B,X
	AND	#%00001000
	LSR
	LSR
	LSR
	ADC	UNIT_TILE
	STA	UNIT_TILE
	INC	UNIT_TIMER_B,X
	LDA	UNIT_TIMER_B,X
	CMP	#%00010000
	BEQ	DEMA1
	LDA	#1
	STA	UNIT_TIMER_A,X
	LDA	#1
	STA	REDRAW_WINDOW
	JMP	AILP
DEMA1:	;TRANSPORT COMPLETE
	LDA	UNIT_B,X
	CMP	#1		;transport somewhere
	BEQ	DEMA2
	LDA	#2		;this means game over condition
	STA	UNIT_TYPE	;player type
	LDA	#7		;Normal transporter pad
	STA	UNIT_TYPE,X
	JMP	AILP
DEMA2:	LDA	#243
	STA	UNIT_TILE
	LDA	UNIT_C,X	;target X coordinates
	STA	UNIT_LOC_X
	LDA	UNIT_D,X	;target Y coordinates
	STA	UNIT_LOC_Y
	LDA	#7		;Normal transporter pad
	STA	UNIT_TYPE,X
	JSR	CACULATE_AND_REDRAW
	JMP	AILP

ANIMATE_PLAYER:
ANP1:	LDA	UNIT_TILE
	CMP	#243
	BNE	ANP2
	LDA	#247
	STA	UNIT_TILE
	RTS
ANP2:	LDA	#243
	STA	UNIT_TILE
	RTS

RENDER_MAP:
	LDA	#0
	STA	PX
	STA	PY
	LDA	BIGMAP_X
	STA	MAP_X
	LDA	BIGMAP_Y
	STA	MAP_Y
	JSR	CLEAR_SCREEN
DSMP01:	LDA	PX
	CLC
	ADC	BIGMAP_X
	STA	MAP_X
	JSR	GET_TILE_FROM_MAP
	LDX	TILE
	LDA	TILE_ATTRIB,X
	AND	#%00000001	;CAN WE WALK ON IT?
	CMP	#%00000001
	BEQ	DSMP10
	JSR	PIXELPLOT
DSMP10:	INC	PX
	LDA	PX
	CMP	#80
	BNE	DSMP01
	LDA	#0
	STA	PX
	INC	PY
	LDA	PY
	CLC
	ADC	BIGMAP_Y
	STA	MAP_Y
	LDA	PY
	CMP	#50
	BNE	DSMP01
	RTS

DISPLAY_MAP:
	LDA	#15	;MENU BEEP
	JSR	PLAY_SOUND
	JSR	RENDER_MAP
	JSR	CLEAR_KEY_BUFFER
	JSR	CLEAR_SNES_PAD

MAP_KEY_WAIT:
	LDA	BGTIMER2
	CMP	#0
	BNE	MAPS1
	JSR	BLINK_PLAYER
MAPS1:	JSR	SNES_CONTROLER_READ
	LDA	NEW_B
	CMP	#1
	BNE	MAPS2
	JMP	MKW12
MAPS2:	LDA	NEW_A
	CMP	#1
	BNE	MAPS3
	JSR	TOGGLE_PLAYER_ROBOTS
	LDA	#0
	STA	NEW_A
MAPS3:	LDA	NEW_UP
	CMP	#1
	BNE	MAPS4
	JSR	MAP_UP
	LDA	#0
	STA	NEW_UP
MAPS4:	LDA	NEW_DOWN
	CMP	#1
	BNE	MAPS5
	JSR	MAP_DOWN
	LDA	#0
	STA	NEW_DOWN
MAPS5:	LDA	NEW_LEFT
	CMP	#1
	BNE	MAPS6
	JSR	MAP_LEFT
	LDA	#0
	STA	NEW_LEFT
MAPS6:	LDA	NEW_RIGHT
	CMP	#1
	BNE	MKW1
	JSR	MAP_RIGHT
	LDA	#0
	STA	NEW_RIGHT
MKW1:	JSR	$FFE4
	CMP	#$00
	BEQ	MAP_KEY_WAIT
	CMP	KEY_MOVE_RIGHT
	BNE	MKW2
	JSR	MAP_RIGHT
	JMP	MAP_KEY_WAIT
MKW2:	CMP	KEY_MOVE_LEFT
	BNE	MKW3
	JSR	MAP_LEFT
	JMP	MAP_KEY_WAIT
MKW3:	CMP	KEY_MOVE_UP
	BNE	MKW4
	JSR	MAP_UP
	JMP	MAP_KEY_WAIT
MKW4:	CMP	KEY_MOVE_DOWN
	BNE	MKW5
	JSR	MAP_DOWN
	JMP	MAP_KEY_WAIT
MKW5:	CMP	#19	;HOME KEY
	BNE	MKW6
	JSR	TOGGLE_PLAYER_ROBOTS
	JMP	MAP_KEY_WAIT
MKW6:	CMP	#$1D	;CURSOR RIGHT
	BNE	MKW7
	JSR	MAP_RIGHT
	JMP	MAP_KEY_WAIT
MKW7:	CMP	#$9D	;CURSOR LEFT
	BNE	MKW8
	JSR	MAP_LEFT
	JMP	MAP_KEY_WAIT
MKW8:	CMP	#$11	;CURSOR DOWN
	BNE	MKW9
	JSR	MAP_DOWN
	JMP	MAP_KEY_WAIT
MKW9:	CMP	#$91	;CURSOR UP
	BNE	MKW12
	JSR	MAP_UP
	JMP	MAP_KEY_WAIT
MKW12:	;RETURN TO GAME
	LDA	#15	;MENU BEEP
	JSR	PLAY_SOUND
	JSR	DISPLAY_GAME_SCREEN
	JSR	DRAW_MAP_WINDOW	
	JSR	DISPLAY_PLAYER_HEALTH
	JSR	DISPLAY_KEYS
	JSR	DISPLAY_WEAPON
	JSR	DISPLAY_ITEM
	JSR	CLEAR_SNES_PAD
	RTS

TOGGLE_PLAYER_ROBOTS:
	LDA	#15	;MENU BEEP
	JSR	PLAY_SOUND
	LDA	BP_ROBOTS
	CMP	#0	;PLAYER ACTIVE
	BNE	TPR1
	JSR	PIXELUNPLOT
	LDA	#1	;SET ROBOTS ACTIVE
	STA	BP_ROBOTS
	RTS
TPR1:	LDA	#1
	STA	BP_STATUS	;set to clear robot pixels
	JSR	BLINK_ROBOTS
	LDA	#0	;SET PLAYER ACTIVE
	STA	BP_ROBOTS
	RTS

MAP_RIGHT:
	LDA	#17	;SHORT SOUND
	JSR	PLAY_SOUND
	LDA	BIGMAP_X
	CMP	#48
	BEQ	MAPR1
	CLC
	ADC	#16
	STA	BIGMAP_X
	JSR	RENDER_MAP
MAPR1:	RTS

MAP_LEFT:
	LDA	#17	;SHORT SOUND
	JSR	PLAY_SOUND
	LDA	BIGMAP_X
	CMP	#0
	BEQ	MAPL1
	SEC
	SBC	#16
	STA	BIGMAP_X
	JSR	RENDER_MAP
MAPL1:	RTS

MAP_UP:
	LDA	#17	;SHORT SOUND
	JSR	PLAY_SOUND
	LDA	BIGMAP_Y
	CMP	#0
	BEQ	MAPU1
	LDA	#0
	STA	BIGMAP_Y
	JSR	RENDER_MAP
MAPU1:	RTS

MAP_DOWN:
	LDA	#17	;SHORT SOUND
	JSR	PLAY_SOUND
	LDA	BIGMAP_Y
	CMP	#14
	BEQ	MAPD1
	LDA	#14
	STA	BIGMAP_Y
	JSR	RENDER_MAP
MAPD1:	RTS

BLINK_ROBOTS:
	LDA	#1	;First possible robot
	STA	UNIT
BLRB01:	LDX	UNIT
	LDA	UNIT_TYPE,X
	CMP	#0	;does it exist?
	BEQ	BLRB10
	;Check if robot falls within horizontal window area
	LDA	UNIT_LOC_X,X
	CMP	BIGMAP_X
	BCC	BLRB10
	LDA	BIGMAP_X
	CLC
	ADC	#79
	CMP	UNIT_LOC_X,X
	BCC	BLRB10
	;Check if robot falls within vertical window area
	LDA	UNIT_LOC_Y,X
	CMP	BIGMAP_Y
	BCC	BLRB10
	LDA	BIGMAP_Y
	CLC
	ADC	#49
	CMP	UNIT_LOC_Y,X
	BCC	BLRB10
	;apparently it falls within, so calculate the screen coordinates. 
	LDA	UNIT_LOC_X,X
	SEC
	SBC	BIGMAP_X
	STA	PX	
	LDA	UNIT_LOC_Y,X
	SEC
	SBC	BIGMAP_Y
	STA	PY
	;Now determine if it is time to turn the pixel on or off
	LDA	BP_STATUS
	CMP	#00
	BEQ	BLRB02
	JSR	PIXELUNPLOT
	JMP	BLRB10
BLRB02:	JSR	PIXELPLOT
BLRB10:	INC	UNIT	;Try for next robot
	LDA	UNIT
	CMP	#28	;MAX ROBOTS
	BNE	BLRB01
	LDA	BP_STATUS
	EOR	#%00000001
	STA	BP_STATUS
	RTS

BLINK_PLAYER:
	LDA	#20
	STA	BGTIMER2
	LDA	BP_ROBOTS
	CMP	#0
	BEQ	BPL5
	JMP	BLINK_ROBOTS
BPL5:	;first determine if it is in the map window (X)
	LDA	UNIT_LOC_X
	CMP	BIGMAP_X
	BCC	BLPL2
	LDA	BIGMAP_X
	CLC
	ADC	#79
	CMP	UNIT_LOC_X
	BCC	BLPL2
	;now determine if it is in the map window (Y)
	LDA	UNIT_LOC_Y
	CMP	BIGMAP_Y
	BCC	BLPL2
	LDA	BIGMAP_Y
	CLC
	ADC	#49
	CMP	UNIT_LOC_Y
	BCC	BLPL2
	;it's inside, so show the dot
	LDA	UNIT_LOC_X
	SEC
	SBC	BIGMAP_X
	STA	PX	
	LDA	UNIT_LOC_Y
	SEC
	SBC	BIGMAP_Y
	STA	PY
	LDA	BP_STATUS
	CMP	#00
	BEQ	BLPL1
	JSR	PIXELUNPLOT
	LDA	#00
	STA	BP_STATUS
	RTS
BLPL1:	JSR	PIXELPLOT
	LDA	#01
	STA	BP_STATUS
BLPL2:	RTS
BP_STATUS	!BYTE	00
BP_ROBOTS	!BYTE	00	;0=PLAYER 1=ROBOTS
BIGMAP_X	!BYTE	16	;SCROLL POSITION X FOR FULL SCREEN MAP
BIGMAP_Y	!BYTE	00	;SCROLL POSITION Y FOR FULL SCREEN MAP

; The following routine clears the screen
; it is C64 specific.

CLEAR_SCREEN:
	LDA	#$20	
	LDX	#$00
CS01:	STA	$8000,X
	STA	$8100,X
	STA	$8200,X
	INX
	CPX	#$00
	BNE	CS01
CS02:	STA	$8300,X
	INX
	CPX	#$E8
	BNE	CS02
	RTS

XLOC	!BYTE	$00	;X Coordinate (0-39)
PCHAR	!BYTE	$00	;Character (0-255)

; The following routine takes the coordinates in 
; PX and PY and plots a pixel on the screen.

PIXELPLOTFIND:
	;Set screen RAM location in $FB and $FC
	LDA	PX
	LSR			;divide by 2
	STA	XLOC
	LDX	PY
	LDA	LEFTSCREEN_L,X
	STA	$FB
	LDA	LEFTSCREEN_H,X
	STA	$FC
	CLC
	LDA	$FB
	ADC	XLOC
	STA	$FB
	BCC	PCADR2
	INC	$FC
PCADR2:	
	;Find out what character is already there and convert
	;it over to a 4-bit binary number
	LDY	#$00
	LDX	#$00
	LDA	($FB),Y		
PP01	CMP	PIXELMAP,X
	BEQ	PP02
	INX
	CPX 	#$10
	BEQ	PP02
	JMP	PP01
PP02	STX	PIXEL
	;now figure out which of the 4 locations we are working with
	;and store that in PIXEL2
	LDA	PX
	AND	#%00000001
	CMP	#%00000001	;is it even or odd X position?
	BEQ	PP03
	LDA	#%00000010
	JMP	PP04
PP03	LDA	#%00000001
PP04	STA	PIXEL2
	LDA	PY
	AND	#%00000001
	CMP	#%00000001	;is it even or odd Y position?
	BEQ	PP05
	ASL	PIXEL2
	ASL	PIXEL2	
PP05	RTS

PX	!BYTE	$00	; X-Location (0-79)
PY	!BYTE	$00	; Y-Location (0-49)
PIXEL	!BYTE	$00	; CURRENT 4-BIT PIXEL
PIXEL2	!BYTE	$00	; which segment are we addressing?
;The following routine allows the user to select
;a new working color from a friendly screen.

PIXELPLOT:	
	JSR	PIXELPLOTFIND
	LDA	PIXEL2	;new location
	ORA	PIXEL	;add it to old
	TAX
	LDA	PIXELMAP,X
	LDY	#$00
	STA	($FB),Y		; plot char
	RTS

PIXELUNPLOT:
	JSR	PIXELPLOTFIND
	LDA	PIXEL2	;new location
	EOR	#%11111111
	AND	PIXEL	;subtract it from old
	TAX
	LDA	PIXELMAP,X
	LDY	#$00
	STA	($FB),Y		; plot char
	RTS

;The following tables are used to quickly find the left-most
;address of the text screen.  It is PET specific

LEFTSCREEN_H:
	!BYTE	$80	;ROW 00
	!BYTE	$80	;ROW 00
	!BYTE	$80	;ROW 01
	!BYTE	$80	;ROW 01
	!BYTE	$80	;ROW 02
	!BYTE	$80	;ROW 02
	!BYTE	$80	;ROW 03
	!BYTE	$80	;ROW 03
	!BYTE	$80	;ROW 04
	!BYTE	$80	;ROW 04
	!BYTE	$80	;ROW 05
	!BYTE	$80	;ROW 05
	!BYTE	$80	;ROW 06
	!BYTE	$80	;ROW 06
	!BYTE	$81	;ROW 07
	!BYTE	$81	;ROW 07
	!BYTE	$81	;ROW 08
	!BYTE	$81	;ROW 08
	!BYTE	$81	;ROW 09
	!BYTE	$81	;ROW 09
	!BYTE	$81	;ROW 10
	!BYTE	$81	;ROW 10
	!BYTE	$81	;ROW 11
	!BYTE	$81	;ROW 11
	!BYTE	$81	;ROW 12
	!BYTE	$81	;ROW 12
	!BYTE	$82	;ROW 13
	!BYTE	$82	;ROW 13
	!BYTE	$82	;ROW 14
	!BYTE	$82	;ROW 14
	!BYTE	$82	;ROW 15
	!BYTE	$82	;ROW 15
	!BYTE	$82	;ROW 16
	!BYTE	$82	;ROW 16
	!BYTE	$82	;ROW 17
	!BYTE	$82	;ROW 17
	!BYTE	$82	;ROW 18
	!BYTE	$82	;ROW 18
	!BYTE	$82	;ROW 19
	!BYTE	$82	;ROW 19
	!BYTE	$83	;ROW 20
	!BYTE	$83	;ROW 20
	!BYTE	$83	;ROW 21
	!BYTE	$83	;ROW 21
	!BYTE	$83	;ROW 22
	!BYTE	$83	;ROW 22
	!BYTE	$83	;ROW 23
	!BYTE	$83	;ROW 23
	!BYTE	$83	;ROW 24
	!BYTE	$83	;ROW 24

LEFTSCREEN_L:
	!BYTE	$00	;ROW 00
	!BYTE	$00	;ROW 00
	!BYTE	$28	;ROW 01
	!BYTE	$28	;ROW 01
	!BYTE	$50	;ROW 02
	!BYTE	$50	;ROW 02
	!BYTE	$78	;ROW 03
	!BYTE	$78	;ROW 03
	!BYTE	$A0	;ROW 04
	!BYTE	$A0	;ROW 04
	!BYTE	$C8	;ROW 05
	!BYTE	$C8	;ROW 05
	!BYTE	$F0	;ROW 06
	!BYTE	$F0	;ROW 06
	!BYTE	$18	;ROW 07
	!BYTE	$18	;ROW 07
	!BYTE	$40	;ROW 08
	!BYTE	$40	;ROW 08
	!BYTE	$68	;ROW 09
	!BYTE	$68	;ROW 09
	!BYTE	$90	;ROW 10
	!BYTE	$90	;ROW 10
	!BYTE	$B8	;ROW 11
	!BYTE	$B8	;ROW 11
	!BYTE	$E0	;ROW 12
	!BYTE	$E0	;ROW 12
	!BYTE	$08	;ROW 13
	!BYTE	$08	;ROW 13
	!BYTE	$30	;ROW 14
	!BYTE	$30	;ROW 14
	!BYTE	$58	;ROW 15
	!BYTE	$58	;ROW 15
	!BYTE	$80	;ROW 16
	!BYTE	$80	;ROW 16
	!BYTE	$A8	;ROW 17
	!BYTE	$A8	;ROW 17
	!BYTE	$D0	;ROW 18
	!BYTE	$D0	;ROW 18
	!BYTE	$F8	;ROW 19
	!BYTE	$F8	;ROW 19
	!BYTE	$20	;ROW 20
	!BYTE	$20	;ROW 20
	!BYTE	$48	;ROW 21
	!BYTE	$48	;ROW 21
	!BYTE	$70	;ROW 22
	!BYTE	$70	;ROW 22
	!BYTE	$98	;ROW 23
	!BYTE	$98	;ROW 23
	!BYTE	$C0	;ROW 24
	!BYTE	$C0	;ROW 24

;The following data is for representing each of the
;PETSCII block characters as an 4-bit binary number
;arranged as following:
; 33332222
; 33332222
; 33332222
; 33332222
; 11110000
; 11110000
; 11110000
; 11110000

PIXELMAP:
	!BYTE	$20	
	!BYTE	$6C	
	!BYTE	$7B	
	!BYTE	$62
	!BYTE	$7C
	!BYTE	$E1
	!BYTE	$FF
	!BYTE	$FE
	!BYTE	$7E
	!BYTE	$7F
	!BYTE	$61
	!BYTE	$FC
	!BYTE	$E2
	!BYTE	$FB
	!BYTE	$EC
	!BYTE	$A0

PLAY_SOUND:
	;check if music is playing
	LDY	MUSIC_ON
	CPY	#0
	BEQ	PSND1
	LDY	SOUND_EFFECT
	CPY	#$FF	;no sound effect currently being played
	BNE	PSND1
	LDY	CUR_PATTERN_L	
	STY	PATTERN_L_TEMP	
	LDY	CUR_PATTERN_H
	STY	PATTERN_H_TEMP	
	LDY	DATA_LINE
	STY	DATA_LINE_TEMP
	LDY	TEMPO
	STY	TEMPO_TEMP
PSND1:	;check if we should play new effect.
	LDY	SOUND_EFFECT
	CPY	#$FF	;no sound effect currently being played
	BEQ	PSND2
	CMP	SOUND_EFFECT
	BCC	PSND2	;Prioritize sounds that have lower number.
	BEQ	PSND2
	RTS
PSND2:	;Now process sound effect.
	TAY		;Get waiting sound# from accumulator
	LDA	SOUND_LIBRARY_L,Y
	STA	CUR_PATTERN_L
	LDA	SOUND_LIBRARY_H,Y
	STA	CUR_PATTERN_H
	STY	SOUND_EFFECT
	LDA	#0
	STA	DATA_LINE
	RTS
PATTERN_L_TEMP:	!BYTE 00
PATTERN_H_TEMP:	!BYTE 00
DATA_LINE_TEMP:	!BYTE 00
TEMPO_TEMP:	!BYTE 00

SOUND_LIBRARY_L:
	!BYTE	<SND_EXPLOSION		;sound 0
	!BYTE	<SND_EXPLOSION		;sound 1
	!BYTE	<SND_MEDKIT		;sound 2
	!BYTE	<SND_EMP		;sound 3
	!BYTE	<SND_MAGNET		;sound 4
	!BYTE	<SND_SHOCK		;sound 5
	!BYTE	<SND_MOVE_OBJ		;sound 6
	!BYTE	<SND_SHOCK		;sound 7
	!BYTE	<SND_PLASMA		;sound 8
	!BYTE	<SND_PISTOL		;sound 9
	!BYTE	<SND_ITEM_FOUND		;sound 10
	!BYTE	<SND_ERROR		;sound 11
	!BYTE	<SND_CYCLE_WEAPON	;sound 12
	!BYTE	<SND_CYCLE_ITEM		;sound 13
	!BYTE	<SND_DOOR		;sound 14
	!BYTE	<SND_MENU_BEEP		;sound 15
	!BYTE	<SND_SHORT_BEEP		;sound 16
	!BYTE	<SND_SHORT_BEEP		;sound 17
	!BYTE	<WIN_MUSIC		;sound 18	
	!BYTE	<LOSE_MUSIC		;sound 19

SOUND_LIBRARY_H:
	!BYTE	>SND_EXPLOSION		;sound 0
	!BYTE	>SND_EXPLOSION		;sound 1
	!BYTE	>SND_MEDKIT		;sound 2
	!BYTE	>SND_EMP		;sound 3
	!BYTE	>SND_MAGNET		;sound 4
	!BYTE	>SND_SHOCK		;sound 5
	!BYTE	>SND_MOVE_OBJ		;sound 6
	!BYTE	>SND_SHOCK		;sound 7
	!BYTE	>SND_PLASMA		;sound 8
	!BYTE	>SND_PISTOL		;sound 9
	!BYTE	>SND_ITEM_FOUND		;sound 10
	!BYTE	>SND_ERROR		;sound 11
	!BYTE	>SND_CYCLE_WEAPON	;sound 12
	!BYTE	>SND_CYCLE_ITEM		;sound 13
	!BYTE	>SND_DOOR		;sound 14
	!BYTE	>SND_MENU_BEEP		;sound 15
	!BYTE	>SND_SHORT_BEEP		;sound 16
	!BYTE	>SND_SHORT_BEEP		;sound 17
	!BYTE	>WIN_MUSIC		;sound 18	
	!BYTE	>LOSE_MUSIC		;sound 19
;0 explosion
;1 small explosion
;2 medkit
;3 emp
;4 haywire
;5 evilbot
;6 move
;7 electric shock
;8 plasma gun
;9 fire pistol
;10 item found
;11 error
;12 change weapons
;13 change items
;14 door
;15 menu beep
;16 walk
;17 sfx (short beep)
;18 sfx

MUSIC_ROUTINE:
	LDA	SOUND_EFFECT
	CMP	#$FF
	BNE	PS10
	LDA	MUSIC_ON
	CMP	#1
	BEQ	PS10
	RTS
PS10:	LDA	TEMPO_TIMER
	CMP	#0
	BEQ	PS15
	DEC	TEMPO_TIMER
	RTS
PS15:	LDY	DATA_LINE
	LDA	(CUR_PATTERN_L),Y
	CMP	#0		;blank line (do nothing)	
	BNE	PS20
	LDA	TEMPO
	STA	TEMPO_TIMER	;reset timer to wait for next line
	INC	DATA_LINE
	RTS
PS20:	CMP	#37		;END pattern
	BNE	PS21
	JMP	STOP_SONG
PS21:	CMP	#38
	BNE	PS22
	LDA	#0
	STA	ARP_MODE
	STA	$E84A	;RESET SOUND TO ZERO
	STA	$E848
PS22:	CMP	#38		;IS IT A TEMPO COMMAND?	
	BCC	PS23
	CMP	#49		;COMMAND IS BETWEEN 39 AND 49 (TEMPO ADJUST)
	BCS	PS23
	SEC
	SBC	#38
	STA	TEMPO
	INC	DATA_LINE
	RTS
PS23:	;PLAY A NOTE
	TAY
	LSR
	LSR
	LSR
	LSR
	LSR
	LSR
	STA	ARP_MODE
	TYA
	AND	#%00111111
	STA	CHORD_ROOT
	TAY
	LDA	NOTE_FREQ,Y
	STA	$E848
	LDA	NOTE_OCTAVE,Y
	STA	$E84A
	LDA	TEMPO
	STA	TEMPO_TIMER	;reset timer to wait for next line
	INC	DATA_LINE
	RTS

STOP_SONG:	;actually, stop sound effect.
	LDA	#0
	STA	$E848	;turn off sound
	STA	$E84A	;turn off sound
	LDA	#$FF
	STA	SOUND_EFFECT
	LDA	TEMPO
	STA	TEMPO_TIMER
	;now restore music info for continued play.
	LDA	MUSIC_ON
	CMP	#1
	BEQ	STSN1
	RTS
STSN1:	LDY	PATTERN_L_TEMP	
	STY	CUR_PATTERN_L	
	LDY	PATTERN_H_TEMP	
	STY	CUR_PATTERN_H
	LDY	DATA_LINE_TEMP	
	STY	DATA_LINE
	LDY	TEMPO_TEMP	
	STY	TEMPO
	RTS

;this is only called from the IRQ routine and runs 60 times per second if
;an arp is active.  
;*NOTE* it is deactivated here because no music or sound effects were 
;composed to use this feature, so might as well disable it.
;CYCLE_ARP:
;	INC	ARP_STEP
;	LDA	ARP_STEP
;	CMP	#3
;	BNE	CARP1
;	LDA	#0
;	STA	ARP_STEP
;CARP1:	LDA	ARP_MODE
;	CMP	#1
;	BNE	CARP2
;	;MAJOR	CHORD
;	LDA	CHORD_ROOT
;	LDY	ARP_STEP
;	CLC
;	ADC	MAJ_CHART,Y
;	TAY
;	LDA	NOTE_FREQ,Y
;	STA	$E848
;	LDA	NOTE_OCTAVE,Y
;	STA	$E84A
;	RTS
;CARP2:	CMP	#2
;	BNE	CARP3
;	;MINOR	CHORD
;	LDA	CHORD_ROOT
;	LDY	ARP_STEP
;	CLC
;	ADC	MIN_CHART,Y
;	TAY
;	LDA	NOTE_FREQ,Y
;	STA	$E848
;	LDA	NOTE_OCTAVE,Y
;	STA	$E84A
;	RTS
;CARP3:	;SUS4	CHORD
;	LDA	CHORD_ROOT
;	LDY	ARP_STEP
;	CLC
;	ADC	SUS4_CHART,Y
;	TAY
;	LDA	NOTE_FREQ,Y
;	STA	$E848
;	LDA	NOTE_OCTAVE,Y
;	STA	$E84A
;	RTS
;ARP_STEP	!BYTE 00
;MAJ_CHART	!BYTE 00,04,07
;MIN_CHART	!BYTE 00,03,07
;SUS4_CHART	!BYTE 00,05,07

!SOURCE "BACKGROUND_TASKS.ASM"

;These are the included binary files that contain the screen
;image for the main editor.
INTRO_TEXT:
	!BYTE	$60,$20,$02,$4e,$60,$63,$0a,$4e,$65,$60,$20,$05,$e9,$ce,$20,$20,$e9,$ce,$60,$20
	!BYTE	$0d,$cd,$60,$a0,$09,$ce,$20,$65,$60,$20,$05,$66,$a0,$20,$20,$66,$a0,$60,$20,$0d
	!BYTE	$a0,$13,$14,$01,$12,$14,$20,$07,$01,$0d,$05,$a0,$20,$65,$60,$20,$04,$e9,$66,$ce
	!BYTE	$a0,$a0,$66,$ce,$ce,$60,$20,$0c,$a0,$13,$05,$0c,$05,$03,$14,$20,$0d,$01,$10,$a0
	!BYTE	$20,$65,$60,$20,$03,$e9,$a0,$e3,$60,$a0,$02,$e3,$60,$ce,$02,$60,$20,$0b,$a0,$04
	!BYTE	$09,$06,$06,$09,$03,$15,$0c,$14,$19,$a0,$20,$65,$60,$20,$02,$e9,$60,$66,$06,$ce
	!BYTE	$ce,$a0,$60,$20,$0b,$a0,$03,$0f,$0e,$14,$12,$0f,$0c,$13,$20,$20,$a0,$20,$65,$60
	!BYTE	$20,$02,$66,$3a,$4d,$60,$3a,$02,$4e,$3a,$66,$a0,$a0,$60,$20,$02,$e9,$ce,$20,$20
	!BYTE	$e9,$ce,$60,$20,$02,$ce,$60,$a0,$09,$cd,$4e,$60,$20,$03,$66,$55,$43,$4d,$3a,$4e
	!BYTE	$43,$49,$66,$a0,$a0,$60,$20,$02,$66,$a0,$20,$20,$66,$a0,$60,$20,$13,$66,$42,$51
	!BYTE	$48,$3a,$42,$51,$48,$66,$a0,$69,$60,$20,$02,$66,$a0,$20,$20,$66,$a0,$60,$20,$02
	!BYTE	$70,$60,$40,$02,$73,$0d,$01,$10,$6b,$60,$40,$02,$6e,$60,$20,$03,$66,$4a,$46,$4b
	!BYTE	$3a,$4a,$46,$4b,$66,$ce,$60,$20,$03,$66,$ce,$a0,$a0,$66,$a0,$20,$20,$0b,$09,$0c
	!BYTE	$0c,$20,$01,$0c,$0c,$20,$08,$15,$0d,$01,$0e,$13,$60,$20,$03,$60,$66,$06,$a0,$a0
	!BYTE	$60,$20,$03,$60,$66,$04,$69,$60,$20,$14,$66,$60,$d0,$04,$66,$a0,$a0,$60,$20,$05
	!BYTE	$66,$a0,$20,$20,$60,$43,$14,$66,$60,$d0,$04,$66,$a0,$69,$60,$43,$05,$66,$a0,$43
	!BYTE	$43,$60,$3a,$14,$60,$66,$06,$ce,$a0,$a0,$ce,$60,$3a,$03,$66,$a0,$60,$3a,$16,$e9
	!BYTE	$a0,$a0,$e7,$d0,$ce,$60,$a0,$02,$ce,$a0,$60,$3a,$03,$66,$a0,$60,$3a,$15,$e9,$60
	!BYTE	$a0,$03,$e3,$60,$a0,$02,$ce,$a0,$a0,$60,$3a,$03,$66,$a0,$60,$3a,$0b,$e9,$ce,$df
	!BYTE	$60,$3a,$06,$60,$66,$08,$d5,$c0,$c9,$60,$3a,$03,$66,$ce,$df,$60,$3a,$09,$e9,$e3
	!BYTE	$cd,$ce,$60,$a0,$06,$66,$51,$60,$66,$04,$51,$66,$dd,$ce,$e3,$60,$a0,$02,$ce,$a0
	!BYTE	$cd,$ce,$60,$3a,$09,$a0,$d1,$e7,$60,$66,$10,$dd,$60,$66,$04,$a0,$d1,$e7,$69,$60
	!BYTE	$3a,$09,$5f,$a0,$ce,$60,$3a,$07,$60,$66,$08,$ca,$c0,$cb,$60,$3a,$02,$5f,$e4,$69
	!BYTE	$60,$3a,$0b,$66,$a0,$3a,$e9,$a0,$a0,$ce,$3a,$e9,$a0,$a0,$ce,$e9,$a0,$a0,$ce,$66
	!BYTE	$e9,$a0,$a0,$ce,$e9,$a0,$a0,$ce,$e9,$a0,$a0,$ce,$60,$3a,$0a,$66,$a0,$3a,$60,$66
	!BYTE	$02,$ce,$ce,$60,$66,$02,$a0,$60,$66,$02,$ce,$ce,$60,$66,$02,$a0,$60,$66,$02,$69
	!BYTE	$60,$66,$02,$69,$60,$3a,$0a,$66,$a0,$3a,$66,$ce,$a0,$66,$ce,$66,$a0,$66,$a0,$66
	!BYTE	$ce,$a0,$66,$ce,$66,$a0,$66,$a0,$3a,$66,$a0,$3a,$66,$ce,$a0,$ce,$60,$3a,$0a,$66
	!BYTE	$a0,$3a,$60,$66,$02,$ce,$ce,$66,$a0,$66,$a0,$60,$66,$02,$ce,$ce,$66,$a0,$66,$a0
	!BYTE	$3a,$66,$a0,$3a,$60,$66,$02,$a0,$60,$3a,$0a,$66,$a0,$3a,$66,$a0,$3a,$66,$a0,$66
	!BYTE	$ce,$66,$a0,$66,$ce,$a0,$66,$69,$66,$ce,$66,$a0,$3a,$66,$a0,$3a,$e9,$a0,$66,$a0
	!BYTE	$60,$3a,$0a,$66,$a0,$3a,$66,$69,$3a,$66,$69,$60,$66,$02,$69,$60,$66,$02,$69,$3a
	!BYTE	$60,$66,$02,$69,$3a,$66,$69,$3a,$60,$66,$02,$69,$3a

SCR_TEXT:
	!BYTE	$60,$20,$20,$5d,$17,$05,$01,$10,$0f,$0e,$60,$20,$20,$5d,$60,$20,$26,$5d,$60,$20
	!BYTE	$26,$5d,$60,$20,$26,$5d,$60,$20,$26,$5d,$60,$20,$26,$6b,$60,$40,$05,$60,$20,$20
	!BYTE	$5d,$20,$09,$14,$05,$0d,$60,$20,$21,$5d,$60,$20,$26,$5d,$60,$20,$26,$5d,$60,$20
	!BYTE	$26,$5d,$60,$20,$26,$5d,$60,$20,$26,$6b,$60,$40,$05,$60,$20,$20,$5d,$20,$0b,$05
	!BYTE	$19,$13,$60,$20,$21,$5d,$60,$20,$26,$5d,$60,$20,$26,$6b,$60,$40,$05,$60,$20,$20
	!BYTE	$5d,$60,$20,$26,$5d,$60,$20,$26,$5d,$60,$20,$05,$73,$09,$0e,$06,$0f,$12,$0d,$01
	!BYTE	$14,$09,$0f,$0e,$6b,$60,$40,$13,$5b,$60,$40,$05,$60,$20,$20,$5d,$08,$05,$01,$0c
	!BYTE	$14,$08,$60,$20,$20,$5d,$60,$20,$26,$5d,$60,$71,$05

SCR_ENDGAME:
	!BYTE	$55, $60, $40, $03, $73, $01, $14, $14, $01, $03, $0B, $20, $0F, $06, $20
	!BYTE	$14, $08, $05, $20, $10, $05, $14, $13, $03, $09, $09, $20, $12, $0F, $02
	!BYTE	$0F, $14, $13, $6B, $60, $40, $03, $49, $5D, $60, $20, $25, $5D, $5D, $60
	!BYTE	$20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60
	!BYTE	$20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $0A, $13, $03, $05
	!BYTE	$0E, $01, $12, $09, $0F, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $06, $05, $0C, $01, $10, $13, $05, $04, $20, $14, $09, $0D
	!BYTE	$05, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $02
	!BYTE	$12, $0F, $02, $0F, $14, $13, $20, $12, $05, $0D, $01, $09, $0E, $09, $0E
	!BYTE	$07, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D, $5D, $20, $20, $13
	!BYTE	$05, $03, $12, $05, $14, $13, $20, $12, $05, $0D, $01, $09, $0E, $09, $0E
	!BYTE	$07, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $08
	!BYTE	$04, $09, $06, $06, $09, $03, $15, $0C, $14, $19, $3A, $60, $20, $11, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $4A, $60, $40, $25, $4B

SCR_CUSTOM_KEYS:
	!BYTE	$55, $60, $40, $03, $73, $01, $14, $14, $01, $03, $0B, $20, $0F, $06, $20
	!BYTE	$14, $08, $05, $20, $10, $05, $14, $13, $03, $09, $09, $20, $12, $0F, $02
	!BYTE	$0F, $14, $13, $6B, $60, $40, $03, $49, $5D, $60, $20, $25, $5D, $5D, $60
	!BYTE	$20, $25, $5D, $5D, $60, $20, $03, $10, $12, $05, $13, $13, $20, $14, $08
	!BYTE	$05, $20, $0B, $05, $19, $13, $20, $19, $0F, $15, $20, $17, $09, $13, $08
	!BYTE	$20, $14, $0F, $20, $15, $13, $05, $60, $20, $03, $5D, $5D, $60, $20, $04
	!BYTE	$06, $0F, $12, $20, $14, $08, $05, $20, $06, $0F, $0C, $0C, $0F, $17, $09
	!BYTE	$0E, $07, $20, $06, $15, $0E, $03, $14, $09, $0F, $0E, $13, $60, $20, $05
	!BYTE	$5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25
	!BYTE	$5D, $5D, $60, $20, $06, $0D, $0F, $16, $05, $20, $15, $10, $3A, $60, $20
	!BYTE	$16, $5D, $5D, $60, $20, $04, $0D, $0F, $16, $05, $20, $04, $0F, $17, $0E
	!BYTE	$3A, $60, $20, $16, $5D, $5D, $60, $20, $04, $0D, $0F, $16, $05, $20, $0C
	!BYTE	$05, $06, $14, $3A, $60, $20, $16, $5D, $5D, $60, $20, $03, $0D, $0F, $16
	!BYTE	$05, $20, $12, $09, $07, $08, $14, $3A, $60, $20, $16, $5D, $5D, $60, $20
	!BYTE	$06, $06, $09, $12, $05, $20, $15, $10, $3A, $60, $20, $16, $5D, $5D, $60
	!BYTE	$20, $04, $06, $09, $12, $05, $20, $04, $0F, $17, $0E, $3A, $60, $20, $16
	!BYTE	$5D, $5D, $60, $20, $04, $06, $09, $12, $05, $20, $0C, $05, $06, $14, $3A
	!BYTE	$60, $20, $16, $5D, $5D, $60, $20, $03, $06, $09, $12, $05, $20, $12, $09
	!BYTE	$07, $08, $14, $3A, $60, $20, $16, $5D, $5D, $20, $03, $19, $03, $0C, $05
	!BYTE	$20, $17, $05, $01, $10, $0F, $0E, $13, $3A, $60, $20, $16, $5D, $5D, $60
	!BYTE	$20, $02, $03, $19, $03, $0C, $05, $20, $09, $14, $05, $0D, $13, $3A, $60
	!BYTE	$20, $16, $5D, $5D, $60, $20, $05, $15, $13, $05, $20, $09, $14, $05, $0D
	!BYTE	$3A, $60, $20, $16, $5D, $5D, $20, $13, $05, $01, $12, $03, $08, $20, $0F
	!BYTE	$02, $0A, $05, $03, $14, $3A, $60, $20, $16, $5D, $5D, $60, $20, $02, $0D
	!BYTE	$0F, $16, $05, $20, $0F, $02, $0A, $05, $03, $14, $3A, $60, $20, $16, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$4A, $60, $40, $25, $4B

CINEMA_MESSAGE:
	!SCR"coming soon: space balls 2 - the search for more money, "
	!SCR"attack of the paperclips: clippy's revenge, "
	!SCR"it came from planet earth, "
	!SCR"rocky 5000, all my circuits the movie, "
	!SCR"conan the librarian, and more! " 


;PLASMA Gun (PET / C64)
WEAPON1A:	!BYTE	$2c,$20,$20,$20,$20,$2c
WEAPON1B:	!BYTE	$e2,$f9,$ef,$e4,$66,$66
WEAPON1C:	!BYTE	$20,$20,$20,$20,$5f,$df
WEAPON1D:	!BYTE	$20,$20,$20,$20,$20,$20

;PISTOL (PET / C64)
PISTOL1A:	!BYTE	$20,$20,$20,$20,$20,$20
PISTOL1B:	!BYTE	$20,$68,$62,$62,$62,$20
PISTOL1C:	!BYTE	$20,$20,$20,$5f,$df,$20
PISTOL1D:	!BYTE	$20,$20,$20,$20,$20,$20

;Time Bomb  (PET / C64)
TBOMB1A	!BYTE	$20,$20,$55,$2a,$20,$20
TBOMB1B	!BYTE	$20,$55,$66,$49,$20,$20
TBOMB1C	!BYTE	$20,$42,$20,$48,$20,$20
TBOMB1D	!BYTE	$20,$4a,$46,$4b,$20,$20

;EMP (PET / C64)
EMP1A	!BYTE	$20,$55,$43,$43,$49,$20
EMP1B	!BYTE	$66,$df,$55,$49,$e9,$66
EMP1C	!BYTE	$66,$69,$4a,$4b,$5f,$66
EMP1D	!BYTE	$20,$4a,$46,$46,$4b,$20

;Magnet (PET / C64)
MAG1A	!BYTE	$4d,$70,$6e,$70,$6e,$4e
MAG1B	!BYTE	$20,$42,$42,$48,$48,$20
MAG1C	!BYTE	$63,$42,$4a,$4b,$48,$63
MAG1D	!BYTE	$4e,$4a,$46,$46,$4b,$4d

;Medkit	(PET / C64)
MED1A	!BYTE	$20,$55,$43,$43,$49,$20
MED1B	!BYTE	$20,$A0,$A0,$A0,$A0,$20
MED1C	!BYTE	$20,$A0,$EB,$F3,$A0,$20
MED1D	!BYTE	$20,$E4,$E4,$E4,$E4,$20

;Mighty Foot (PET / C64)
;!BYTE	$1f,$df,$20,$20,$e4,$e4
;!BYTE	$1f,$ba,$e5,$a8,$e7,$a0
;!BYTE	$20,$20,$20,$20,$20,$e4
;!BYTE	$06,$0f,$0f,$14,$e9,$ba

;This array holds the data for the PET's handshake line to
;determine what value to place there, based on what note is
;being played from 1 to 88.  There is a zero at the beginning
;as a placeholder to simplify the math in the routine.

NOTE_FREQ:
	!BYTE	00	;placeholder for zero
	!BYTE	251	;Note 01	B	(Lowest note the PET can produce)
	;octave 4
	!BYTE	238	;Note 02	C
	!BYTE	224	;Note 03	C#
	!BYTE	210	;Note 04	D
	!BYTE	199	;Note 05	D#
	!BYTE	188	;Note 06	E
	!BYTE	177	;Note 07	F
	!BYTE	168	;Note 08	F#
	!BYTE	158	;Note 09	G
	!BYTE	149	;Note 10	G#
	!BYTE	140	;Note 11	A
	!BYTE	133	;Note 12	A#
	!BYTE	251	;Note 13	B
	;octave 5
	!BYTE	238	;Note 14	C
	!BYTE	224	;Note 15	C#
	!BYTE	210	;Note 16	D
	!BYTE	199	;Note 17	D#
	!BYTE	188	;Note 18	E
	!BYTE	177	;Note 19	F
	!BYTE	168	;Note 20	F#
	!BYTE	158	;Note 21	G
	!BYTE	149	;Note 22	G#
	!BYTE	140	;Note 23	A
	!BYTE	133	;Note 24	A#
	!BYTE	251	;Note 25	B
	;octave 6
	!BYTE	238	;Note 26	C
	!BYTE	224	;Note 27	C#
	!BYTE	210	;Note 28	D
	!BYTE	199	;Note 29	D#
	!BYTE	188	;Note 30	E
	!BYTE	177	;Note 31	F
	!BYTE	168	;Note 32	F#
	!BYTE	158	;Note 33	G
	!BYTE	149	;Note 34	G#
	!BYTE	140	;Note 35	A
	!BYTE	133	;Note 36	A#	(Highest note the PET can produce)

;This array holds the data for the PET's handshake line to
;determine what value to place there, based on what note is
;being played from 1 to 88.  There is a zero at the beginning
;as a placeholder to simplify the math in the routine.

NOTE_OCTAVE:
	!BYTE	00	;placeholder for zero
	!BYTE	15	;Note 01	B	(Lowest note the PET can produce)
	;octave 4
	!BYTE	15	;Note 02	C
	!BYTE	15	;Note 03	C#
	!BYTE	15	;Note 04	D
	!BYTE	15	;Note 05	D#
	!BYTE	15	;Note 06	E
	!BYTE	15	;Note 07	F
	!BYTE	15	;Note 08	F#
	!BYTE	15	;Note 09	G
	!BYTE	15	;Note 10	G#
	!BYTE	15	;Note 11	A
	!BYTE	15	;Note 12	A#
	!BYTE	51	;Note 13	B
	;octave 5
	!BYTE	51	;Note 14	C
	!BYTE	51	;Note 15	C#
	!BYTE	51	;Note 16	D
	!BYTE	51	;Note 17	D#
	!BYTE	51	;Note 18	E
	!BYTE	51	;Note 19	F
	!BYTE	51	;Note 20	F#
	!BYTE	51	;Note 21	G
	!BYTE	51	;Note 22	G#
	!BYTE	51	;Note 23	A
	!BYTE	51	;Note 24	A#
	!BYTE	85	;Note 25	B
	;octave 6
	!BYTE	85	;Note 26	C
	!BYTE	85	;Note 27	C#
	!BYTE	85	;Note 28	D
	!BYTE	85	;Note 29	D#
	!BYTE	85	;Note 30	E
	!BYTE	85	;Note 31	F
	!BYTE	85	;Note 32	F#
	!BYTE	85	;Note 33	G
	!BYTE	85	;Note 34	G#
	!BYTE	85	;Note 35	A
	!BYTE	85	;Note 36	A#	(Highest note the PET can produce)

SND_EXPLOSION:
	!BYTE $27, $0B, $0D, $07, $08, $0B, $03, $07, $03, $05, $06, $0C, $0E, $02, $01
	!BYTE $06, $08, $0D, $0B, $01, $05, $06, $07, $0A, $0A, $03, $06, $25
SND_MEDKIT:
	!BYTE $29, $09, $04, $01, $25
SND_EMP:
	!BYTE $27, $02, $07, $0C, $11, $16, $1B, $20, $1B, $16, $11, $0C, $07, $02, $25
SND_MAGNET:
	!BYTE $2A, $17, $0D, $12, $23, $0F, $15, $09, $17, $03, $25
SND_SHOCK:
	!BYTE $27, $26, $0E, $26, $0E, $26, $0E, $26, $0E, $26, $04
	!BYTE $26, $04, $26, $04, $26, $04, $25
SND_MOVE_OBJ:
	!BYTE $28, $02, $26, $0E, $26, $25
SND_PLASMA:	
	!BYTE $27, $07, $13, $06, $12, $07, $13, $06, $12
	!BYTE $07, $13, $06, $12, $07, $13, $25 
SND_PISTOL:
	!BYTE $27, $24, $23, $22, $21, $20, $1F, $25
SND_ITEM_FOUND:
	!BYTE $28, $09, $15, $0B, $17, $0D, $19
	!BYTE $0E, $02, $0E, $02, $0E, $25
SND_ERROR:
	!BYTE $27, $01, $26, $01, $26, $01, $26, $01, $25
SND_CYCLE_WEAPON:
	!BYTE $27, $15, $13, $11, $0F, $0D, $15, $25
SND_CYCLE_ITEM:
	!BYTE $27, $0D, $0C, $0B, $0A, $0B, $0C, $0D, $25
SND_DOOR: 
	!BYTE $28, $0B, $0D, $0E, $10, $12, $13, $15, $25
SND_MENU_BEEP:
	!BYTE $28, $0E, $04, $25
SND_SHORT_BEEP:
	!BYTE $28, $11, $25
INTRO_MUSIC:
	!BYTE	$2D, $06, $12, $0F, $03, $0F, $0D, $08, $12, $03, $06, $08, $0A, $03, $12
	!BYTE   $03, $09, $2D, $03, $00, $01, $01, $03, $26, $06, $26, $00, $00, $01, $26
	!BYTE   $03, $01, $00, $00, $03, $00, $01, $01, $03, $26, $06, $26, $00, $00, $01
	!BYTE   $26, $08, $06, $00, $00, $03, $00, $01, $01, $03, $26, $06, $26, $00, $00
	!BYTE   $01, $26, $03, $01, $00, $00, $08, $0A, $08, $00, $06, $00, $03, $01, $03
	!BYTE   $26, $06, $26, $03, $26, $00, $00, $0F, $00, $0D, $0F, $26, $00, $12, $00
	!BYTE   $00, $00, $0D, $0F, $12, $00, $0F, $26, $0F, $00, $0D, $0F, $26, $00, $12
	!BYTE   $00, $00, $00, $0D, $0F, $14, $00, $12, $00, $0F, $00, $0D, $0F, $26, $00
	!BYTE   $12, $00, $00, $00, $0D, $0F, $14, $00, $0F, $00, $14, $16, $14, $00, $12
	!BYTE   $00, $0F, $0D, $0F, $26, $12, $26, $0F, $26, $00, $00, $0F, $00, $0D, $0F
	!BYTE   $26, $00, $12, $00, $00, $00, $0D, $0F, $12, $26, $0F, $26, $0F, $00, $0D
	!BYTE   $0F, $26, $00, $12, $00, $00, $00, $0D, $0F, $12, $00, $14, $00, $0F, $00
	!BYTE   $0D, $0F, $26, $00, $12, $00, $00, $00, $0D, $0F, $12, $00, $0F, $00, $14
	!BYTE   $16, $14, $00, $12, $14, $12, $00, $0F, $12, $0D, $00, $0F, $08, $0A, $0B
	!BYTE   $0F, $04, $01, $04, $0D, $04, $01, $04, $0F, $04, $01, $04, $12, $04, $01
 	!BYTE	$04, $0D, $04, $0F, $04, $12, $04, $01, $04, $0D, $04, $01, $04, $0B, $0A
	!BYTE   $08, $06, $08, $04, $01, $04, $0F, $04, $01, $04, $0D, $04, $01, $04, $0B
	!BYTE   $00
WIN_MUSIC:
	!BYTE   $2C, $07, $00, $09, $00, $0C, $00, $10, $00, $00, $0E, $00, $00, $10, $00
	!BYTE   $11, $00, $00, $10, $00, $00, $11, $00, $13, $00, $00, $00, $00, $00, $25
LOSE_MUSIC:
	!BYTE   $2F, $0D, $00, $0B, $00, $09, $00, $08, $00, $06, $00, $02, $00, $00, $04
	!BYTE   $00, $00, $06, $00, $00, $00, $00, $00, $25
IN_GAME_MUSIC1:
	!BYTE   $30, $01, $03, $04, $06, $08, $00, $06, $04, $06, $26, $0B, $26, $09, $26
	!BYTE   $06, $04, $06, $26, $0B, $26, $09, $26, $04, $03, $04, $26, $09, $26, $08
	!BYTE   $00, $00, $00, $01, $03, $04, $06, $08, $00, $06, $04, $06, $26, $0B, $26
	!BYTE   $09, $26, $06, $04, $06, $26, $0F, $26, $0B, $26, $09, $08, $09, $00, $00
	!BYTE   $00, $08, $00, $00, $00, $09, $00, $14, $00, $15, $00, $0B, $09, $08, $00
	!BYTE   $12, $00, $14, $00, $09, $08, $06, $26, $12, $00, $14, $00, $02, $04, $08
	!BYTE   $09, $08, $06, $08, $00, $00, $00, $09, $00, $14, $00, $15, $00, $0B, $09
	!BYTE   $08, $00, $12, $00, $14, $00, $09, $08, $06, $00, $12, $00, $14, $00, $02
	!BYTE   $06, $0D, $00, $0B, $09, $0B, $00, $00, $00, $01, $03, $04, $06, $08, $00
	!BYTE   $06, $04, $06, $26, $0B, $26, $09, $26, $06, $04, $06, $26, $0B, $26, $09
	!BYTE   $26, $04, $03, $04, $26, $09, $26, $08, $00, $00, $00, $01, $03, $04, $06
	!BYTE   $08, $00, $06, $04, $06, $26, $0B, $26, $09, $26, $06, $04, $06, $26, $0F
	!BYTE   $26, $0B, $26, $09, $08, $09, $00, $00, $00, $08, $00, $00, $26, $08, $00
	!BYTE   $13, $00, $14, $00, $16, $14, $13, $00, $05, $00, $07, $00, $14, $13, $11
	!BYTE   $00, $05, $00, $07, $00, $01, $03, $07, $08, $07, $05, $07, $00, $00, $00
	!BYTE   $08, $00, $13, $00, $14, $00, $0A, $08, $07, $00, $11, $00, $13, $00, $08
	!BYTE   $07, $05, $00, $11, $00, $13, $00, $03, $04, $09, $00, $06, $00, $08, $00
	!BYTE   $00
IN_GAME_MUSIC2:
	!BYTE   $2E, $03, $00, $26, $03, $0F, $00, $00, $03, $00, $00, $0F, $00, $01, $0D
	!BYTE   $02, $0E, $03, $00, $26, $03, $0F, $00, $00, $03, $00, $00, $0F, $00, $01
	!BYTE   $0D, $02, $0E, $0F, $26, $00, $0F, $26, $00, $0F, $26, $00, $0F, $00, $12
	!BYTE   $00, $0F, $26, $0F, $26, $00, $0F, $26, $00, $0F, $26, $00, $0F, $00, $14
	!BYTE   $00, $0F, $26, $0F, $26, $00, $0F, $26, $00, $0F, $26, $00, $0F, $00, $12
	!BYTE   $00, $0F, $00, $0D, $00, $00, $0E, $00, $00, $0F, $30, $00, $00, $26, $00
	!BYTE   $00, $2E, $0F, $26, $00, $0F, $26, $00, $0F, $26, $00, $0F, $00, $12, $00
	!BYTE   $0F, $00, $0F, $26, $00, $0F, $26, $00, $0F, $26, $00, $0F, $00, $14, $00
	!BYTE   $0F, $26, $0F, $26, $00, $0F, $26, $00, $0F, $26, $00, $0F, $00, $12, $00
	!BYTE   $0F, $00, $0D, $00, $00, $0E, $00, $00, $0F, $00, $00, $00, $0E, $00, $0D
	!BYTE   $00, $0C, $26, $0C, $00, $00, $0E, $00, $00, $0F, $30, $00, $00, $00, $26
	!BYTE   $00, $00, $00, $2E, $0C, $00, $00, $0E, $00, $00, $11, $30, $00, $00, $00
	!BYTE   $26, $00, $00, $00, $2E, $0C, $00, $00, $0E, $00, $00, $13, $00, $00, $00
	!BYTE   $14, $00, $13, $00, $11, $00, $0C, $00, $00, $0E, $00, $00, $0F, $30, $00
	!BYTE   $00, $00, $26, $00, $00, $00, $2E, $0C, $00, $00, $0E, $00, $00, $11, $30
	!BYTE   $00, $00, $00, $26, $00, $00, $00, $2E, $0C, $00, $00, $0E, $00, $00, $13
	!BYTE   $00, $00, $00, $14, $00, $13, $00, $11, $00, $0F, $00, $0E, $00, $0D, $2E
	!BYTE   $00
IN_GAME_MUSIC3:
	!BYTE   $2C, $02, $00, $09, $00, $0E, $00, $09, $00, $0E, $00, $09, $00, $02, $00
	!BYTE   $09, $00, $0C, $00, $09, $00, $0C, $00, $09, $00, $02, $00, $09, $00, $0E
	!BYTE   $00, $09, $00, $0E, $00, $09, $00, $02, $00, $09, $00, $0C, $00, $09, $00
	!BYTE   $0C, $00, $09, $00, $2F, $0E, $00, $00, $00, $00, $2C, $0C, $00, $00, $00
	!BYTE   $09, $00, $0C, $00, $00, $00, $00, $00, $02, $00, $09, $00, $0C, $00, $00
	!BYTE   $00, $09, $00, $0C, $00, $2F, $0E, $00, $00, $00, $00, $2C, $0C, $00, $09
	!BYTE   $00, $26, $00, $09, $00, $26, $00, $00, $00, $09, $00, $0C, $00, $10, $00
	!BYTE   $11, $00, $10, $00, $0C, $00, $2F, $0E, $00, $00, $00, $00, $2C, $0C, $00
	!BYTE   $00, $00, $09, $00, $0C, $00, $00, $00, $00, $00, $02, $00, $09, $00, $0C
	!BYTE   $00, $00, $00, $09, $00, $0C, $00, $2F, $0E, $00, $00, $00, $00, $2C, $10
	!BYTE   $00, $00, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00, $02, $00, $05
	!BYTE   $00, $07, $00, $09, $00, $07, $00, $0B, $00, $2F, $10, $00, $00, $00, $00
	!BYTE   $2C, $0E, $00, $0C, $00, $26, $00, $0C, $00, $26, $00, $0E, $00, $26, $00
	!BYTE   $0B, $00, $00, $00, $00, $00, $09, $00, $0B, $00, $10, $00, $26, $00, $10
	!BYTE   $00, $12, $00, $26, $00, $17, $00, $26, $00, $15, $00, $00, $00, $00, $00
	!BYTE   $00, $00, $12, $00, $00, $00, $00, $00, $00, $00, $14, $00, $00, $00, $00
	!BYTE   $00, $00, $11, $00, $00, $00, $00, $00, $00, $13, $00, $00, $00, $00, $00
	!BYTE   $00








