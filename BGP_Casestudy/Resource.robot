*** Settings ***
Documentation     Resource file containing all the PYTHON API implementations.

Library           setup_actions.py
Library           Devices.py
Library           String
Variables         variable.py
Library           OSPF.py
Library           IBGP.py




*** Variables ***
@{Devices} =      R1    R2    R3    R4    R5 
${ELEMENT}

*** Keywords ***

Setup Actions

    Log To Console            Setup Actions done here
    Run Keyword and Continue On Failure    connect_all    enable
    Log To console            Initial setup completed
   
    
Teardown Actions

    Log To Console            Teardown Actions done here

    Log To Console            Unconfiguring IP_Address 
    Run Keyword and Continue On Failure    Configuring IP_Address     R1    ${Links_of_R1}    unconfigure
    Log To Console            IP_Address unconfigured in R1
    Run Keyword and Continue On Failure    Configuring IP_Address     R2    ${Links_of_R2}    unconfigure
    Log To Console            IP_Address unconfigured in R2
    Run Keyword and Continue On Failure   Configuring IP_Address      R3    ${Links_of_R3}    unconfigure
    Log To Console            IP_Address unconfigured in R3 
    Run Keyword and Continue On Failure    Configuring IP_Address     R4    ${Links_of_R4}    unconfigure
    Log To Console            IP_Address unconfigured in R4
    Run Keyword and Continue On Failure    Configuring IP_Address     R5    ${Links_of_R5}    unconfigure
    Log To Console            IP_Address unconfigured in R5
		
    Log To Console            Unsetting loopback interface	
    Log To Console            ${Devices}
    :FOR    ${ELEMENT}    IN    @{Devices}
    \    Log To Console    ${ELEMENT}
    \    Setting Loopback interface    ${ELEMENT}    unset
    \    Log To Console    Loopback_address unset in ${ELEMENT}

     
    Log To Console            Disabling password and unset password  
    Run Keyword and Continue On Failure    connect_all    disable
    
Configure IP addresses as per the topology
    
    Log To Console            Configuring IP_Address 
  
Configure ip address

    Log To Console            Configuring IP_Address 
    Run Keyword and Continue On Failure    Configuring IP_Address     R1    ${Links_of_R1}    configure
    Log To Console            IP_Address configured in R1
    Run Keyword and Continue On Failure    Configuring IP_Address     R2    ${Links_of_R2}    configure
    Log To Console            IP_Address configured in R2
    Run Keyword and Continue On Failure   Configuring IP_Address      R3    ${Links_of_R3}    configure
    Log To Console            IP_Address configured in R3 
    Run Keyword and Continue On Failure    Configuring IP_Address     R4    ${Links_of_R4}    configure
    Log To Console            IP_Address configured in R4
    Run Keyword and Continue On Failure    Configuring IP_Address     R5    ${Links_of_R5}    configure
    Log To Console            IP_Address configured in R5
   
Set loopback interface 

    Log To Console            Setting Loopback interface
    Run Keyword and Continue On Failure    Setting Loopback interface    R1    set 
    Log To Console            Loopback_Address configured in R1
    Run Keyword and Continue On Failure    Setting Loopback interface    R2    set 
    Log To Console            Loopback_Address configured in R2  
    Run Keyword and Continue On Failure    Setting Loopback interface    R3    set   
    Log To Console            Loopback_Address configured in R3    
    Run Keyword and Continue On Failure    Setting Loopback interface    R4    set   
    Log To Console            Loopback_Address configured in R4    
    Run Keyword and Continue On Failure    Setting Loopback interface    R5    set   
    Log To Console            Loopback_Address configured in R5 


Configure OSPF within AS2 to advertise the connected networks

    Log To Console             Configuring OSPF 

Enable OSPF in devices present in AS2 and set the ospf neighbors

    Run Keyword and Continue On Failure    Configuring_ospf    R1    ${Process_id}    ${Networks_connected_to_R1}    ${Area1}    enable
    Log To Console            OSPF configured in R1
    Run Keyword and Continue On Failure    Configuring_ospf    R2    ${Process_id}    ${Networks_connected_to_R2}    ${Area1}    enable
    Log To Console            OSPF configured in R2
    Run Keyword and Continue On Failure    Configuring_ospf    R3    ${Process_id}    ${Networks_connected_to_R3}    ${Area1}    enable
    Log To Console            OSPF configured in R3

Configure IBGP and source the BGP updates from the loopback0 interfaces

    Log To Console    Setting IBGP between R2 and R3
    

Enable BGP and advertise the updates from the loopback interface

    Run Keyword and Continue On Failure    Configuring_IBGP    R2    ${AS_id}    ${R3_interface}    enable        
    Log To Console    IBGP configured in R2
    Run Keyword and Continue On Failure    Configuring_IBGP    R3    ${AS_id}    ${R2_interface}    enable              
    Log To Console    IBGP configured in R3

Enable BGP Synchronisation
    
    Log To Console    Enabling BGP synchronization

Enable synchronisation between border routers
    Run Keyword and Continue On Failure    enable_syn    R2    ${AS_id} 
    Run Keyword and Continue On Failure    enable_syn    R3    ${AS_id}


Configure EBGP 
    Log To Console    Configuring EBGP between devices in different autonomous systems



Enable BGP and advertise networks connected outside the autonomous system
     Run Keyword and Continue On Failure    Configuring_EBGP    R2    2    192.168.12.1    1    enable     
     Run Keyword and Continue On Failure    Configuring_EBGP    R4    1    192.168.12.2    2    enable
     Run Keyword and Continue On Failure    Configuring_EBGP    R3    2    192.168.45.5    3    enable
     Run Keyword and Continue On Failure    Configuring_EBGP    R5    3    192.168.45.4    2    enable


*** Keywords ***

Configuring IP_Address   
    [Arguments]    ${device}    ${links}    ${action}
    ${result}=    set_IP    ${device}    ${links}    ${action}
    Run Keyword If    ${result}==False    FAIL    Configuring IP Address on ${device} has failed

Setting Loopback interface    
    [Arguments]    ${device}    ${action}   
    ${result}=    set_loopback    ${device}    ${action}
    Run Keyword If    ${result}==False    FAIL    Configuring Loopback IP on ${device} has failed

Configuring_ospf 
    [Arguments]    ${device}    ${process_id}     ${network_connected}     ${area}    ${action}
    ${result}=    Configure_ospf    ${device}    ${process_id}     ${network_connected}     ${area}    ${action}
    Run Keyword If    ${result}==False    FAIL    Configuring ospf on ${device} has failed


Configuring_IBGP
    [Arguments]    ${device}    ${AS_id}    ${R1_interface}    ${action}
    ${result}=    Configure_IBGP    ${device}    ${AS_id}    ${R1_interface}    ${action} 
    Run Keyword If    ${result}==False    FAIL    Configuring ibgp on ${device} has failed 


Configuring_EBGP
    [Arguments]    ${device}    ${AS_id}    ${R1_interface}    ${neighbor_AS_id}    ${action}
    ${result}=    Configure_EBGP    ${device}    ${AS_id}    ${R1_interface}    ${neighbor_AS_id}    ${action} 
    Run Keyword If    ${result}==False    FAIL    Configuring ebgp on ${device} has failed 


          
   
