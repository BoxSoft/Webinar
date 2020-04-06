!ABCIncludeFile

  INCLUDE('UltimateAbstractValidator.inc'),ONCE

UltimateRequiredValidator     CLASS(UltimateAbstractValidator),TYPE,IMPLEMENTS(UltimateValueValidator),MODULE('UltimateRequiredValidator.clw'),LINK('UltimateRequiredValidator.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
                              END
