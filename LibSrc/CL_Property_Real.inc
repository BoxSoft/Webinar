!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE
  INCLUDE('CL_PropertyList.inc'),ONCE
                                   
CL_Property_Real              CLASS(CL_Property_Abstract),IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property_Real.clw'),LINK('CL_Property_Real.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Value                          REAL,PROTECTED
_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<REAL Value>),*CL_Property_Real  !Factory method--does not use SELF

Get                             PROCEDURE,REAL,VIRTUAL
Set                             PROCEDURE(REAL Value),VIRTUAL
Set                             PROCEDURE(CL_Property_Real Value),VIRTUAL
                              END
