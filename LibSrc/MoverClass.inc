!ABCIncludeFile

  INCLUDE('ABBrowse.inc'),ONCE

Mover:Direction:Up            EQUATE(-1)
Mover:Direction:Down          EQUATE(+1)

Mover_Abstract                CLASS,TYPE,MODULE('MoverClass.clw'),LINK('MoverClass.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
File                            &FILE,PROTECTED
View                            &VIEW,PROTECTED
Sequence                        ANY,PROTECTED
ListControl                     SIGNED,PROTECTED

MoveUpKeycode                   UNSIGNED,PROTECTED
MoveDownKeycode                 UNSIGNED,PROTECTED
MoveToTopKeycode                UNSIGNED,PROTECTED
MoveToBottomKeycode             UNSIGNED,PROTECTED

MoveUpControl                   SIGNED,PROTECTED
MoveDownControl                 SIGNED,PROTECTED
MoveToTopControl                SIGNED,PROTECTED
MoveToBottomControl             SIGNED,PROTECTED

Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL

AfterMove                       PROCEDURE(SHORT Direction),VIRTUAL
BeforeHidingThat                PROCEDURE(SHORT Direction),VIRTUAL
CanMove                         PROCEDURE(SHORT Direction),BOOL,VIRTUAL
CanMoveDown                     PROCEDURE,BOOL
CanMoveUp                       PROCEDURE,BOOL
InitWindow                      PROCEDURE,VIRTUAL
Move                            PROCEDURE(SHORT Direction),VIRTUAL
MoveUp                          PROCEDURE
MoveDown                        PROCEDURE
SetThatSequence                 PROCEDURE(LONG ThisSequence,SHORT Direction),VIRTUAL
SetThisSequence                 PROCEDURE(LONG ThatSequence,SHORT Direction),VIRTUAL
TakeEvent                       PROCEDURE,BYTE,PROC
UpdateWindow                    PROCEDURE
                              END

Mover_ABC                     CLASS(Mover_Abstract),TYPE,MODULE('MoverClass.clw'),LINK('MoverClass.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Browse                          &BrowseClass,PROTECTED
Init                            PROCEDURE(BrowseClass Browse,*? Sequence,SIGNED MoveUpControl,SIGNED MoveDownControl) !,EXTENDS
CanMove                         PROCEDURE(SHORT Direction),BOOL,DERIVED
Move                            PROCEDURE(SHORT Direction),DERIVED
                              END

Mover_Legacy                  CLASS(Mover_Abstract),TYPE,MODULE('MoverClass.clw'),LINK('MoverClass.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
ListQueue                       &QUEUE,PROTECTED
ViewPosition                    &STRING,PROTECTED
CanMove                         PROCEDURE(SHORT Direction),BOOL,DERIVED
Move                            PROCEDURE(SHORT Direction),DERIVED
                              END
