!!ABCIncludeFile

  INCLUDE('UltimateWindowValidator.inc'),ONCE

UltimateLegacyWindowValidator CLASS,TYPE,MODULE('UltimateLegacyWindowValidator.clw'),LINK('UltimateLegacyWindowValidator.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
CL                              &ComponentList,PRIVATE
Construct                       PROCEDURE
Destruct                        PROCEDURE
AddItem                         PROCEDURE(WindowComponent WC)
TakeEvent                       PROCEDURE,BYTE,PROC
                              END
