!ABCIncludeFile

  INCLUDE('CL_Property.inc'),ONCE

CL_PropertyListQueue          QUEUE,TYPE
Property                        &CL_PropertyInterface
Name                            &STRING
                              END

CL_PropertyList               CLASS,TYPE,MODULE('CL_PropertyList.clw'),LINK('CL_PropertyList.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Q                               &CL_PropertyListQueue,PROTECTED

Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
Add                             PROCEDURE(CL_PropertyInterface Property,STRING Name)
GetJson                         PROCEDURE,STRING
SetJson                         PROCEDURE(STRING Value)
                              END
