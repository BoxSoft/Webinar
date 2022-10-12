  MEMBER('Test.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('Test_BC0.CLW')
Test_BC0:DctInit             PROCEDURE()
Test_BC0:DctKill             PROCEDURE()
Test_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  Test_BC0:DctInit
  Test_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  Test_BC0:DctKill

