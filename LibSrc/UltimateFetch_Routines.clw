!==============================================================================
  SECTION('PassComponentValues')

PassComponentValues           ROUTINE
  KeyComponentHandler.Init(File, Key)
  IF ~OMITTED(Component1)
    KeyComponentHandler.PassComponentValue(Component1)
    IF ~OMITTED(Component2)
      KeyComponentHandler.PassComponentValue(Component2)
      IF ~OMITTED(Component3)
        KeyComponentHandler.PassComponentValue(Component3)
        IF ~OMITTED(Component4)
          KeyComponentHandler.PassComponentValue(Component4)
          IF ~OMITTED(Component5)
            KeyComponentHandler.PassComponentValue(Component5)
            IF ~OMITTED(Component6)
              KeyComponentHandler.PassComponentValue(Component6)
              IF ~OMITTED(Component7)
                KeyComponentHandler.PassComponentValue(Component7)
                IF ~OMITTED(Component8)
                  KeyComponentHandler.PassComponentValue(Component8)
                  IF ~OMITTED(Component9)
                    KeyComponentHandler.PassComponentValue(Component9)
                  END
                END
              END
            END
          END
        END
      END
    END
  END

!==============================================================================
