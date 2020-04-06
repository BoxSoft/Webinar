!ABCIncludeFile

  INCLUDE('CL_Property_Long.inc'),ONCE
                                   
CL_Property_Date              CLASS(CL_Property_Long),IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property_Date.clw'),LINK('CL_Property_Date.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
_Create                         PROCEDURE(CL_PropertyList _Properties,STRING Name,<LONG Value>),*CL_Property_Date  !Factory method--does not use SELF

Set                             PROCEDURE(CL_Property_Date Value),VIRTUAL
                              END
