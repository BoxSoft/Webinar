!ABCIncludeFile

  INCLUDE('ABFile.inc'),ONCE

UltimateFileManager           CLASS(FileManager),TYPE,MODULE('UltimateFileManager.clw'),LINK('UltimateFileManager.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
PrimaryKeyRef                   &KEY

Fetch                           PROCEDURE(KEY Key,? Component1,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC,VIRTUAL
TryFetch                        PROCEDURE(KEY Key,? Component1,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC,VIRTUAL

FetchPrimary                    PROCEDURE(? Component1,<? Component2>,<? Component3>),BYTE,PROC,VIRTUAL
TryFetchPrimary                 PROCEDURE(? Component1,<? Component2>,<? Component3>),BYTE,PROC,VIRTUAL

FetchFirst                      PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC,VIRTUAL
TryFetchFirst                   PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC,VIRTUAL

FetchLast                       PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC,VIRTUAL
TryFetchLast                    PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC,VIRTUAL

SetWhere                        PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),VIRTUAL
FilterWhere                     PROCEDURE(<STRING Filter>)
NextWhere                       PROCEDURE,BYTE,VIRTUAL

HasPrimaryKey                   PROCEDURE,BOOL,PROTECTED
                              END
