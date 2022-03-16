  ; A78 Header v3.1
  ; 
  ; Use this file to add an a78 header via the source code of your ROM.
  ;
  ; _Implementation Notes_
  ;
  ; * Include this header near the beginning of your DASM source, but after
  ;   your initial ROM ORG statement.
  ; * Change the fields withn the file to describe your game's hardware
  ;   requirements to emulators and flash carts.
  ; * All unused/reserved bits and bytes must be set to zero.


.ROMSIZE = $20000                  ; Update with your total ROM size.

  ; Auto-header ROM allocation follows. If the current address is page aligned,
  ; we backup 128 bytes. This may cause issues if you use a different ORG+RORG
  ; at the start of your ROM - in that case, account for the 128 bytes of
  ; header within your game ROM start ORG+RORG statements.

    if ( . & $FF ) = 0             ; Check if we're at an even page.
        ORG  (. - 128),0           ; If so, go -128 bytes, for header space.
    else
        ORG .,0                    ; In case zero-fill wasn't specified
    endif                          ; orginally.

    SEG     ROM

.HEADER = .

  ; Format detection - do not modify.
    DC.B    3                  ; 0          header major version
    DC.B    "ATARI7800"        ; 1..16      header magic string - zero pad


    ORG .HEADER+$11,0
    DC.B    "Game Name Here"   ; 17..48     cartridge title string - zero pad


    ORG .HEADER+$31,0
    DC.B    (.ROMSIZE>>24)     ; 49..52     cartridge ROM size
    DC.B    (.ROMSIZE>>16&$FF)
    DC.B    (.ROMSIZE>>8&$FF)
    DC.B    (.ROMSIZE&$FF)


    DC.B    %00000000          ; 53         cartridge type A
    DC.B    %00000000          ; 54         cartridge type B
    ; _Cartridge Type A_
    ;    bit 7 ; POKEY @ $0800 - $09FF
    ;    bit 6 ; EXRAM/M2                   (halt banked RAM)
    ;    bit 5 ; BANKSET
    ;    bit 4 ; SOUPER
    ;    bit 3 ; YM2151 @ $0461 - $0462 
    ;    bit 2 ; POKEY @ $0440 - $044F 
    ;    bit 1 ; ABSOLUTE
    ;    bit 0 ; ACTIVISION
    ; _Cartridge Type B_
    ;    bit 7 ; EXRAM/A8                   (mirror RAM)
    ;    bit 6 ; POKEY @ $0450 - $045F 
    ;    bit 5 ; EXRAM/X2                   (hotspot banked RAM)
    ;    bit 4 ; EXFIX                      (2nd last bank @ $4000)
    ;    bit 3 ; EXROM                      (ROM @ $4000)
    ;    bit 2 ; EXRAM                      (RAM @ $4000)
    ;    bit 1 ; SUPERGAME
    ;    bit 0 ; POKEY @ $4000 - $7FFF


    DC.B    1                  ; 55         controller 1 device type
    DC.B    1                  ; 56         controller 2 device type
    ;    0 = none
    ;    1 = 7800 joystick
    ;    2 = lightgun
    ;    3 = paddle
    ;    4 = trakball
    ;    5 = 2600 joystick
    ;    6 = 2600 driving
    ;    7 = 2600 keypad
    ;    8 = ST mouse
    ;    9 = Amiga mouse
    ;   10 = AtariVox
    ;   11 = SNES2Atari


    DC.B    %00000000          ; 57         tv type
    ;    bit 1 ; 0:component,1:composite
    ;    bit 0 ; 0:NTSC,1:PAL


    DC.B    %00000000          ; 58         save peripheral
    ;    bit 1 ; SaveKey/AtariVox
    ;    bit 0 ; High Score Cart (HSC)


    ORG     .HEADER+62,0
    DC.B    %00000000          ; 62         external irq source
    ;    bit 4 ; POKEY @ $0800 - $09FF
    ;    bit 3 ; YM2151 @ $0461 - $0462
    ;    bit 2 ; POKEY @ $0440 - $044F
    ;    bit 1 ; POKEY @ $0450 - $045F
    ;    bit 0 ; POKEY @ $4000 - $7FFF

    DC.B    %00000000          ; 63         slot passthrough device
    ;    bit 0 ; XM module


    ORG     .HEADER+100,0       ; 100..127  footer magic string
    DC.B    "ACTUAL CART DATA STARTS HERE"

