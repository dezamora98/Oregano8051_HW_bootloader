# Oregano8051_HW_bootloader

implementation of a hardware bootloader for the Oregano8051 kernel taking advantage of the TmrCtrl hardware and the SIU interface of the Oregano8051 itself.
____

## boot_FCM Diagram

```mermaid
stateDiagram-v2

    [*] --> idle: reset = 0
    idle --> wait_command: en_boot = 1
    wait_command --> wait_size: data_in_ok = 1
    wait_size --> wait_addr_h: data_in_ok = 1
    wait_addr_h --> wait_addr_l: data_in_ok = 1
    wait_addr_l --> wait_code: data_in_ok = 1
    wait_code --> write:  data_in_ok = 1 and command_reg = CMD_WRITE
    wait_code --> read:  data_in_ok = 1 and command_reg = CMD_READ
    wait_code --> idle:  data_in_ok = 1 and command_reg = OTHER
    write --> wait_data: code_reg = CODE_DATA
    write --> idle: code_reg = OTHER
    wait_data --> send_checksum: size_reg = 0
    wait_data --> write_data: size_reg != 0 and data_in_ok = 1
    write_data --> wait_data
    send_checksum --> wait_send_checksum
    wait_send_checksum --> idle: data_out_ok = '1'
    read --> send_data: code_reg = CODE_DATA
    read --> idle: code_reg = OTHER
    send_data --> wait_send_data
    wait_send_data --> send_checksum: size_reg = 0
    wait_send_data --> send_data: size_reg != 0

    note right of wait_command
        when  data_in_ok = 1:
            command_reg = port_data_in
            checksum_reg += port_data_in
    end note

    note right of wait_size
        when  data_in_ok = 1:
            size_reg = port_data_in
            checksum_reg += port_data_in
    end note

    note right of wait_addr_h
        when  data_in_ok = 1:
            addr_reg(15 downto 8) = port_data_in
            checksum_reg += port_data_in
    end note

    note right of wait_addr_l
        when  data_in_ok = 1:
            addr_reg(7 downto 0) = port_data_in
            checksum_reg += port_data_in
    end note

    note left of wait_code
        when  data_in_ok = 1:
            code_reg = port_data_in
            checksum_reg += port_data_in
    end note
    
    note right of write_data
        addr_reg ++
        size_reg --
    end note

    note left of wait_data
        when size_reg = 0:
            checksum_reg = (not checksum) +1
        else:
            checksum_reg += port_data_in
    end note

     note left of wait_send_data
        when size_reg = 0:
            checksum_reg = (not checksum) +1
        else:
            checksum_reg += port_data_in
            addr_reg ++
            size_reg --
    end note
```

____
