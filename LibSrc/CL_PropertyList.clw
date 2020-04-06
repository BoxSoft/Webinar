                              MEMBER

  INCLUDE('CL_PropertyList.inc'),ONCE
  INCLUDE('jFiles.inc'),ONCE

                              MAP
                              END

!==============================================================================
CL_PropertyList.Construct     PROCEDURE
  CODE
  SELF.Q &= NEW CL_PropertyListQueue
  
!==============================================================================
CL_PropertyList.Destruct      PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.Q)
    GET(SELF.Q, RECORDS(SELF.Q))
    SELF.Q.Property.Destroy()
    DISPOSE(SELF.Q.Name)
    DELETE(SELF.Q)
  END
  DISPOSE(SELF.Q)

!==============================================================================
CL_PropertyList.Add           PROCEDURE(CL_PropertyInterface Property,STRING Name)
  CODE
  CLEAR(SELF.Q)
  SELF.Q.Property &= Property
  SELF.Q.Name     &= NEW STRING(LEN(Name))
  SELF.Q.Name      = Name
  ADD(SELF.Q)
  
!==============================================================================
CL_PropertyList.GetJson       PROCEDURE!,STRING
X                               LONG
json                            JSONClass
jsonObject                      &JSONClass
str                             StringTheory
  CODE
  json.Start()
  json.SetTagCase(jF:CaseAny)
  LOOP X = 1 TO RECORDS(SELF.Q)
    GET(SELF.Q, X)
    !str.Trace(SELF.Q.Name &'['& SELF.Q.Property.GetJsonType() &']='& SELF.Q.Property.GetJson())
    CASE SELF.Q.Property.GetJsonType()
    OF   CL_Property_JsonType:Object
    OROF CL_Property_JsonType:Array
      jsonObject &= json.Add(SELF.Q.Name)
      jsonObject.LoadString(SELF.Q.Property.GetJson())
    ELSE
      json.Add(SELF.Q.Name, SELF.Q.Property.GetJson(), SELF.Q.Property.GetJsonType())
    END
  END
  json.SaveString(str, jf:noformat)
  RETURN str.GetValue()
      
!==============================================================================
CL_PropertyList.SetJson       PROCEDURE(STRING Value)
X                               LONG
json                            JSONClass
jsonObject                      &JSONClass
str                             StringTheory
  CODE
  json.Start()
  json.SetTagCase(jF:CaseAny)
  json.LoadString(Value)
  LOOP X = 1 TO RECORDS(SELF.Q)
    GET(SELF.Q, X)
    !SELF.Q.Property.SetJson(json.GetValueByName(SELF.Q.Name))
    jsonObject &= json.GetByName(SELF.Q.Name)
    IF NOT jsonObject &= NULL
      CASE jsonObject.GetType()
      OF   CL_Property_JsonType:Object
      OROF CL_Property_JsonType:Array
        jsonObject.SaveString(Str)
        SELF.Q.Property.SetJson(Str.GetValue())
      ELSE
        SELF.Q.Property.SetJson(jsonObject.GetValue())
      END
    END
  END

!==============================================================================
