#! Replace Exclude with override option
#! Rename Include to Override or something similar
#! Ignore aliases and memory files
#! When file exists, Replace?  Yes/No/Ask
#! Create random data
#! Use alternate name e.g. .TPE
#!*****************************************************************************
#!*****************************************************************************
#TEMPLATE(UltimateTableCreator,'Ultimate Table Creator (v.99)'),FAMILY('ABC'),FAMILY('CW20')
#!*****************************************************************************
#EXTENSION(TableCreator,'Create Empty Tables'),DESCRIPTION('[UltimateTableCreator] Create Empty Tables'),PROCEDURE
  #PROMPT('Local Procedure Name:',@S50),%LocalProcedureName,REQ,DEFAULT('CreateEmptyTables')
  #PROMPT('Include all Tables except excluded below',CHECK),%IncludeAllTables,DEFAULT(%True),AT(10,,180)
  #SHEET
    #TAB('Table Overrides')
      #BUTTON('Table to Include'),MULTI(%TablesToInclude,%TableToInclude),INLINE
        #PROMPT('Table to Include:',FROM(%File)),%TableToInclude,REQ
      #ENDBUTTON
    #ENDTAB
    #TAB('Exclude'),WHERE(%IncludeAllTables)
      #BUTTON('Table to Exclude'),MULTI(%TablesToExclude,%TableToExclude),INLINE
        #PROMPT('Table to Exclude:',FROM(%File)),%TableToExclude,REQ
      #ENDBUTTON
    #ENDTAB
  #ENDSHEET
#!**********
#AT(%CustomGlobalDeclarations)
  #CALL(%AtCustomGlobalDeclarations)
#ENDAT
#!**********
#ATSTART
  #CALL(%CollectTables)
#ENDAT
#!**********
#AT(%DataSection),PRIORITY(5384),DESCRIPTION(%ActiveTemplateInstanceDescription &' - Data')
#INSERT(%AtTableCreatorData)
#ENDAT
#!**********
#!#AT(%DeclarationSection),PRIORITY(5384),DESCRIPTION(%ActiveTemplateInstanceDescription &' - Data')
#!#INSERT(%AtTableCreatorData)
#!#ENDAT
#!**********
#AT(%LocalProcedures),PRIORITY(5384),DESCRIPTION(%ActiveTemplateInstanceDescription &' - Local Procedures')
#INSERT(%AtTableCreatorLocalProcedures)
#ENDAT
#!*****************************************************************************
#GROUP(%AtCustomGlobalDeclarations)
  #CALL(%CollectTables)
  #FOR(%TableToCreate)
    #ADD(%UsedFile,%TableToCreate)
    #INSERT(%AddRelatedTables(ABC),%UsedFile,%TableToCreate)
  #ENDFOR
#!*****************************************************************************
#GROUP(%CollectTables)
  #IF(NOT VAREXISTS(%TableToCreate))
    #DECLARE(%TableToCreate),UNIQUE
    #IF(%IncludeAllTables)
      #FOR(%File)
        #SET(%ValueConstruct, %False)
        #FOR(%TablesToExclude),WHERE(%File = %TableToExclude)
          #SET(%ValueConstruct, %True)
          #BREAK
        #ENDFOR
        #IF(%ValueConstruct)
          #CYCLE
        #ENDIF
        #ADD(%TableToCreate, %File)
      #ENDFOR
    #ELSE
      #FOR(%TablesToInclude)
        #FIX(%File, %TableToInclude)
        #IF(%File)
          #ADD(%TableToCreate, %File)
        #ELSE
          #ERROR(%Procedure &': Missing Table to Create = '& %TableToCreate) 
        #ENDIF
      #ENDFOR
    #ENDIF
  #ENDIF
#!*****************************************************************************
#GROUP(%AtTableCreatorData)
                     MAP
%[22]LocalProcedureName PROCEDURE
                     END
#!*****************************************************************************
#GROUP(%AtTableCreatorLocalProcedures),AUTO

%LocalProcedureName PROCEDURE
  CODE
      #FOR(%TableToCreate)
  CREATE(%TableToCreate)
  IF ERRORCODE() <> NoError
    MESSAGE('Cannot create %TableToCreate table!|'& ERRORCODE() &' - '& ERROR())
  END
      #ENDFOR

#!*****************************************************************************
  