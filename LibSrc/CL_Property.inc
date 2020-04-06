!ABCIncludeFile                        

  INCLUDE('jFiles.inc'),ONCE

CL_Property_JsonType:Null       EQUATE(json:Null)
CL_Property_JsonType:String     EQUATE(json:String)
CL_Property_JsonType:Number     EQUATE(json:Numeric)
CL_Property_JsonType:Bool       EQUATE(json:Boolean)
CL_Property_JsonType:Object     EQUATE(json:Object)
CL_Property_JsonType:Array      EQUATE(json:Array)

CL_PropertyInterface          INTERFACE
Destroy                         PROCEDURE
GetJsonType                     PROCEDURE,BYTE
GetJson                         PROCEDURE,STRING
SetJson                         PROCEDURE(STRING Value)
                              END

CL_Property_Abstract          CLASS,IMPLEMENTS(CL_PropertyInterface),TYPE,MODULE('CL_Property.clw'),LINK('CL_Property.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Destruct                        PROCEDURE,VIRTUAL
                              END
