!ABCIncludeFile
         
  INCLUDE('RO_Options.inc'),ONCE

RO_OptionsStore               CLASS,TYPE,MODULE('RO_OptionsStore.clw'),LINK('RO_OptionsStore.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Options                         &RO_Options
RegistryFolder                  CSTRING(255)

Init                            PROCEDURE(RO_Options Options,STRING RegistryFolder)
Load                            PROCEDURE
Save                            PROCEDURE
                              END
