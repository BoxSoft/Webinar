!ABCIncludeFile

                              ITEMIZE(1)
RO_Option_Type:Number           EQUATE
RO_Option_Type:String           EQUATE
RO_Option_Type:Date             EQUATE
RO_Option_Type:Check            EQUATE
RO_Option_Type:Choice           EQUATE
                              END

RO_Option_ValueGroup          GROUP,TYPE
Real                            REAL
String                          CSTRING(256)
Long                            LONG
                              END

RO_Option                     CLASS,TYPE,MODULE('RO_Option.clw'),LINK('RO_Option.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Type                            BYTE,PRIVATE
Label                           CSTRING(256)
Picture                         CSTRING(32)
Choices                         CSTRING(2000)

Value                           LIKE(RO_Option_ValueGroup),PROTECTED

Init                            PROCEDURE(BYTE Type,STRING Label,<String Picture>,<STRING Choices>,<? Value>),VIRTUAL

GetLabel                        PROCEDURE,STRING,VIRTUAL
GetType                         PROCEDURE,BYTE,VIRTUAL

ResetValue                      PROCEDURE,VIRTUAL
SetValue                        PROCEDURE(? Value),VIRTUAL
GetValue                        PROCEDURE,?,VIRTUAL
GetValueForDisplay              PROCEDURE,STRING,VIRTUAL

Ask                             PROCEDURE,BYTE,PROC,VIRTUAL

!--- Utility methods for object creation
NewOption                       PROCEDURE,*RO_Option
NewNumber                       PROCEDURE(STRING Label,String Picture,<REAL   Value>),*RO_Option
NewString                       PROCEDURE(STRING Label,String Length ,<STRING Value>),*RO_Option
NewDate                         PROCEDURE(STRING Label,String Picture,<LONG   Value>),*RO_Option
NewCheck                        PROCEDURE(STRING Label,               <BOOL   Value>),*RO_Option
NewChoice                       PROCEDURE(STRING Label,String Choices,<STRING Value>),*RO_Option
                              END
