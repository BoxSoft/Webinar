!Examples of LIST Sorting by Carl Barnes for CIDC 2019.
!Using PROPLIST:HasSortColumn added in C9 versus the previous way of Alert(MouseLEFT)
!The new way just ?ListFiles{PROPLIST:HasSortColumn}=1 then you get EVENT:HeaderPressed
!
!Web Annoucement: https://clarionsharp.com/blog/c9listcolor/
!LibSrc has BrwExt.CLW has SortHeaderClassType. See my other example.
!There is very little in Help see: FORMAT() Other List Box Properties
!
!    PROPLIST:HdrSortTextColor    
!    PROPLIST:HdrSortBackColor    
!    PROPLIST:SortTextColor
!    PROPLIST:SortBackColor
!
!    These 4 properties are to define text and background colors for cells and headers of a 
!    column set as a sort column. These properties have no effect if sort column is not 
!    turned on. This can be done by setting PROPLIST:HasSortColumn property to TRUE. 
!    If it is set to TRUE, clicking on a header for any visible column triggers the modal 
!    event EVENT:HeaderPressed.
!    In response to this event the program can either execute CYCLE (to ignore the event), 
!    or re-sort the source of listbox data (a QUEUE usually).  If CYCLE isn't called the RTL
!    changes the current sort column to the one which the header has been clicked. The 
!    header and cells of the current sort column are re-drawn using colors defined using 
!    the 4 properties from above. 
!
!---------------------------------------------------------------------------
  PROGRAM
  INCLUDE 'KEYCODES.CLW'
  MAP
ListSort:HasSortColumn          PROCEDURE()  
ListSort:HasSortColumn_ColumnReorder    PROCEDURE()  !Columns NOT in Queue Order
ListSortWithAlertMouseLeft      PROCEDURE()  
    MODULE('Win32')
        GetTempPath(LONG nBufferLength,*CSTRING lpTempPath),LONG,PASCAL,DLL(1),RAW,NAME('GetTempPathA'),PROC
    END          
  END
WinTempBS  CSTRING(256)
  CODE       
  IF ~GetTempPath(SIZE(WinTempBS),WinTempBS) THEN Message('Failed GetTempPath').
  SYSTEM{PROP:PropVScroll}=1
  IF START(ListSort:HasSortColumn_ColumnReorder).
  IF START(ListSort:HasSortColumn).
  IF START(ListSortWithAlertMouseLeft).

!================================================================================
ListSort:HasSortColumn    PROCEDURE()
QNdx    LONG,AUTO
DirQ    QUEUE(FILE:Queue),PRE(DirQ)
        END ! DirQ:Name  DirQ:ShortName(8.3?)  DirQ:Date  DirQ:Time  DirQ:Size  DirQ:Attrib
SortNow     SHORT
SortLast    SHORT
SortNowWho  STRING(128)
SortLastWho STRING(128)

FilesWindow WINDOW('Sort with "PROPLIST:HasSortColumn"'),AT(1,1,343,180),FONT('Segoe UI',9,,FONT:regular),SYSTEM,GRAY,RESIZE
              STRING('Column Sorting done with C9 PROPLIST:HasSortColumn and EVENT:HeaderPressed'),AT(2,2),USE(?HowSort)
              LIST,AT(1,15),USE(?ListFiles),FULL,VSCROLL,TIP('Click heads to sort, Click again to reverse'), |
                FORMAT('120L(1)|M~Name~@s255@52L(1)|M~Short Name~@s13@40R(1)|M~Date~C(0)@d1@40R(1)|M~Time~C(0)@T4@56R(1)|M~Size~C(0)@n13@16L(1)|M~Attr~@n3@') ,|
                FROM(DirQ)
            END
