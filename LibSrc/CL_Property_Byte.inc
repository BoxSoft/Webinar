!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE
  INCLUDE('CL_PropertyList.inc'),ONCE

CL_Property_Byte              CLASS(CL_Property_Abstract),TYPE,IMPLEMENTS(CL_PropertyInterface),MODULE('CL_Property_Byte.clw'),LINK('CL_Property_Byte.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Value                          BYTE,PROTECTED

_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<BYTE Value>),*CL_Property_Byte
Get                             PROCEDURE,BYTE,VIRTUAL
Set                             PROCEDURE(BYTE Value),VIRTUAL
Set                             PROCEDURE(CL_Property_Byte Value),VIRTUAL
                              END
