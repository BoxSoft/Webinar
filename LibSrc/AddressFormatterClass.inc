!ABCIncludeFile
!!ABCIncludeFile(AddressFormatter)  Future

!==============================================================================
                              ITEMIZE
AddressFormatterFieldType:FirstName EQUATE
AddressFormatterFieldType:MiddleName    EQUATE
AddressFormatterFieldType:LastName  EQUATE
AddressFormatterFieldType:Company   EQUATE
AddressFormatterFieldType:Address1  EQUATE
AddressFormatterFieldType:Address2  EQUATE
AddressFormatterFieldType:City  EQUATE
AddressFormatterFieldType:State EQUATE
AddressFormatterFieldType:Zip   EQUATE
                              END

AddressFormatterFieldClass    CLASS,TYPE,MODULE('AddressFormatterClass.CLW'),LINK('AddressFormatterClass.CLW')!,_ABCLinkMode_),DLL(_ABCDllMode_)
Field                           ANY
Construct                       PROCEDURE,REPLACE
Destruct                        PROCEDURE
InitField                       PROCEDURE(*? Field),VIRTUAL
SetValue                        PROCEDURE(STRING Field),VIRTUAL
GetValue                        PROCEDURE,STRING,VIRTUAL
                              END

AddressFormatterFieldQueue    QUEUE,TYPE
Type                            BYTE
Field                           &AddressFormatterFieldClass
                              END

!==============================================================================

AddressFormatterClass         CLASS,TYPE,MODULE('AddressFormatterClass.CLW'),LINK('AddressFormatterClass.CLW')!,_ABCLinkMode_),DLL(_ABCDllMode_)
! Add properties here, which are variables
Q                               &AddressFormatterFieldQueue,PROTECTED

OmitsSeparatorWhenBlank         BOOL
UsesProperNames                 BOOL

! Add Methods here, which are just procedures or functions
Construct                       PROCEDURE
Destruct                        PROCEDURE
                                       
AddField                        PROCEDURE(BYTE Type,*? Field),VIRTUAL
GetField                        PROCEDURE(BYTE Type),STRING,VIRTUAL

FirstName                       PROCEDURE,STRING,VIRTUAL
MiddleName                      PROCEDURE,STRING,VIRTUAL
LastName                        PROCEDURE,STRING,VIRTUAL
Company                         PROCEDURE,STRING,VIRTUAL
Address1                        PROCEDURE,STRING,VIRTUAL
Address2                        PROCEDURE,STRING,VIRTUAL
City                            PROCEDURE,STRING,VIRTUAL
State                           PROCEDURE,STRING,VIRTUAL
Zip                             PROCEDURE,STRING,VIRTUAL

FormatAddress                   PROCEDURE(STRING Separator),STRING,VIRTUAL
FormatAddressBlock              PROCEDURE,STRING,VIRTUAL
FormatAddressInline             PROCEDURE,STRING,VIRTUAL
FormatCityStateZip              PROCEDURE,STRING,VIRTUAL
FormatFirstLastName             PROCEDURE,STRING,VIRTUAL
FormatLastFirstName             PROCEDURE,STRING,VIRTUAL
FormatNameAddress               PROCEDURE(STRING Separator),STRING,VIRTUAL
FormatNameAddressBlock          PROCEDURE,STRING,VIRTUAL
FormatNameAddressInline         PROCEDURE,STRING,VIRTUAL
                              END
