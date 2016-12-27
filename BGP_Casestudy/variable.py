Devices = ['R1','R2','R3','R4','R5']





Links_of_R1 = ["Link_R1_R2_1","Link_R1_R3_1"]
Links_of_R2 = ["Link_R1_R2_1","Link_R2_R4_1"]                                
Links_of_R3 = ["Link_R1_R3_1","Link_R3_R5_1"]
Links_of_R4 = ["Link_R2_R4_1"]
Links_of_R5 = ["Link_R3_R5_1"]



#Autonomous systems
# Autonomous system = ['Device1',......] connected in AS2
AS1 = ['R5']
AS2 = ['R1','R2','R3']
AS3 = ['R4']




#AS2
Process_id = 1
Area1 = 0
#Networks_connected_to_('Device') = ["<NID>  <WCM>",.......,"<Loopback address>  <WCM>"] 
Networks_connected_to_R1 = ["192.168.23.0  0.0.0.255","192.168.34.0  0.0.0.255", "3.3.3.0  0.0.0.255"]
Networks_connected_to_R2 = ["192.168.23.0  0.0.0.255","2.2.2.0  0.0.0.255"]
Networks_connected_to_R3 = ["192.168.34.0  0.0.0.255","4.4.4.0  0.0.0.255"]

#BGP













			

