!WndPrvwCls   CBWndPreviewClass            
    CODE
    FREE(DirQ)
    DIRECTORY(DirQ,WinTempBS&'*.*',ff_:NORMAL)
    LOOP QNdx = RECORDS(DirQ) TO 1 BY -1            !--Keep directories, Delete files, Case Name
         GET(DirQ,QNdx)
         IF BAND(DirQ:Attrib,FF_:Directory) OR DirQ:Name='.' OR DirQ:Name='..'   !. or .. Dirs
            DELETE(DirQ)
         ELSE
             DirQ:Name=UPPER(DirQ:Name[1]) & DirQ:Name[2 : SIZE(DirQ:Name) ]
             PUT(DirQ)
         END
    END
    OPEN(FilesWindow) 
    0{PROP:Text}=CLIP(0{PROP:Text}) &'  '& WinTempBS & ' (' & RECORDS(DirQ) &' records) '
    
    !To setup for new LIST HasSortColumn MUST set PROPLIST:HasSortColumn=1  
    ?ListFiles{PROPLIST:HasSortColumn}=1                                    !Colors  are OPTIONAL
    ?ListFiles{PROPLIST:HdrSortBackColor} = COLOR:HIGHLIGHT                 !Color Header Background    
    ?ListFiles{PROPList:HdrSortTextColor} = COLOR:HIGHLIGHTtext             !Color Header Text
    ?ListFiles{PROPList:SortBackColor}    = 80000018h !COLOR:InfoBackground !Color List Background
    ?ListFiles{PROPList:SortTextColor}    = 80000017h !COLOR:InfoText       !Color List Text   

!   ?List{PROPLIST:HasSortColumn}=1 will cause the LIST to get EVENT:HeaderPressed when a Header is Clicked
!   The column will be colored, unless you CYCLE.
!   No Sorting is done by the RTL, that is all up to the developer
!   You can force the colored column using ?ListFiles{PROPLIST:SortColumn}=#
!   LibSrc BrwExt.CLW uses this    

    ACCEPT
       CASE EVENT()
       OF EVENT:OpenWindow
          ?ListFiles{PROPList:MouseDownField}=1     !Force Initial Sort Column - You can Write this Property
          DO TakeEVENT:HeaderPressed                !Use Click Column code to Sort Queue and set variable
          ?ListFiles{PROPLIST:SortColumn}=1         !Color column 1 as sorted
          ?ListFiles{PROP:Selected}=1               !First time select row 1 of sorted 
       END
       CASE FIELD()
       OF ?ListFiles
          CASE EVENT()
          OF EVENT:HeaderPressed
             !CYCLE would prevent the RTL from Coloring the Sort Column.
             !      Can also just set Column with ?ListFiles{PROPLIST:SortColumn}=
!             IF ?ListFiles{PROPList:MouseDownZone} = LISTZONE:right THEN CYCLE. !N/A HasSortColumn lets Resize zone work
             DO TakeEVENT:HeaderPressed 

          END ! Case EVENT()
       END ! Case FIELD()
    END !ACCEPT
    CLOSE(FilesWindow)

TakeEVENT:HeaderPressed ROUTINE
    GET(DirQ, CHOICE(?ListFiles))                  !To preserve selected row
    SortNow=?ListFiles{PROPList:MouseDownField}    !This is really Column and NOT Q Field
    SortNow=?ListFiles{PROPLIST:FieldNo,SortNow}   !Now we have Queue Field to use with WHO()
    IF SortNow<>ABS(SortLast) THEN SortLastWho=',' & SortNowWho.
    SortNowWho=CHOOSE(SortNow=SortLast,'-','+') & WHO(DirQ,SortNow)
    0{PROP:Text}='HasSortColumn: SORT (' & SortNow &' /'& SortLast &') ' & CLIP(SortNowWho) & SortLastWho
    SORT(DirQ,CLIP(SortNowWho) & SortLastWho)
    SortLast = CHOOSE(SortNow=ABS(SortLast),-1*SortLast,SortNow) 
    GET(DirQ, DirQ:Name)                           !If no Unique field to GET() then Loop until find it
    ?ListFiles{PROP:Selected}=POINTER(DirQ)        !Preserved the selected record
    DISPLAY
!==========================================================================================

ListSort:HasSortColumn_ColumnReorder    PROCEDURE()
QNdx    LONG,AUTO
DirQ    QUEUE(FILE:Queue),PRE(DirQ)
        END ! DirQ:Name  DirQ:ShortName(8.3?)  DirQ:Date  DirQ:Time  DirQ:Size  DirQ:Attrib
SortNow     SHORT
SortLast    SHORT
SortNowWho  STRING(128)
SortLastWho STRING(128)

