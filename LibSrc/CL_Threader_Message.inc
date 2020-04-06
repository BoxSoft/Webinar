!ABCIncludeFile

                              ITEMIZE(0)
CL_Threader_MessageStatus:Pending       EQUATE
CL_Threader_MessageStatus:Sent          EQUATE
CL_Threader_MessageStatus:Doing         EQUATE
CL_Threader_MessageStatus:Done          EQUATE
CL_Threader_MessageStatus:Undeliverable EQUATE
                              END
                 
CL_Threader_Message           CLASS,TYPE,MODULE('CL_Threader_Message.clw'),LINK('CL_Threader_Message.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
MessageID                       LONG
SenderThread                    SIGNED
ReceiverThread                  SIGNED
Status                          BYTE
DoneSignalRequired              BOOL
DeferOthersUntilDone            BOOL
Code                            UNSIGNED !Optional Notify Code
Data                            &STRING  !Optional Data

Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
Debug                           PROCEDURE(STRING M)  !Central Debug method for all CL_Threader_* classes
CopyTo                          PROCEDURE(CL_Threader_Message Target)
GetData                         PROCEDURE,STRING
SetData                         PROCEDURE(STRING S)
                              END
