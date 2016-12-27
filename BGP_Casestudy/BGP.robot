*** Settings ***

Metadata 	Version           1.0
...	        More Info         For more information about Robot Framework see http://robotframework.org
...             Author            Payal Jain 
...             Date              19 Dec 2016  
...	        Executed At  	  ${HOST}
...		Test Framework    Robot Framework Python

Documentation   A test suite with tests for configuring BGP.

...             Topology:-
...                          ____________________________
...                         |             R1         AS2 |
...                         |            /  \            |
...                         |           /    \           |
...                         |         R2      R3         |
...                         |_________|________|_________|
...                                   |        |
...                             ______|__   ___|______
...                            |      AS1| |       AS3|
...                            |    R4   | |   R5     |
...                            |_________| |__________|

...               Testplan Goals:-
...               1. Configure IP addresses as per the topology.
...               2. Each Router should have a loopback0 interface.
...               3. Configure OSPF within AS2 to advertise the loopback0 interfaces.
...                  Don't advertise or run OSPF on the links interconnecting AS1 and AS3.
...               4. Configure IBGP between R2 and R3. Source the BGP updates from the loopback0 interfaces.
...               5. Enable BGP synchronisation.
...               6. Configure EBGP between R2 and R4.
...               7. Configure EBGP between R3 and R5.
...               8. Advertise the loopback0 interfaces on R4 and R5.
...               9. Ensure AS1 and AS3 can communicate with each other without removing the BGP synchronisation command.

Resource          Resource.robot

Suite Setup       Setup Actions

Suite Teardown    Teardown Actions

*** Test Cases ***



Bring_up Phase
    
    Configure IP addresses as per the topology
	    Configure ip address 
	    Set loopback interface


    Configure OSPF within AS2 to advertise the connected networks
	    Enable OSPF in devices present in AS2 and set the ospf neighbors

   
	    

*** Comment ***
    Configure IBGP and source the BGP updates from the loopback0 interfaces
	    STEP 1  Enable BGP 
	    STEP 2  Advertise the updates from the loopback interface

    Enable BGP Synchronisation
	    STEP 1  Enable  synchronisation between border routers

    Configure EBGP 
	    STEP 1  Enable BGP
	    STEP 2  Advertise networks connected outside the autonomous system

    Advertise the loopback interface
	    STEP 1  Advertise loopback interface on AS1 and AS3

*** Comment ***
Operational Phase

    Ensure that different autonomous systems can communicate with each other
	    STEP 1  Check link status
	    STEP 2  Check if BGP neighbors are established
	    STEP 3  Redistribute in order to make routes available in IBGP table
	    STEP 4  Ensure all networks are reachable from a device using commands





     

