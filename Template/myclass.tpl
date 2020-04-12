#!*****************************************************************************
#!*****************************************************************************
#TEMPLATE(MyTemplate,'MyClass Wrapper'),FAMILY('ABC')
#INCLUDE('MyABC.tpw')
#!*****************************************************************************
#!*****************************************************************************
#EXTENSION(MyClassWrapper,'MyClass Wrapper'),DESCRIPTION('MyClass Wrapper'),PROCEDURE #!,REQ(BrowseBox(ABC))-This will mean using %ActiveTemplateInstance
#PREPARE
  #CALL(%SetClassDefaults)
#ENDPREPARE
#!**********
#BOXED,HIDE,AT(,,0,0)
  #!When creating a new template, leave these %MyThings named as-is, if you want to use MYABC.TPW.
  #PROMPT('',@S30),%MyObjectID,DEFAULT('MyID')
  #PROMPT('',@S30),%MyObjectDefaultName,DEFAULT('MyObject')
  #!PROMPT('',@S30),%MyObjectDefaultName,DEFAULT('MyObject'& %ActiveTemplateInstance)
  #PROMPT('',@S30),%MyObjectDefaultClass,DEFAULT('MyClass')
  #INSERT(%OOPHiddenPrompts(ABC))
#ENDBOXED
#!**********
#SHEET,ADJUST
  #TAB('General')
    #PROMPT('My Description:',@S30),%MyDescription
  #ENDTAB
  #TAB('Classes')
    #WITH(%ClassItem,%MyObjectID)
      #INSERT(%ClassPrompts(ABC))
    #ENDWITH
  #ENDTAB
#ENDSHEET
#!**********
#ATSTART
  #CALL(%AtMyClassStart)
#ENDAT
#!**********
#AT(%GatherObjects)
  #CALL(%AddObjectList)
#ENDAT
#!**********
#AT(%LocalDataClasses)
#CALL(%GenerateClass)
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),PRIORITY(8050)
%MyObject.Init
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'Kill','(),BYTE'),PRIORITY(4000)
%MyObject.Kill
#ENDAT
#!**********
#AT(%LocalProcedures)
#CALL(%GenerateVirtuals(ABC), %MyObjectID, 'Local Objects|MyClass Manager', '%MyClassVirtuals(MyTemplate)')
#ENDAT
#!**********
#AT(%MyClassMethodCodeSection),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
#!AT(%MyClassMethodCodeSection,%ActiveTemplateInstance),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
  #CALL(%GenerateParentCall(ABC))
#ENDAT
#!*****************************************************************************
#! The %ActiveTemplateInstance attribute is needed, if there can be multiple
#! instances of this %ActiveTemplate in a particular procedure (if the template
#! has the MULTI attribute, or REQ a local template that has MULTI).  Note
#! that the PREPARE begins with a common, when the %ActiveTemplateInstance
#! attribute is present.  This aligns the call to %FixClassName(...) with the
#! %pClassMethod parameter.
#!***
#GROUP(%MyClassVirtuals, %TreeText, %DataText, %CodeText)
#EMBED(%MyClassMethodDataSection,'MyClass Method Data Section'),%pClassMethod,%pClassMethodPrototype,LABEL,DATA,PREPARE(%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %DataText)
#!EMBED(%MyClassMethodDataSection,'MyClass Method Data Section'),%ActiveTemplateInstance,%pClassMethod,%pClassMethodPrototype,LABEL,DATA,PREPARE(,%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %DataText)
  #?CODE
  #EMBED(%MyClassMethodCodeSection,'MyClass Method Code Section'),%pClassMethod,%pClassMethodPrototype,PREPARE(%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %CodeText)
  #!EMBED(%MyClassMethodCodeSection,'MyClass Method Code Section'),%ActiveTemplateInstance,%pClassMethod,%pClassMethodPrototype,PREPARE(,%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %CodeText)
#!*****************************************************************************
