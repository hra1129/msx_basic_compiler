100 DEFINT A-Z:SCREEN 5:COLOR 15,4,7:CLS
110 SET PAGE 0,1
120 FOR I=0 TO 1000:VPOKE I, I AND 255:NEXT:BEEP
130 K$=INPUT$(1)
140 SET PAGE 1,1
150 K$=INPUT$(1):SET PAGE 0,2
160 FOR I=0 TO 1000:VPOKE I, I AND 255:NEXT:BEEP
170 K$=INPUT$(1)
180 SET PAGE 2,2
190 K$=INPUT$(1)