FilesWindow WINDOW('#1# Columns not in Order - Sort "PROPLIST:HasSortColumn" '),AT(350,1,343,250),GRAY,SYSTEM,FONT('Segoe UI',9,, |
            FONT:regular),RESIZE
                      STRING('Column 5 Name is Q Field #1#. C9 PROPLIST:HasSortColumn and EVENT:HeaderPressed.'),AT(2,2),USE(?HowSort)
        LIST,AT(1,15),FULL,USE(?ListFiles),VSCROLL,TIP('Click heads to sort, Click again to reverse'), |
                FROM(DirQ),FORMAT('52L(1)|M~Short Name~@s13@#2#40R(1)|M~Date~C(0)@' & |
                'd1@40R(1)|M~Time~C(0)@T4@56R(1)|M~Size~C(0)@n13@120L(1)|M~Name~@s255@#1#')
    END            
    CODE
    FREE(DirQ)
    DIRECTORY(DirQ,WinTempBS&'*.*',ff_:NORMAL)  
    LOOP QNdx = RECORDS(DirQ) TO 1 BY -1        !--Keep directories, Delete files, Case Name
         GET(DirQ,QNdx)
         IF BAND(DirQ:Attrib,FF_:Directory) OR DirQ:Name='.' OR DirQ:Name='..'   !. or .. Dirs
            DELETE(DirQ)
         ELSE
            DirQ:Name=UPPER(DirQ:Name[1]) & DirQ:Name[2 : SIZE(DirQ:Name) ]
            PUT(DirQ)
         END
    END 
    OPEN(FilesWindow) 
    0{PROP:Text}=CLIP(0{PROP:Text}) &'  '& WinTempBS & ' (' & RECORDS(DirQ) &' records) '
    !To setup for new LIST HasSortColumn MUST set PROPLIST:HasSortColumn=1
    ?ListFiles{PROPLIST:HasSortColumn}=1                               
    ?ListFiles{PROPLIST:HdrSortBackColor} = COLOR:HIGHLIGHT                 !Color Header Background    
    ?ListFiles{PROPList:HdrSortTextColor} = COLOR:HIGHLIGHTtext             !Color Header Text
    ?ListFiles{PROPList:SortBackColor}    = 80000018h !COLOR:InfoBackground !Color List Background
    ?ListFiles{PROPList:SortTextColor}    = 80000017h !COLOR:InfoText       !Color List Text     
    ACCEPT
       CASE EVENT()
       OF EVENT:OpenWindow
          ?ListFiles{PROPLIST:SortColumn}    =5     !Color column 5 as sorted, really Q field 1
          ?ListFiles{PROPList:MouseDownField}=5     !Force Initial Sort Column - You can Write this Property
          DO TakeEVENT:HeaderPressed                !Use Click Column code to Sort Queue and set variable
          ?ListFiles{PROP:Selected}=1               !First time select row 1 of sorted 
       END    
       CASE FIELD()
       OF ?ListFiles
          CASE EVENT()
          OF EVENT:HeaderPressed
             DO TakeEVENT:HeaderPressed 

          OF EVENT:NewSelection !DblClick to View 1 File
             IF KEYCODE()=MouseLeft2 THEN
                GET(DirQ,CHOICE(?ListFiles))
                MESSAGE(CLIP(DirQ:Name) &'|'& DirQ:ShortName &'|'& DirQ:Date &'|'& DirQ:Time &'|'& DirQ:Size |
                        &'|'& DirQ:Attrib,'File '&CHOICE(?ListFiles),,,,2)
             END
          END ! Case EVENT()
       END ! Case FIELD()
    END !ACCEPT
    CLOSE(FilesWindow)

TakeEVENT:HeaderPressed ROUTINE
    GET(DirQ, CHOICE(?ListFiles))                  !To preserve selected row
    SortNow=?ListFiles{PROPList:MouseDownField}    !This is really Column and NOT Q Field
    SortNow=?ListFiles{PROPLIST:FieldNo,SortNow}   !This is Required here because Name uses #1#
    IF SortNow<>ABS(SortLast) THEN SortLastWho=',' & SortNowWho.
    SortNowWho=CHOOSE(SortNow=SortLast,'-','+') & WHO(DirQ,SortNow)
    0{PROP:Text}='#1# Order - HasSortColumn: SORT (' & SortNow &' /'& SortLast &') ' & CLIP(SortNowWho) & SortLastWho
    SORT(DirQ,CLIP(SortNowWho) & SortLastWho)
    SortLast = CHOOSE(SortNow=ABS(SortLast),-1*SortLast,SortNow) 
    GET(DirQ, DirQ:Name)                           !If no Unique field to GET() then Loop until find it
    ?ListFiles{PROP:Selected}=POINTER(DirQ)        !Preserved the selected record
    DISPLAY
    
