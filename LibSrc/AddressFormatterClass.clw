                              MEMBER

  INCLUDE('AddressFormatterClass.inc'),ONCE
  INCLUDE('Equates.clw')
  INCLUDE('Errors.clw')

CRLF                          EQUATE('<13,10>')
COMMA                         EQUATE(', ')

                              MAP
                              END

!==============================================================================
AddressFormatterFieldClass.Construct  PROCEDURE
  CODE
  SELF.Field = ''
  
AddressFormatterFieldClass.Destruct   PROCEDURE
  CODE
  !Ensure that ANY variable memory is freed.
  !(Definitely a problem with ANYs in QUEUEs, 
  !but we're not sure about ANYs in CLASSes.)
  SELF.Field &= NULL
  
AddressFormatterFieldClass.InitField  PROCEDURE(*? pField)
  CODE
  SELF.Field &= pField
  
AddressFormatterFieldClass.SetValue   PROCEDURE(STRING pField)
  CODE
  SELF.Field = pField

AddressFormatterFieldClass.GetValue   PROCEDURE!,STRING
  CODE
  RETURN CLIP(LEFT(SELF.Field))

!==============================================================================
AddressFormatterClass.Construct   PROCEDURE
  CODE
  SELF.Q                      &= NEW AddressFormatterFieldQueue
  SELF.OmitsSeparatorWhenBlank = TRUE
  SELF.UsesProperNames         = TRUE

AddressFormatterClass.Destruct    PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.Q)
    GET(SELF.Q, 1)
    DISPOSE(SELF.Q.Field)
    DELETE(SELF.Q)
  END
  DISPOSE(SELF.Q)

AddressFormatterClass.AddField    PROCEDURE(BYTE pType,*? pField)
  CODE
  CLEAR(SELF.Q)
  SELF.Q.Type   = pType
  SELF.Q.Field &= NEW AddressFormatterFieldClass
  ADD(SELF.Q, SELF.Q.Type)
  SELF.Q.Field.InitField(pField)

AddressFormatterClass.GetField    PROCEDURE(BYTE pType)!,STRING
  CODE
  SELF.Q.Type = pType
  GET(SELF.Q, SELF.Q.Type)
  IF ERRORCODE() = NoError
    RETURN SELF.Q.Field.GetValue()
  ELSE
    RETURN ''
  END
           
AddressFormatterClass.FirstName   PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:FirstName)
AddressFormatterClass.MiddleName  PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:MiddleName)
AddressFormatterClass.LastName    PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:LastName)
AddressFormatterClass.Company PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:Company)
AddressFormatterClass.Address1    PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:Address1)
AddressFormatterClass.Address2    PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:Address2)
AddressFormatterClass.City    PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:City)
AddressFormatterClass.State   PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:State)
AddressFormatterClass.Zip     PROCEDURE
  CODE; RETURN SELF.GetField(AddressFormatterFieldType:Zip)
                 
AddressFormatterClass.FormatAddress   PROCEDURE(STRING pSeparator)!,STRING
  CODE
  RETURN CLIP(LEFT( |
      SELF.Address1() & CHOOSE(SELF.Address1()='' AND SELF.OmitsSeparatorWhenBlank, '', pSeparator) & |
      SELF.Address2() & CHOOSE(SELF.Address2()='' AND SELF.OmitsSeparatorWhenBlank, '', pSeparator) & |
      SELF.FormatCityStateZip()))

AddressFormatterClass.FormatAddressBlock  PROCEDURE!,STRING
  CODE
  RETURN SELF.FormatAddress(CRLF)
  
AddressFormatterClass.FormatAddressInline PROCEDURE!,STRING
  CODE
  RETURN SELF.FormatAddress(COMMA)

AddressFormatterClass.FormatCityStateZip  PROCEDURE!,STRING
  CODE
  RETURN CLIP(LEFT( |
      SELF.City() & |
      CHOOSE(SELF.City()='' AND SELF.OmitsSeparatorWhenBlank, '', ', ') & |
      LEFT(SELF.State() &'  '& SELF.Zip())))
  
AddressFormatterClass.FormatFirstLastName PROCEDURE!,STRING
  CODE
  RETURN CLIP(LEFT(SELF.FirstName() &' '& SELF.LastName()))

AddressFormatterClass.FormatLastFirstName PROCEDURE!,STRING
  CODE
  RETURN CLIP(LEFT( |
      SELF.LastName() & |
      CHOOSE(SELF.LastName()='' AND SELF.OmitsSeparatorWhenBlank, '', ', ') & |
      SELF.FirstName()))

AddressFormatterClass.FormatNameAddress   PROCEDURE(STRING pSeparator)!,STRING
  CODE
  RETURN CLIP(LEFT( |
      SELF.FormatFirstLastName() & CHOOSE(SELF.FormatFirstLastName()='' AND SELF.OmitsSeparatorWhenBlank, '', pSeparator) & |
      SELF.FormatAddress(pSeparator)))
  
AddressFormatterClass.FormatNameAddressBlock  PROCEDURE!,STRING
  CODE
  RETURN SELF.FormatNameAddress(CRLF)
  
AddressFormatterClass.FormatNameAddressInline PROCEDURE!,STRING
  CODE
  RETURN SELF.FormatNameAddress(COMMA)
  
