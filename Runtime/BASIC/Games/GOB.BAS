   10 MODE 1
   20 M=0:N=0
   30 GOTO 990
   40 DIM CAN(20,20)
   50 COLOUR 3
   60 GOTO 900
   70 XPLY=7:YPLY=7:XCOM=14:YCOM=14:P=254:Q=252 
   80 SPLY=0:SCOM=0:XTAG=10:YTAG=10
   90 MIN=7:MAX=14:COUN=0:TIME=0
   95 CLS:INPUT "COMPUTER SKILL LEVEL ";DCL 
  100 FOR K=1 TO 20
  110 FOR L=1 TO 20
  120 CAN(K,L)=1
  130 PRINT TAB(K,L);CHR$(240)
  140 NEXT:NEXT
  150 FOR Y=MIN TO MAX
  160 FOR X=MIN TO MAX
  170 PRINT TAB(X,Y)"."
  180 COUN=COUN+1
  190 NEXT X
  200 NEXT Y
  210 PXPLY=XPLY:PYPLY=YPLY:PXCOM=XCOM:PYCOM=YCOM
  220 IF CAN(XPLY,YPLY)=1 THEN 720 
  230 IF CAN(XCOM,YCOM)=1 THEN 760  
  240 CTD=0
  250 REPEAT
  260 CTD=CTD+1
  270 IF CAN(XTAG,YTAG)=0 THEN XTAG=RND(MAX-MIN)+MIN:YTAG=RND(MAX-MIN)+MIN 
  280 IF CAN(XTAG,YTAG)=1 THEN CTD=500
  290 UNTIL CTD>=DCL
  300 A$=INKEY$(0)
  310 IF A$="S" THEN N=0:M=0
  320 IF A$="A" THEN M=1:P=252
  330 IF A$="Z" THEN M=2:P=254
  340 IF A$="O" THEN M=3:P=255 
  350 IF A$="P" THEN M=4:P=253  
  360 IF XPLY=XCOM AND YPLY=YCOM AND M=3 THEN M=4:GOTO 400
  370 IF XPLY=XCOM AND YPLY=YCOM AND M=4 THEN M=3
  380 IF XPLY=XCOM AND YPLY=YCOM AND M=1 THEN M=2:GOTO 400
  390 IF XPLY=XCOM AND YPLY=YCOM AND M=2 THEN M=1 
  400 IF XPLY=MIN AND M=3 THEN M=4 
  410 IF XPLY=MAX AND M=4 THEN M=3
  420 IF YPLY=MIN AND M=1 THEN M=2
  430 IF YPLY=MAX AND M=2 THEN M=1
  440 IF M=1 THEN YPLY=YPLY-1
  450 IF M=2 THEN YPLY=YPLY+1
  460 IF M=3 THEN XPLY=XPLY-1 
  470 IF M=4 THEN XPLY=XPLY+1  
  480 IF XCOM=XTAG AND YCOM=YTAG THEN XTAG=RND(MAX-MIN)+MIN:YTAG=RND(MAX-MIN)+MIN
  490 IF XCOM<XTAG THEN XCOM=XCOM+1:Q=253:GOTO 570
  500 IF XCOM>XTAG THEN XCOM=XCOM-1:Q=255:GOTO 570
  510 IF YCOM<YTAG THEN YCOM=YCOM+1:Q=254 
  520 IF YCOM>YTAG THEN YCOM=YCOM-1:Q=252 
  530 IF XPLY=XCOM AND YPLY=YCOM AND Q=253 THEN XCOM=XCOM-1 
  540 IF XPLY=XCOM AND YPLY=YCOM AND Q=255 THEN XCOM=XCOM+1
  550 IF XPLY=XCOM AND YPLY=YCOM AND Q=254 THEN YCOM=YCOM-1
  560 IF XPLY=XCOM AND YPLY=YCOM AND Q=252 THEN YCOM=YCOM+1
  570 COLOUR 0:PRINT TAB(PXPLY,PYPLY);"O":PRINT TAB(PXCOM,PYCOM);"O" 
  580 COLOUR 1:PRINT TAB(XPLY,YPLY);CHR$(P)
  590 COLOUR 2:PRINT TAB(XCOM,YCOM);CHR$(Q)
  600 COLOUR 3
  610 FOR TD=1 TO 10000:NEXT TD
  620 PRINT TAB(22,1)"TIME :";75-TIME DIV 100;" " 
  630 PRINT TAB(22,5)"PLY:";SPLY 
  640 PRINT TAB(22,6)"COM:";SCOM   
  650 IF TIME>7500 THEN GOTO 800 
  660 IF SPLY+SCOM<COUN THEN 210   
  690 MAX=MAX+1:MIN=MIN-1
  700 IF MIN=1 THEN CLS:GOTO 830
  710 GOTO 100
  720 CAN(XPLY,YPLY)=0
  730 SPLY=SPLY+1
  740 COLOUR RND(3):PRINT TAB(22,10)"YUM!"
  750 GOTO 230
  760 CAN(XCOM,YCOM)=0
  770 SCOM=SCOM+1
  780 COLOUR RND(3):PRINT TAB(22,11)"YUM!"
  790 GOTO 300
  800 CLS
  810 PRINT "TIME UP!!!!!!!!"
  820 GOTO 830
  830 PRINT "SCORES"
  840 PRINT "PLAYER:";SPLY
  850 PRINT "COMPUTER:";SCOM
  860 SPLY=0:SCOM=0
  870 FOR K=1 TO 500000:NEXT
  875 REPEAT:A$=INKEY$(0):UNTIL A$=""
  880 PRINT "PRESS A KEY":A$=GET$  
  890 CLS
  900 PRINT TAB(10,7)"GOBBLE"
  910 PRINT TAB(6,10)"BY ANDREW (SCORPION) BROOMFIELD" 
  920 PRINT:PRINT:PRINT "A,Z,O,P UP,DOWN,LEFT,RIGHT"
  930 PRINT "PRESS A KEY"
  940 PRINT "Q TO QUIT"
  950 G$=GET$
  960 IF G$="Q" THEN MODE7:END
  970 CLS
  980 GOTO 70
  990 VDU 23,252,129,66,36,102,126,60,190,129
 1000 VDU 23,253,129,90,60,112,112,60,90,129
 1010 VDU 23,254,129,90,60,126,102,36,66,129
 1020 VDU 23,255,129,90,60,14,14,60,90,129
 1030 VDU 23,240,255,255,255,255,255,255,255,255
 1040 GOTO 40