!===================================================================
!Sorting done before C9 with Alerting Mouse Left on LIST
ListSortWithAlertMouseLeft    PROCEDURE()  
QNdx    LONG,AUTO
DirQ    QUEUE(FILE:Queue),PRE(DirQ)
        END ! DirQ:Name  DirQ:ShortName(8.3?)  DirQ:Date  DirQ:Time  DirQ:Size  DirQ:Attrib
SortNow     SHORT(1)
SortLast    SHORT(1)
SortNowWho  STRING(128)
SortLastWho STRING(128)

FilesWindow WINDOW('Sort with AlertKey MouseLeft'),AT(1,200,343,125),FONT('Segoe UI',9,,FONT:regular),SYSTEM,GRAY,RESIZE
              STRING('Column Sorting done with ALRT(MouseLeft)'),AT(2,2),USE(?HowSort)
              LIST,AT(1,15),USE(?ListFiles),FULL,VSCROLL,ALRT(MouseLeft),TIP('Click heads to sort, Click again to reverse'), |
                FORMAT('120L(1)|M~Name~@s255@52L(1)|M~Short Name~@s13@40R(1)|M~Date~C(0)@d1@40R(1)|M~Time~C(0)@T4@56R(1)|M~Size~C(0)@n13@16L(1)|M~Attr~@n3@') ,|
                FROM(DirQ)
            END
Dir2Clp     ANY
    CODE
    FREE(DirQ)
    DIRECTORY(DirQ,WinTempBS&'*.*',ff_:NORMAL)
    LOOP QNdx = RECORDS(DirQ) TO 1 BY -1        !--Keep directories, Delete files, Case Name
         GET(DirQ,QNdx)
         IF BAND(DirQ:Attrib,FF_:Directory) OR DirQ:Name='.' OR DirQ:Name='..'   !. or .. Dirs
            DELETE(DirQ)
         ELSE
             DirQ:Name=UPPER(DirQ:Name[1]) & DirQ:Name[2 : SIZE(DirQ:Name) ]
             PUT(DirQ)
         END
    END 
    SortNow=1
    SortNowWho=WHO(DirQ,SortNow) 
    SORT(DirQ , SortNowWho)  !   , DirQ:ShortName , DirQ:Date , DirQ:Time , DirQ:Size , DirQ:Attrib )    
    OPEN(FilesWindow)
    0{PROP:Text}=CLIP(0{PROP:Text}) &'  '& WinTempBS & ' (' & RECORDS(DirQ) &' records) '
    SELECT(?ListFiles,1)
    ACCEPT
       CASE FIELD()
       OF ?ListFiles
          CASE EVENT() !Click Header to Sort
          OF EVENT:PreAlertKey
             IF ?ListFiles{PROPList:MouseDownRow} > 0 THEN CYCLE. !Click in DATA List so CYCLE to let normal Left Click Work
             IF ?ListFiles{PROPList:MouseDownZone} = LISTZONE:right THEN CYCLE. !Clicked on Resizer in Header, CYCLE to let RTL work normally to resize
          OF EVENT:AlertKey
             IF ?ListFiles{PROPList:MouseDownZone} = LISTZONE:right THEN CYCLE.
             SortNow=?ListFiles{PROPList:MouseDownField}
             IF ?ListFiles{PROPList:MouseDownRow} = 0  AND SortNow THEN
                IF SortNow<>ABS(SortLast) THEN SortLastWho=',' & SortNowWho.
                SortNowWho=CHOOSE(SortNow=SortLast,'-','+') & WHO(DirQ,SortNow)
                0{PROP:Text}='Sort with AlertKeys: SORT (' & SortNow &' /'& SortLast &') ' & CLIP(SortNowWho) & SortLastWho
                SORT(DirQ,CLIP(SortNowWho) & SortLastWho)
                SortLast = CHOOSE(SortNow=ABS(SortLast),-1*SortLast,SortNow)
                DISPLAY
             END

          OF EVENT:NewSelection !DblClick to View 1 File
             IF KEYCODE()=MouseLeft2 THEN
                GET(DirQ,CHOICE(?ListFiles))
                MESSAGE(CLIP(DirQ:Name) &'|'& DirQ:ShortName &'|'& DirQ:Date &'|'& DirQ:Time &'|'& DirQ:Size |
                        &'|'& DirQ:Attrib,'File '&CHOICE(?ListFiles),,,,2)
             END

          END ! Case EVENT()
       END ! Case FIELD()
    END !ACCEPT
    CLOSE(FilesWindow)
