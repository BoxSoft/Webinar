                              PROGRAM

                              MAP
ShowButtons                     PROCEDURE
ShowLists                       PROCEDURE
                              END

  CODE
  ShowButtons()
  

ShowButtons                   PROCEDURE
Window                          WINDOW('Icons on Buttons'),AT(,,699,401),GRAY,SYSTEM,MAX,ICON('Sample.ico'),FONT('Segoe UI',9,,FONT:regular)
                                  ENTRY(@s20),AT(89,268,0,0),USE(?ENTRY1)
                                  BUTTON('H=12'),AT(2,2,80,12),USE(?BUTTON1),ICON('Sample.ico'),LEFT
                                  BUTTON('H=14'),AT(2,18,80,14),USE(?BUTTON1:2),ICON('Sample.ico'),LEFT
                                  BUTTON('H=16'),AT(2,36,80,16),USE(?BUTTON1:3),ICON('Sample.ico'),LEFT
                                  BUTTON('H=18'),AT(2,55,80,18),USE(?BUTTON1:4),ICON('Sample.ico'),LEFT
                                  BUTTON('H=20'),AT(2,77,80,20),USE(?BUTTON1:5),ICON('Sample.ico'),LEFT
                                  BUTTON('H=22'),AT(2,100,80,22),USE(?BUTTON1:6),ICON('Sample.ico'),LEFT
                                  BUTTON('H=24'),AT(2,126,80,24),USE(?BUTTON1:7),ICON('Sample.ico'),LEFT
                                  BUTTON('H=26'),AT(2,154,80,26),USE(?BUTTON1:8),ICON('Sample.ico'),LEFT
                                  BUTTON('H=28'),AT(2,183,80,28),USE(?BUTTON1:9),ICON('Sample.ico'),LEFT
                                  BUTTON('H=30'),AT(2,215,80,30),USE(?BUTTON1:10),ICON('Sample.ico'),LEFT
                                  BUTTON('24x24'),AT(93,2,24,24),USE(?BUTTON1:11),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico')
                                  BUTTON('28x28'),AT(101,50,28,28),USE(?BUTTON1:12),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('28x32'),AT(133,50,28,32),USE(?BUTTON1:13),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('24x28'),AT(121,2,24,28),USE(?BUTTON1:15),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico')
                                  BUTTON('24x32'),AT(149,2,24,32),USE(?BUTTON1:16),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico')
                                  BUTTON('24x36'),AT(177,2,24,36),USE(?BUTTON1:14),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico')
                                  BUTTON('24x40'),AT(205,2,24,40),USE(?BUTTON1:17),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico')
                                  BUTTON('28x36'),AT(165,50,28,36),USE(?BUTTON1:18),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('28x40 Line2'),AT(197,50,28,40),USE(?BUTTON1:19),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('32x32'),AT(117,146,32,32),USE(?BUTTON1:20),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('32x36'),AT(153,146,32,36),USE(?BUTTON1:21),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('32x40 Line2'),AT(189,146,32,40),USE(?BUTTON1:22),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('36x40 Line2'),AT(181,194,36,40),USE(?BUTTON1:23),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('36x36'),AT(141,194,36,36),USE(?BUTTON1:24),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('40x40 Line2'),AT(173,241,40,40),USE(?BUTTON1:25),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('H=32'),AT(2,249,80,32),USE(?BUTTON1:26),ICON('Sample.ico'),LEFT
                                  BUTTON('30x40 Line2'),AT(159,98,30,40),USE(?BUTTON1:27),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('30x36'),AT(125,98,30,36),USE(?BUTTON1:28),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('30x32'),AT(91,98,30,32),USE(?BUTTON1:29),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('24x44 Line2'),AT(233,2,24,44),USE(?BUTTON1:30),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico')
                                  BUTTON('28x44 Line2'),AT(229,50,28,44),USE(?BUTTON1:31),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('30x44 Line2'),AT(227,98,30,44),USE(?BUTTON1:32),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('32x44 Line2'),AT(225,146,32,44),USE(?BUTTON1:33),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('36x44 Line2'),AT(221,194,36,44),USE(?BUTTON1:34),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('40x44 Line2'),AT(217,242,40,44),USE(?BUTTON1:35),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('30x42 Line2'),AT(193,98,30,42),USE(?BUTTON1:36),FONT('Tahoma',7),ICON('Sample.ico')
                                  BUTTON('30x42 Line2'),AT(367,98,30,42),USE(?BUTTON1:37),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('40x44 Line2'),AT(391,242,40,44),USE(?BUTTON1:38),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('36x44 Line2'),AT(395,194,36,44),USE(?BUTTON1:39),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('32x44 Line2'),AT(399,146,32,44),USE(?BUTTON1:40),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('30x44 Line2'),AT(401,98,30,44),USE(?BUTTON1:41),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('28x44 Line2'),AT(403,50,28,44),USE(?BUTTON1:42),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('24x44 Line2'),AT(407,2,24,44),USE(?BUTTON1:43),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico'),FLAT
                                  BUTTON('30x32'),AT(265,98,30,32),USE(?BUTTON1:44),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('30x36'),AT(299,98,30,36),USE(?BUTTON1:45),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('30x40 Line2'),AT(333,98,30,40),USE(?BUTTON1:46),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('40x40 Line2'),AT(347,241,40,40),USE(?BUTTON1:47),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('36x36'),AT(315,194,36,36),USE(?BUTTON1:48),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('36x40 Line2'),AT(355,194,36,40),USE(?BUTTON1:49),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('32x40 Line2'),AT(363,146,32,40),USE(?BUTTON1:50),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('32x36'),AT(327,146,32,36),USE(?BUTTON1:51),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('32x32'),AT(291,146,32,32),USE(?BUTTON1:52),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('28x40 Line2'),AT(371,50,28,40),USE(?BUTTON1:53),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('28x36'),AT(339,50,28,36),USE(?BUTTON1:54),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('24x40'),AT(379,2,24,40),USE(?BUTTON1:55),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico'),FLAT
                                  BUTTON('24x36'),AT(351,2,24,36),USE(?BUTTON1:56),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico'),FLAT
                                  BUTTON('24x32'),AT(323,2,24,32),USE(?BUTTON1:57),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico'),FLAT
                                  BUTTON('24x28'),AT(295,2,24,28),USE(?BUTTON1:58),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico'),FLAT
                                  BUTTON('28x32'),AT(307,50,28,32),USE(?BUTTON1:59),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('28x28'),AT(275,50,28,28),USE(?BUTTON1:60),FONT('Tahoma',7),ICON('Sample.ico'),FLAT
                                  BUTTON('24x24'),AT(267,2,24,24),USE(?BUTTON1:61),FONT('Tahoma',7,,FONT:regular),ICON('Sample.ico'),FLAT
                                  BUTTON('H=34'),AT(2,284,80,34),USE(?BUTTON1:62),ICON('Sample.ico'),LEFT
                                  BUTTON('H=36'),AT(2,322,80,36),USE(?BUTTON1:63),ICON('Sample.ico'),LEFT
                                  BUTTON('H=38'),AT(2,361,80,38),USE(?BUTTON1:64),ICON('Sample.ico'),LEFT
                                  BUTTON('H=40'),AT(445,6,135,40),USE(?BUTTON1:65),ICON('Sample.ico'),LEFT
                                  BUTTON('H=42'),AT(445,50,135,42),USE(?BUTTON1:66),ICON('Sample.ico'),LEFT
                                  BUTTON('H=44'),AT(445,94,135,44),USE(?BUTTON1:67),ICON('Sample.ico'),LEFT
                                  BUTTON('H=135'),AT(445,190,250,135),USE(?BUTTON1:68),ICON('Sample.ico'),LEFT
                                  BUTTON('H=46'),AT(445,141,135,46),USE(?BUTTON1:69),ICON('Sample.ico'),LEFT
                                END

