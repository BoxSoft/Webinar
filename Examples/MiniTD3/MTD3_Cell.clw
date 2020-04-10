                              MEMBER

  INCLUDE('MTD3_Cell.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                              END

!==============================================================================
MTD3_Cell.Construct           PROCEDURE
  CODE
  SELF.Contents = MTD3_Cell:Empty

!==============================================================================
MTD3_Cell.Destruct            PROCEDURE
  CODE

!==============================================================================
