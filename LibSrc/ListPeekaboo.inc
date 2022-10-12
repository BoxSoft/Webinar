!ABCIncludeFile

ListPeekabooClass_ColumnQueue QUEUE,TYPE
ColumnNo                        USHORT      !Column number
FieldNo                         USHORT      !Queue field number
Width                           SHORT       !Column Width
Resize                          BYTE        !Is column Resizable?
Fixed                           BYTE        !Is column Fixed?
HidePriority                    BYTE        !Can this column be hidden? 0=No. Larger number means better chance.
IsHidden                        BYTE        !The column is always hidden T/F
                              END

ListPeekabooClass             CLASS,TYPE,MODULE('ListPeekaboo.clw'),LINK('ListPeekaboo.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
ColumnQ                         &ListPeekabooClass_ColumnQueue,PROTECTED
ListControl                     SIGNED,PROTECTED
SlushColumn                     USHORT,PROTECTED
LastListWidth                   SHORT,PROTECTED

Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
FreeColumnQ                     PROCEDURE,PROTECTED
DeleteColumnQ                   PROCEDURE,PROTECTED
FetchColumn                     PROCEDURE(USHORT ColumnNo),BYTE,PROTECTED
HandleListColumns               PROCEDURE,PROTECTED

Init                            PROCEDURE(SIGNED ListControl,<USHORT SlushColumn>,<USHORT LastColumnWidth>)
InitHidePriority                PROCEDURE(USHORT Column,BYTE HidePriority)
HideColumn                      PROCEDURE(USHORT Column,BYTE ForceRefresh=TRUE)
UnHideColumn                    PROCEDURE(USHORT Column,BYTE ForceRefresh=TRUE)
UpdateColumnWidth               PROCEDURE(USHORT Column,SHORT ColumnWidth,BYTE ForceRefresh=TRUE)
TakeEvent                       PROCEDURE,VIRTUAL
TakeColumnResize                PROCEDURE,VIRTUAL
TakeWindowSized                 PROCEDURE(<BYTE ForceRefresh>),VIRTUAL
                              END
