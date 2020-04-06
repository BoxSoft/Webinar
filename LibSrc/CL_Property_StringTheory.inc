!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE
  INCLUDE('CL_PropertyList.inc'),ONCE
  INCLUDE('StringTheory.inc'),ONCE
                                   
CL_Property_StringTheory      CLASS(StringTheory),IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property_StringTheory.clw'),LINK('CL_Property_StringTheory.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<STRING Value>),*CL_Property_StringTheory  !Factory method--does not use SELF

Get                             PROCEDURE,STRING,VIRTUAL
Set                             PROCEDURE(STRING Value),VIRTUAL
Set                             PROCEDURE(StringTheory Value),VIRTUAL
Set                             PROCEDURE(CL_Property_StringTheory Value),VIRTUAL
                              END
