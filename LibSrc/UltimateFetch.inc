FetchPrimary                  PROCEDURE(FILE File,         ? Component1 ,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC
FetchUnique                   PROCEDURE(FILE File,KEY Key, ? Component1 ,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC
FetchFirst                    PROCEDURE(FILE File,KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC
FetchLast                     PROCEDURE(FILE File,KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>),BYTE,PROC
SetWhere                      PROCEDURE(FILE File,KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)
FilterWhere                   PROCEDURE(FILE File,<STRING Filter>)
NextWhere                     PROCEDURE(FILE File),BYTE
