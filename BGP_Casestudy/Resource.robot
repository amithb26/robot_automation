*** Settings ***
Documentation     Resource file containing all the PYTHON API implementations.

Library           setup_actions.py
Library           Devices.py
Library           OSPF.py
Library           IBGP.py
Library           String
Variables         variable.py


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

     
    Log To Console            Disabling password and unsetting hostname 
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
    Run Keyword and Continue On Failure    Configuring_EBGP    R2    ${R2_AS_id}    ${R2_einterface}    ${R2_neighbor_AS_id}    enable     
    Run Keyword and Continue On Failure    Configuring_EBGP    R4    ${R4_AS_id}    ${R4_einterface}    ${R4_neighbor_AS_id}    enable
    Run Keyword and Continue On Failure    Configuring_EBGP    R3    ${R3_AS_id}    ${R3_einterface}    ${R3_neighbor_AS_id}    enable
    Run Keyword and Continue On Failure    Configuring_EBGP    R5    ${R5_AS_id}    ${R5_einterface}    ${R5_neighbor_AS_id}    enable

Advertise loopback interface on AS1 and AS3
    Run Keyword and Continue On Failure    advertising_loopback    R4    ${R4_AS_id}    ${R4_interface}    ${mask}
    Run Keyword and Continue On Failure    advertising_loopback    R5    ${R5_AS_id}    ${R5_interface}    ${mask}


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
    [Arguments]    ${device}    ${AS_id}    ${interface}    ${action}
    ${result}=    Configure_IBGP    ${device}    ${AS_id}    ${interface}    ${action} 
    Run Keyword If    ${result}==False    FAIL    Configuring ibgp on ${device} has failed 


Configuring_EBGP
    [Arguments]    ${device}    ${AS_id}    ${interface}    ${neighbor_AS_id}    ${action}
    ${result}=    Configure_EBGP    ${device}    ${AS_id}    ${interface}    ${neighbor_AS_id}    ${action} 
    Run Keyword If    ${result}==False    FAIL    Configuring ebgp on ${device} has failed 


Ensure that different autonomous systems can communicate with each other
    Log To Console    Checking if systems can communicate with each other


Check if ip addresses is set and interface is  up using "show ip interface brief"
    :FOR    ${ELEMENT}    IN    @{Devices}
    \${result}=    Run Keyword and Continue On Failure    checking_operabilty    ${ELEMENT}    show ip interface brief
    \Run Keyword If    ${result}==False    FAIL    ip address not set or interface not up in  ${ELEMENT}  
    
Ensure all networks are reachable from a device using "ping"


Check if OSPF neighbors are established using "show ip ospf neighbor"
    :FOR    ${ELEMENT}    IN    @{Devices}
    \${result}=    Run Keyword and Continue On Failure    checking_operabilty    ${ELEMENT}    show ip ospf neighbor
    \Run Keyword If    ${result}==False    FAIL    neighbor not established ${ELEMENT} 

Check if all routes are learnt by devices  
    :FOR    ${ELEMENT}    IN    @{Devices}
    \${result}=    Run Keyword and Continue On Failure    checking_operabilty    ${ELEMENT}    show ip bgp
    \Run Keyword If    ${result}==False    FAIL    routes not learnt ${ELEMENT}  	 
    
    
   
