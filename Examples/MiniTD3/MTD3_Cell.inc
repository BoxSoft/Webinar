MTD3_Cell:Empty               EQUATE(' ')
MTD3_Cell:Path                EQUATE('+')
MTD3_Cell:Gun                 EQUATE('G')
MTD3_Cell:Missile             EQUATE('M')
MTD3_Cell:Laser               EQUATE('L')
MTD3_Cell:Booster             EQUATE('B')

!MTD3_Cell                     CLASS,TYPE,MODULE('MTD3_Cell.clw'),LINK('MTD3_Cell.clw')
!
!                              END
MTD3_WeaponDamage:Gun         EQUATE(250)  ! 5 x (15 / 0.3) = 250
MTD3_WeaponDamage:Missle      EQUATE(120)  ! 8 x (15 / 1.5) =  80, but it's wide-range
MTD3_WeaponDamage:Laser       EQUATE( 75)  !25 x (15 / 5.0) =  75

MTD3_WeaponCost               EQUATE(50)

MTD3_BoosterBaseCost          EQUATE(100)
MTD3_BoosterIncrementalCost   EQUATE(10)
