!ABCIncludeFile
         
  INCLUDE('RO_Option.inc'),ONCE

RO_Option_Group               GROUP,TYPE
ID                              LONG
Option                          &RO_Option
AutoDispose                     BOOL
                              END
         
RO_Option_Queue               QUEUE(RO_Option_Group),TYPE
                              END
         
RO_Options                    CLASS,TYPE,MODULE('RO_Options.clw'),LINK('RO_Options.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
OptionQ                         &RO_Option_Queue,PROTECTED

Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
AddOption                       PROCEDURE(LONG ID),*RO_Option
AddOption                       PROCEDURE(BYTE ID,RO_Option Option,<BOOL AutoDispose>),*RO_Option,PROC

Ask                             PROCEDURE,BYTE

FetchByIndex                    PROCEDURE(LONG QIndex,*RO_Option_Group OptionG),BYTE

FetchByID                       PROCEDURE(LONG ID),BYTE,PROTECTED
GetValue                        PROCEDURE(LONG ID),?,VIRTUAL
GetValueForDisplay              PROCEDURE(LONG ID),STRING,VIRTUAL

Records                         PROCEDURE,LONG
ResetValues                     PROCEDURE
                              END
