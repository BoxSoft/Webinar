!ABCIncludeFile

  INCLUDE('CL_Property_Long.inc'),ONCE
                                   
CL_Property_Time              CLASS(CL_Property_Long),IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property_Time.clw'),LINK('CL_Property_Time.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<LONG Value>),*CL_Property_Time  !Factory method--does not use SELF

Set                             PROCEDURE(CL_Property_Time Value),VIRTUAL

DeformatJson                    PROCEDURE(STRING Formatted),LONG
FormatJson                      PROCEDURE(<LONG Value>),STRING
FormatTime                      PROCEDURE(<BYTE MaxLen>),STRING,VIRTUAL
                              END
