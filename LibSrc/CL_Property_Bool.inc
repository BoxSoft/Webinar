!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE
  INCLUDE('CL_PropertyList.inc'),ONCE

CL_Property_Bool              CLASS(CL_Property_Abstract),TYPE,IMPLEMENTS(CL_PropertyInterface),MODULE('CL_Property_Bool.clw'),LINK('CL_Property_Bool.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Value                          BOOL,PROTECTED

_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<Bool Value>),*CL_Property_Bool
Get                             PROCEDURE,BOOL,VIRTUAL
Set                             PROCEDURE(BOOL Value),VIRTUAL
Set                             PROCEDURE(CL_Property_Bool Value),VIRTUAL
                              END
