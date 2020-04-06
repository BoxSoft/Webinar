!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE
  INCLUDE('CL_PropertyList.inc'),ONCE
                                   
CL_Property_String            CLASS(CL_Property_Abstract),IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property_String.clw'),LINK('CL_Property_String.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Value                          &STRING,PROTECTED
_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<STRING Value>),*CL_Property_String  !Factory method--does not use SELF
Destruct                        PROCEDURE,DERIVED

Get                             PROCEDURE,STRING,VIRTUAL
Set                             PROCEDURE(STRING Value),VIRTUAL
Set                             PROCEDURE(CL_Property_String Value),VIRTUAL
                              END
