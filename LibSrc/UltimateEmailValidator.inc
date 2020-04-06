!ABCIncludeFile

  INCLUDE('UltimateAbstractValidator.inc'),ONCE

UltimateEmailValidator        CLASS(UltimateAbstractValidator),TYPE,IMPLEMENTS(UltimateValueValidator),MODULE('UltimateEmailValidator.clw'),LINK('UltimateEmailValidator.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
                              END
