!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE
  INCLUDE('CL_PropertyList.inc'),ONCE
                                   
CL_Property_Long              CLASS(CL_Property_Abstract),IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property_Long.clw'),LINK('CL_Property_Long.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Value                          LONG,PROTECTED
_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<LONG Value>),*CL_Property_Long  !Factory method--does not use SELF

Get                             PROCEDURE,LONG,VIRTUAL
Set                             PROCEDURE(LONG Value),VIRTUAL
Set                             PROCEDURE(CL_Property_Long Value),VIRTUAL
                              END
