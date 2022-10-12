                              MEMBER

  INCLUDE('RO_OptionsStore.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Errors.clw'),ONCE

                              MAP
                                !INCLUDE('STDebug.inc')
                              END

!==============================================================================
RO_OptionsStore.Init          PROCEDURE(RO_Options Options,STRING RegistryFolder)
  CODE
  SELF.Options       &= Options
  SELF.RegistryFolder = RegistryFolder
  
!==============================================================================
RO_OptionsStore.Load          PROCEDURE
X                               LONG,AUTO
OptionG                         LIKE(RO_Option_Group)
  CODE
  LOOP X = 1 TO SELF.Options.Records()
    IF SELF.Options.FetchByIndex(X, OptionG) <> Level:Benign THEN CYCLE.
    OptionG.Option.SetValue(GETREG(REG_CURRENT_USER, SELF.RegistryFolder, OptionG.ID))
  END
  
!==============================================================================
RO_OptionsStore.Save          PROCEDURE
X                               LONG,AUTO
OptionG                         LIKE(RO_Option_Group)
  CODE
  LOOP X = 1 TO SELF.Options.Records()
    IF SELF.Options.FetchByIndex(X, OptionG) <> Level:Benign THEN CYCLE.
    PUTREG(REG_CURRENT_USER, SELF.RegistryFolder, OptionG.ID, CLIP(OptionG.Option.GetValue()))
  END
      
!==============================================================================