Done                            BOOL(FALSE)
  CODE
  LOOP UNTIL Done
    OPEN(Window)
    ACCEPT
      CASE EVENT()
      OF EVENT:Accepted
        ShowLists()
      OF EVENT:CloseWindow OROF EVENT:CloseDown
        Done = True
        BREAK
      END
    END
    CLOSE(Window)
  END
  
ShowLists                     PROCEDURE
                              MAP
InitQueue                       PROCEDURE
                              END
Q                               QUEUE
Value                             STRING(1)
Value_Icon                        LONG
                                END
LineHeight                      BYTE(9)
Window                          WINDOW('Lists'),AT(,,325,344),GRAY,SYSTEM,FONT('Segoe UI',10)
                                  SPIN(@s20),AT(4,4),USE(LineHeight)
                                  LIST,AT(4,23,317,318),USE(?List),VSCROLL,FROM(Q),FORMAT('20L(2)|_MJ')
                                END

  CODE
  InitQueue()
  OPEN(Window)
  ?List{PROP:IconList, 1} = '~Sample.ico'
  ?List{PROP:LineHeight}  = LineHeight
  ACCEPT
    CASE FIELD()
    OF ?LineHeight
      CASE EVENT()
      OF EVENT:Accepted OROF EVENT:NewSelection
        ?List{PROP:LineHeight} = LineHeight
      END
    END
  END

InitQueue                     PROCEDURE
X                               BYTE
  CODE
  LOOP X = 1 TO 26
    CLEAR(Q)
    Q.Value      = CHR(VAL('A')+X-1)
    Q.Value_Icon = 1
    ADD(Q)
  END
