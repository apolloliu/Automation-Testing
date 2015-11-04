*** Settings ***
Test Timeout      120 seconds
Library           Selenium2Library
Library           FtpLibrary
Library           HttpLibrary.HTTP
Library           Collections
Library           C:/Python27/Lib/site-packages/MyLibrary/MyRequestsKeywords.py

*** Variables ***
${Corect_Status}    200
${status_code_error}    如果返回status_code为200，说明连接成功，否则失败
${instance_state}    ${TRUE}
${image_name}     ${EMPTY}
#${Instances}     ${FALSE}

*** Test Cases ***
TestDescribeInstances
    ${data}=    Create dictionary    owner=usr-b6fhsw3c    zone=yz    action=DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}

TestRunDescribeDelete
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    Log    ${json["ret_set"][0]["nets"][0]["mac_address"]}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestCreateNet1
    ${data}=    Create dictionary    action    CreateNet    cidr    192.168.20.0/24    enable_dhcp
    ...    ${TRUE}    gateway_ip    192.168.20.1    net_name    opennet    net_type
    ...    public    owner    usr-b6fhsw3c    zone    yz
    Key_CreateNet    ${data}
    Sleep    20s

TestCreateNet2
    ${data}=    Create dictionary    action    CreateNet    cidr    192.168.30.0/24    enable_dhcp
    ...    ${TRUE}    gateway_ip    192.168.30.1    net_name    opennet    net_type
    ...    public    owner    usr-b6fhsw3c    zone    yz
    Key_CreateNet    ${data}
    Sleep    20s

TestCreateKeypairs
    ${data}=    Create dictionary    action    CreateKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz    keypair_name    mykeypair    count    ${1}
    Key_CreateKeypairs    ${data}
    Sleep    20s

TestCreateDisks
    ${data}=    Create dictionary    action    CreateDisks    count    ${1}    disk_name
    ...    Apolloliu    disk_type    sata    owner    usr-b6fhsw3c    size
    ...    ${10}    zone    yz
    Key_CreateDisks    ${data}

TestRebootInstances
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s    #等待主机运行
    #: FOR    ${n}    IN RANGE    0    10000000
    #\    Log    ''
    #\    Test_instance_state
    #\    Run Keyword If    ${instance_state}==${TRUE}    Exit For Loop
    Log    ${resp.content}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RebootInstances    instances    ${tmp_list}
    Key_RebootInstances    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestStopStartInstances
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    StopInstances    instances    ${tmp_list}
    Key_StopInstances    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    StartInstances    instances    ${tmp_list}
    Key_StartInstances    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestUpdateInstances
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}    instance_name    myinstance
    Key_UpdateInstances    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}
    Key_DescribeInstances    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestChangeInstancePassword
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}    password    abcABC123
    Key_ChangeInstancePassword    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestGetInstanceVnc
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}
    Key_GetInstanceVnc    ${data}
    Sleep    10s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestDescribeNets&DescribeInstancesNotInNet
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json}=    To Json    ${resp.content}
    ${tmp_list2}=    Create list    ${json["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstancesNotInNet    net_id    ${json["ret_set"][0]["net_id"]}
    Key_DescribeInstancesNotInNet    ${data}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestDescribeDisks&AttachInstanceDisks&DetachInstanceDisks
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json2}=    To Json    ${resp.content}
    ${tmp_list2}=    Create list    ${json2["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    AttachInstanceDisks    instance_id    ${json["ret_set"][0]["instance_id"]}    disks    ${tmp_list2}
    Key_AttachInstanceDisks    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DetachInstanceDisks    instance_id    ${json["ret_set"][0]["instance_id"]}    disks    ${tmp_list2}
    Key_DetachInstanceDisks    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestAllocateIps&Bind&UnbindInstanceIp&ReleaseIps
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json1}=    To Json    ${resp.content}
    ${data}=    Create dictionary    action    AllocateIps    owner    usr-b6fhsw3c    zone
    ...    yz    ip_name    myip    bandwidth    5    billing_mode
    ...    BW    count    ${1}
    Key_AllocateIps    ${data}
    ${data}=    Create dictionary    action    DescribeIps    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeIps    ${data}
    ${json2}=    To Json    ${resp.content}
    ${ip_list}=    Create list    ${json2["ret_set"][0]["ip_id"]}
    ${data}=    Create dictionary    action    BindInstanceIp    owner    usr-b6fhsw3c    zone
    ...    yz    instance_id    ${json1["ret_set"][0]["instance_id"]}    ip_id    ${json2["ret_set"][0]["ip_id"]}    mac_address
    ...    ${json1["ret_set"][0]["nets"][0]["mac_address"]}
    Key_BindInstanceIp    ${data}
    Sleep    20s
    ${data}=    Create dictionary    action    UnbindInstanceIp    owner    usr-b6fhsw3c    zone
    ...    yz    ip_id    ${json2["ret_set"][0]["ip_id"]}
    Key_UnbindInstanceIp    ${data}
    ${data}=    Create dictionary    action    ReleaseIps    owner    usr-b6fhsw3c    zone
    ...    yz    ips    ${ip_list}
    Key_ReleaseIps    ${data}
    ${tmp_list}=    Create list    ${json1["ret_set"][0]["instance_id"]}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestResizeInstances
    [Tags]    Instances
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    ResizeInstance    instance_id    ${json["ret_set"][0]["instance_id"]}    instance_type_id    c4m8d40
    Key_ResizeInstances    ${data}
    Sleep    20s
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

Test_SingleMonitors
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    SingleMonitors    owner    usr-b6fhsw3c    zone
    ...    yz    instance_id    ${json["ret_set"][0]["instance_id"]}    data_fmt    real_time_data
    Key_SingleMonitors    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

Test_MultiMonitors
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json1}    To Json    ${resp.content}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myinstance    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json2}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json1["ret_set"][0]["instance_id"]}    ${json2["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    MultiMonitors    owner    usr-b6fhsw3c    zone
    ...    yz    item    CPU_USAGE    data_fmt    real_time_data
    Key_MultiMonitors    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestAttach&DetachKeypair
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json1}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json1["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json2}    To Json    ${resp.content}
    ${instances}=    create list    ${json2["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    AttachKeypair    keypair_id    ${json1["ret_set"][0]["keypair_id"]}    instances    ${instances}
    Key_AttachKeypair    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DetachKeypair    keypair_id    ${json1["ret_set"][0]["keypair_id"]}    instances    ${instances}
    Key_DetachKeypair    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${instances}
    Key_DeleteInstances    ${data}

TestCreate&DescribeBackups&DescribeBackupConfig&DeleteBackups
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    Apolloliu    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}=    To Json    ${resp.content}
    ${tmp_list}=    Create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    CreateBackups    resource_id    ${json["ret_set"][0]["instance_id"]}    backup_name
    ...    disk_bak_1    zone    yz    owner    usr-b6fhsw3c
    Key_CreateBackups    ${data}
    Sleep    20s
    ${data}=    Create dictionary    action    DescribeBackups    backup_type    instance    resource_id
    ...    ${json["ret_set"][0]["instance_id"]}    zone    yz    owner    usr-b6fhsw3c
    ${resp}=    Key_DescribeBackups    ${data}
    ${json}=    To Json    ${resp.content}
    ${data}=    Create dictionary    action    DescribeBackupConfig    zone    yz    owner
    ...    usr-b6fhsw3c    backup_id    ${json["ret_set"][0]["backup_id"]}
    Key_DescribeBackupConfig    ${data}
    #Key_RestoreBackups
    ${tmp_list2}=    Create list    ${json["ret_set"][0]["backup_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteBackups    backups    ${tmp_list2}
    Key_DeleteBackups    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestRun
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    Log    ${json["ret_set"][0]["nets"][0]["mac_address"]}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz

TestRebootInstancesC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s    #等待主机运行
    #: FOR    ${n}    IN RANGE    0    10000000
    #\    Log    ''
    #\    Test_instance_state
    #\    Run Keyword If    ${instance_state}==${TRUE}    Exit For Loop
    Log    ${resp.content}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RebootInstances    instances    ${tmp_list}
    Key_RebootInstances    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestStopStartInstancesC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    StopInstances    instances    ${tmp_list}
    Key_StopInstances    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    StartInstances    instances    ${tmp_list}
    Key_StartInstances    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestUpdateInstancesC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}    instance_name    myinstance
    Key_UpdateInstances    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}
    Key_DescribeInstances    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestChangeInstancePasswordC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}    password    abcABC123
    Key_ChangeInstancePassword    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestGetInstanceVncC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances    instance_id    ${json["ret_set"][0]["instance_id"]}
    Key_GetInstanceVnc    ${data}
    Sleep    10s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestDescribeNets&DescribeInstancesNotInNetC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json}=    To Json    ${resp.content}
    ${tmp_list2}=    Create list    ${json["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstancesNotInNet    net_id    ${json["ret_set"][0]["net_id"]}
    Key_DescribeInstancesNotInNet    ${data}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestDescribeDisks&DetachInstanceDisksC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json2}=    To Json    ${resp.content}
    ${tmp_list2}=    Create list    ${json2["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DetachInstanceDisks    instance_id    ${json["ret_set"][0]["instance_id"]}    disks    ${tmp_list2}
    Key_DetachInstanceDisks    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestAllocateIps&Bind&UnbindInstanceIp&ReleaseIpsC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json1}=    To Json    ${resp.content}
    ${data}=    Create dictionary    action    AllocateIps    owner    usr-b6fhsw3c    zone
    ...    yz    ip_name    myip    bandwidth    5    billing_mode
    ...    BW    count    ${1}
    Key_AllocateIps    ${data}
    ${data}=    Create dictionary    action    DescribeIps    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeIps    ${data}
    ${json2}=    To Json    ${resp.content}
    ${ip_list}=    Create list    ${json2["ret_set"][0]["ip_id"]}
    ${data}=    Create dictionary    action    BindInstanceIp    owner    usr-b6fhsw3c    zone
    ...    yz    instance_id    ${json1["ret_set"][0]["instance_id"]}    ip_id    ${json2["ret_set"][0]["ip_id"]}    mac_address
    ...    ${json1["ret_set"][0]["nets"][0]["mac_address"]}
    Key_BindInstanceIp    ${data}
    Sleep    20s
    ${data}=    Create dictionary    action    UnbindInstanceIp    owner    usr-b6fhsw3c    zone
    ...    yz    ip_id    ${json2["ret_set"][0]["ip_id"]}
    Key_UnbindInstanceIp    ${data}
    ${data}=    Create dictionary    action    ReleaseIps    owner    usr-b6fhsw3c    zone
    ...    yz    ips    ${ip_list}
    Key_ReleaseIps    ${data}
    ${tmp_list}=    Create list    ${json1["ret_set"][0]["instance_id"]}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestResizeInstancesC
    [Tags]    Instances
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    ResizeInstance    instance_id    ${json["ret_set"][0]["instance_id"]}    instance_type_id    c4m8d40
    Key_ResizeInstances    ${data}
    Sleep    20s
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

Test_SingleMonitorsC
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    SingleMonitors    owner    usr-b6fhsw3c    zone
    ...    yz    instance_id    ${json["ret_set"][0]["instance_id"]}    data_fmt    real_time_data
    Key_SingleMonitors    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

Test_MultiMonitorsC
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json1}    To Json    ${resp.content}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myinstance    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${none_list}    nets    ${none_list}    use_basenet
    ...    ${TRUE}    security_groups    ${tmp_list}    login_mode    PWD    login_keypair
    ...    ""    login_password    ABCabc123    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json2}    To Json    ${resp.content}
    ${tmp_list}=    create list    ${json1["ret_set"][0]["instance_id"]}    ${json2["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    MultiMonitors    owner    usr-b6fhsw3c    zone
    ...    yz    item    CPU_USAGE    data_fmt    real_time_data
    Key_MultiMonitors    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

TestDetachKeypairC
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json2}    To Json    ${resp.content}
    ${instances}=    create list    ${json2["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    AttachKeypair    keypair_id    ${json1["ret_set"][0]["keypair_id"]}    instances    ${instances}
    Key_AttachKeypair    ${data}
    Sleep    20s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DetachKeypair    keypair_id    ${json1["ret_set"][0]["keypair_id"]}    instances    ${instances}
    Key_DetachKeypair    ${data}
    Sleep    20s
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${instances}
    Key_DeleteInstances    ${data}

TestCreate&DescribeBackups&DescribeBackupConfig&DeleteBackupsC
    ${data}=    Create dictionary    action    DescribeNets    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeNets    ${data}
    ${json3}=    To Json    ${resp.content}
    ${netid_list}=    Create list    ${json3["ret_set"][0]["net_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeDisks
    ${resp}=    Key_DescribeDisks    ${data}
    ${json4}=    To Json    ${resp.content}
    ${diskid_list}=    Create list    ${json4["ret_set"][0]["disk_id"]}
    ${data}=    Create dictionary    action    DescribeKeypairs    owner    usr-b6fhsw3c    zone
    ...    yz
    ${resp}=    Key_DescribeKeypairs    ${data}
    ${json5}=    To Json    ${resp.content}
    ${keypairid_list}=    Create list    ${json5["ret_set"][0]["keypair_id"]}
    ${tmp_list}=    create list    sg-desgsj6d
    ${none_list}=    create list
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    RunInstances    instance_name    myins    image_id    img-3c799f82    instance_type_id
    ...    c1m1d20    disks    ${diskid_list}    nets    ${netid_list}    use_basenet
    ...    ${FALSE}    security_groups    ${tmp_list}    login_mode    KEY    login_keypair
    ...    ${json5["ret_set"][0]["keypair_id"]}    count    ${1}
    ${resp}=    Key_RunInstances    ${data}
    Sleep    40s
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    Key_DescribeInstances    ${data}
    ${json}=    To Json    ${resp.content}
    ${tmp_list}=    Create list    ${json["ret_set"][0]["instance_id"]}
    ${data}=    Create dictionary    action    CreateBackups    resource_id    ${json["ret_set"][0]["instance_id"]}    backup_name
    ...    disk_bak_1    zone    yz    owner    usr-b6fhsw3c
    Key_CreateBackups    ${data}
    Sleep    20s
    ${data}=    Create dictionary    action    DescribeBackups    backup_type    instance    resource_id
    ...    ${json["ret_set"][0]["instance_id"]}    zone    yz    owner    usr-b6fhsw3c
    ${resp}=    Key_DescribeBackups    ${data}
    ${json}=    To Json    ${resp.content}
    ${data}=    Create dictionary    action    DescribeBackupConfig    zone    yz    owner
    ...    usr-b6fhsw3c    backup_id    ${json["ret_set"][0]["backup_id"]}
    Key_DescribeBackupConfig    ${data}
    #Key_RestoreBackups
    ${tmp_list2}=    Create list    ${json["ret_set"][0]["backup_id"]}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteBackups    backups    ${tmp_list2}
    Key_DeleteBackups    ${data}
    ${data}=    create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DeleteInstances    instances    ${tmp_list}
    Key_DeleteInstances    ${data}

*** Keywords ***
Key_DescribeInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "DescribeInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "DescribeInstances测试出错！"
    Log    "DescribeInstances测试成功！"
    [Return]    ${resp}

Key_RunInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "RunInstances测试成功！"
    [Return]    ${resp}

Key_StopInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "StopInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "StopInstances测试出错！"
    Log    "StopInstances通过全部测试！"

Key_StartInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "StartInstances通过全部测试！"

Key_RebootInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "RebootInstances测试成功！"

Key_UpdateInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${tmp}=    Create list    sg-desgsj6d
    ${None_list}=    create list
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "UpdateInstances通过全部测试！"

Key_GetInstanceVnc
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${tmp}=    Create list    sg-desgsj6d
    ${None_list}=    create list
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "GetInstanceVnc通过全部测试！"

Key_DeleteInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "DeleteInstances通过测试！"
    [Return]    ${resp}

Key_RebuildInstance
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${tmp}=    Create list    sg-desgsj6d
    ${None_list}=    create list
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${get_state}=    Test_status_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    ${get_state}=    Test_ret_code    ${resp}
    Run Keyword If    ${get_state}==${FALSE}    Fatal Error    "RunInstances测试出错！"
    Log    "RebuildInstance通过全部测试！"

Key_ResizeInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${tmp}=    Create list    sg-desgsj6d
    ${None_list}=    create list
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ResizeInstances通过全部测试！"

Key_ResizeInstanceConfirm
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ResizeInstanceConfirm通过全部测试！"

Key_RevertInstanceResize
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RevertInstanceResize通过全部测试！"

Key_ChangeInstancePassword
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ChangeInstancePassword通过全部测试！"

Key_AttachInstanceDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "AttachInstanceDisks通过全部测试！"

Key_DetachInstanceDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DetachInstanceDisks通过全部测试！"

Key_BindInstanceIp
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "BindInstanceIp通过全部测试！"

Key_UnbindInstanceIp
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "UnBindInstanceIp通过全部测试！"

Key_DescribeInstancesNotInNet
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeInstancesNotInNet通过全部测试！"

Key_CreateDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateDisks通过全部测试！"

Key_DescribeDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeDisks通过全部测试！"
    [Return]    ${resp}

Key_DeleteDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${tmp_list}=    Create list    d-7pvy9ks5    d-n5jv6cke
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteDisks通过全部测试！"

Key_ResizeDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ResizeDisks通过全部测试！"

Key_RenameDisks
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RenameDisks通过全部测试！"

Key_DescribeImages
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Log    "DescribeImages通过全部测试！"

Key_CreateRouters
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateRouters通过全部测试！"

Key_DeleteRouters
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteRouters通过全部测试！"

Key_DescribeRouters
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeRouters通过全部测试！"
    [Return]    ${resp}

Key_UpdateRouter
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "UpdateRouter通过全部测试！"

Key_EnableRouterGateway
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "EnableRouterGateway通过全部测试！"

Key_DisableRouterGateway
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DisableRouterGateway通过全部测试！"

Key_JoinRouter
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "JoinRouter通过全部测试！"

Key_LeaveRouter
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "LeaveRouter通过全部测试！"

Key_DescribeKeypairs
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeKeypairs通过全部测试！"
    [Return]    ${resp}

Key_CreateKeypairs
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateKeypairs通过全部测试！"

Key_DeleteKeypairs
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteKeypairs通过全部测试！"

Key_UpdateKeypairs
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "UpdateKeypairs通过全部测试！"

Key_AttachKeypair
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "AttachKeypair通过全部测试！"

Key_DetachKeypair
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${tmp_list}    create list    i-2g3m9dev
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DetachKeypair通过全部测试！"

Key_DescribeSecurityGroup
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeSecurityGroup通过全部测试！"

Key_DescribeRecords
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeRecords通过全部测试！"

Key_DescribeTickets
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeTickets通过全部测试！"

Key_DescribeTicketDialogs
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeTicketDialogs通过全部测试！"

Key_CloseTicket
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CloseTicket通过全部测试！"

Key_CreateTicket
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateTicket通过全部测试！"

Key_CreateTicketDialog
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateTicketDialog通过全部测试！"

Key_QueryBillingPattern
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "QueryBillingPattern通过全部测试！"

Key_QueryBillingPrice
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "QueryBillingPrice通过全部测试！"

Key_PredictBillingCost
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "PredictBillingCost通过全部测试！"

Key_QueryBillingFlow
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "QueryBillingFlow通过全部测试！"
    [Return]    ${resp}

Key_DescribeBillingResource
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeBillingResource通过全部测试！"

Key_CreateBackups
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateBackups通过全部测试！"

Key_DescribeBackups
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeBackups通过全部测试！"
    [Return]    ${resp}

Key_DeleteBackups
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteBackups通过全部测试！"

Key_ModifyBackups
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ModifyBackups通过全部测试！"

Key_RestoreBackups
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RestoreBackups通过全部测试！"

Key_RestoreBackupToNew
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RestoreBackupToNew通过全部测试！"

Key_DescribeBackupConfig
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeBackupConfig通过全部测试！"

Key_CreateSecurityGroup
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateSecurityGroup通过全部测试！"

Key_DeleteSecurityGroup
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteSecurityGroup通过全部测试！"

Key_DescribeSecurityGroupByInstance
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeSecurityGroupByInstance通过全部测试！"

Key_GrantSecurityGroup
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "GrantSecurityGroup通过全部测试！"

Key_RemoveSecurityGroup
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RemoveSecurityGroup通过全部测试！"

Key_CreateSecurityGroupDefaultRule
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateSecurityGroupDefaultRule通过全部测试！"

Key_DeleteSecurityGroupDefaultRule
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteSecurityGroupDefaultRule通过全部测试！"

Key_UpdateSecurityGroupRule
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "UpdateSecurityGroupRule通过全部测试！"

Key_RenameSecurityGroup
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RenameSecurityGroup通过全部测试！"

Key_CreateNet
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "CreateNet通过全部测试！"

Key_DeleteNets
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DeleteNets通过全部测试！"

Key_DescribeNets
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeNets通过全部测试！"
    [Return]    ${resp}

Key_ModifyNet
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ModifyNet通过全部测试！"

Key_DescribeNetInstances
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeNetInstances通过全部测试！"

Key_JoinNet1
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "JoinNet1通过全部测试！"

Key_JoinNets2
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "JoinNets2通过全部测试！"

Key_LeaveNets
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "LeaveNets通过全部测试！"

Key_JoinbaseNet
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "JoinbaseNet通过全部测试！"

Key_LeavebaseNet
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "通过全部测试！"

Key_DescribeNetsJoinableForInstance
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "LeavebaseNet通过全部测试！"

Key_DescribeQuotas
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "通过全部测试！"

Key_DescribeQuotasAll
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeQuotasAll通过全部测试！"

Key_AllocateIps
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "AllocateIps通过全部测试！"

Key_DescribeIps
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeIps通过全部测试！"
    [Return]    ${resp}

Key_ModifyIpsBillingMode
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ModifyIpsBillingMode通过全部测试！"

Key_ModifyIpsBandwidth
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ModifyIpsBandwidth通过全部测试！"

Key_ModifyIpsName
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ModifyIpsName通过全部测试！"

Key_ReleaseIps
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "ReleaseIps通过全部测试！"

Key_SingleMonitors
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "SingleMonitors通过全部测试！"

Key_MultiMonitors
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "MultiMonitors通过全部测试！"

Key_DescribeWalletsBalance
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeWalletsBalance通过全部测试！"

Key_DescribeWalletsRechargeRecords
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeWalletsRechargeRecords通过全部测试！"

Key_DescribeWalletsSettleRecords
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "DescribeWalletsSettleRecords通过全部测试！"

Key_RechargeWallet
    [Arguments]    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://console.cloudin.cn    headers=${headers}
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    Test_status_code    ${resp}
    Test_ret_code    ${resp}
    Log    "RechargeWallet通过全部测试！"

Test_status_code
    [Arguments]    ${resp}
    ${get_state}=    Set Variable    ${FALSE}
    #Run Keyword If    int(${resp.status_code})==200    ${Instances}=    Set Variable    false
    ${get_state}=    Set Variable If    int(${resp.status_code})==200    ${TRUE}
    Run Keyword If    int(${resp.status_code})==200    Log    '连接成功,通过连接测试'
    Run Keyword If    int(${resp.status_code})==201    Log    "已创建"
    Run Keyword If    int(${resp.status_code})==202    Log    '接收'
    Run Keyword If    int(${resp.status_code})==203    Log    '非认证信息'
    Run Keyword If    int(${resp.status_code})==204    Log    '无内容'
    Run Keyword If    int(${resp.status_code})==205    Log    '重置内容'
    Run Keyword If    int(${resp.status_code})==206    Log    '部分内容'
    Run Keyword If    int(${resp.status_code})==300    Log    '多路选择'
    Run Keyword If    int(${resp.status_code})==301    Log    '永久转移'
    Run Keyword If    int(${resp.status_code})==302    Log    '暂时转移'
    Run Keyword If    int(${resp.status_code})==303    Log    '参见其它'
    Run Keyword If    int(${resp.status_code})==304    Log    '未修改'
    Run Keyword If    int(${resp.status_code})==305    Log    '使用代理'
    Run Keyword If    int(${resp.status_code})==400    Log    '错误请求'
    Run Keyword If    int(${resp.status_code})==401    Log    '未认证'
    Run Keyword If    int(${resp.status_code})==402    Log    '需要付费'
    Run Keyword If    int(${resp.status_code})==403    Log    '禁止'
    Run Keyword If    int(${resp.status_code})==404    Log    '未找到'
    Run Keyword If    int(${resp.status_code})==405    Log    '方法不允许'
    Run Keyword If    int(${resp.status_code})==406    Log    '不接受'
    Run Keyword If    int(${resp.status_code})==407    Log    '需要代理认证'
    Run Keyword If    int(${resp.status_code})==408    Log    '请求超时'
    Run Keyword If    int(${resp.status_code})==409    Log    '冲突'
    Run Keyword If    int(${resp.status_code})==410    Log    '失败'
    Run Keyword If    int(${resp.status_code})==411    Log    '需要长度'
    Run Keyword If    int(${resp.status_code})==412    Log    '条件失败'
    Run Keyword If    int(${resp.status_code})==413    Log    '请求实体太大'
    Run Keyword If    int(${resp.status_code})==414    Log    '请求URI太长'
    Run Keyword If    int(${resp.status_code})==415    Log    '不支持媒体类型'
    Run Keyword If    int(${resp.status_code})==500    Log    '服务器内部错误'
    Run Keyword If    int(${resp.status_code})==501    Log    '未实现'
    Run Keyword If    int(${resp.status_code})==502    Log    '网关失败'
    Run Keyword If    int(${resp.status_code})==504    Log    '网关超时'
    Run Keyword If    int(${resp.status_code})==505    Log    'HTTP版本不支持'
    Should Be Equal As Strings    ‘${resp.status_code}’    ‘200’
    [Return]    ${get_state}

Test_ret_code
    [Arguments]    ${resp}
    ${json}    To Json    ${resp.content}
    ${get_state}=    Set Variable    ${FALSE}
    ${get_state}=    Set Variable If    int(${json["ret_code"]})==0    ${TRUE}
    Log    "如果有返回的api中有ret_code，则通过下面的测试，否则说明不存在！"
    Should Contain    ‘${json}    'ret_code'
    Log    "如果有ret_code则通过前一项测试！"
    Log    "下面对ret_code进行测试，并返回测试结果："
    Run Keyword If    int(${json["ret_code"]})==0    Log    '获取ret_code成功'
    Run Keyword If    int(${json["ret_code"]})!=0    Log    '出现错误！ret_code值不为0，错误为：'
    Run Keyword If    int(${json["ret_code"]})==90001    Log    'PARAMETER_ERROR'
    Run Keyword If    int(${json["ret_code"]})==90002    Log    "REQUEST_API_ERROR"
    Run Keyword If    int(${json["ret_code"]})==90003    Log    "REQUEST_API_UNRESPONSIVE"
    Run Keyword If    int(${json["ret_code"]})==90004    Log    "REQUEST_API_FORBIDDEN"
    Run Keyword If    int(${json["ret_code"]})==90005    Log    "REQUEST_API_NOT_FOUND"
    Run Keyword If    int(${json["ret_code"]})==90006    Log    "REQUEST_API_INTERNAL_ERROR"
    Run Keyword If    int(${json["ret_code"]})==90007    Log    "REQUEST_API_SERVICE_BUSY"
    Run Keyword If    int(${json["ret_code"]})==90008    Log    "REQUEST_API_RESOURCE_INSUFFICIENT"
    Run Keyword If    int(${json["ret_code"]})==90009    Log    "REQUEST_API_SERVE_UPDATING"
    Run Keyword If    int(${json["ret_code"]})==90100    Log    "UNKNOWN_ERROR"
    Run Keyword If    int(${json["ret_code"]})==12001    Log    "BALANCE_NOT_ENOUGH"
    Run Keyword If    int(${json["ret_code"]})==15001    Log    "INSTANCE_LOGIN_PARAMETER_FAILED"
    Run Keyword If    int(${json["ret_code"]})==15002    Log    "RUN_INSTANCES_FAILED"
    Run Keyword If    int(${json["ret_code"]})==15003    Log    "DESCRIBE_INSTANCES_FAILED"
    Run Keyword If    int(${json["ret_code"]})==15004    Log    "DELETE_INSTANCES_FAILED"
    Run Keyword If    int(${json["ret_code"]})==15005    Log    "UPDATE_INSTANCE_FAILED"
    Run Keyword If    int(${json["ret_code"]})==15006    Log    "INVALID_INSTANCE_TYPE"
    Run Keyword If    int(${json["ret_code"]})==15007    Log    "INVALID_MAC_ADDRESS"
    Run Keyword If    int(${json["ret_code"]})==15008    Log    "INVALID_IP_STATUS"
    Run Keyword If    int(${json["ret_code"]})==15009    Log    "DUPLICATED_NETWORK"
    Run Keyword If    int(${json["ret_code"]})==15010    Log    "INVALID_INSTANCE_STATE"
    Run Keyword If    int(${json["ret_code"]})==15011    Log    "ATTACHED_DISKS_LIMIT_EXCEED"
    Run Keyword If    int(${json["ret_code"]})==15012    Log    "INSTANCE_NOT_FOUND"
    Run Keyword If    int(${json["ret_code"]})==18001    Log    "DELETE_NET_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18002    Log    "JOIN_NET_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18003    Log    "JOIN_NETS_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18004    Log    "LEAVE_NETS_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18005    Log    "JOIN_BASE_NET_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18006    Log    "LEAVE_BASE_NET_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18007    Log    "SAVE_NET_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18008    Log    "SAVE_NETWORK_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18009    Log    "GET_NETWORK_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18010    Log    "JOIN_PUBLIC_NET_CONFLICT"
    Run Keyword If    int(${json["ret_code"]})==18011    Log    "GET_NET_FAILED"
    Run Keyword If    int(${json["ret_code"]})==18012    Log    "JOIN_NET_DUPLICATE"
    Run Keyword If    int(${json["ret_code"]})==21001    Log    "ROUTER_EXTERNAL_GATEWAY_DISABLE"
    Run Keyword If    int(${json["ret_code"]})==21002    Log    "PRIVATE_NET_JOIN_ROUTER_DISABLE"
    Run Keyword If    int(${json["ret_code"]})==11001    Log    "SAVE_BACKUP_FAILD"
    Run Keyword If    int(${json["ret_code"]})==11002    Log    'BACKUP_NOT_FOUND'
    Run Keyword If    int(${json["ret_code"]})==11003    Log    'DELETE_BACKUP_FAILED'
    Run Keyword If    int(${json["ret_code"]})==11004    Log    'ASSOCIATE_INSTANCE_NOT_FOUND'
    Run Keyword If    int(${json["ret_code"]})==11005    Log    'ASSOCIATE_DISK_NOT_FOUND'
    Run Keyword If    int(${json["ret_code"]})==11006    Log    'RESTORE_RESOURCE_NOT_FOUND'
    Run Keyword If    int(${json["ret_code"]})==11007    Log    'CONFIG_FOR_INSTANCE_BAKCUP_NOT_FOUND'
    Run Keyword If    int(${json["ret_code"]})==13001    Log    'CREATE_DISK_FAILED'
    Run Keyword If    int(${json["ret_code"]})==13002    Log    'DELETE_DISK_FAILED'
    Run Keyword If    int(${json["ret_code"]})==13003    Log    'DISK_RENAME_FAILED'
    Run Keyword If    int(${json["ret_code"]})==22001    Log    'SECURITY_GROUP_NOT_FOUND'
    Run Keyword If    int(${json["ret_code"]})==22002    Log    'CREATE_SECURITY_GROUP_FAILED'
    Run Keyword If    int(${json["ret_code"]})==22003    Log    'SAVE_SECURITY_GROUP_FAILED'
    Run Keyword If    int(${json["ret_code"]})==22004    Log    'DEFAULT_SECURITY_CANNOT_MODIFIED'
    Run Keyword If    int(${json["ret_code"]})==22005    Log    'SAVE_SECURITY_GROUP_RULE_FAILED'
    Run Keyword If    int(${json["ret_code"]})==22006    Log    'SECURITY_GROUP_RENAME_FAILED'
    Run Keyword If    int(${json["ret_code"]})==22007    Log    'ONE_SECURITY_PER_INSTANCE_ERROR'
    Run Keyword If    int(${json["ret_code"]})==19001    Log    'QUOTA_QUERY_FAILED'
    Run Keyword If    int(${json["ret_code"]})==19002    Log    'QUOTA_EXCEED'
    Run Keyword If    int(${json["ret_code"]})==19003    Log    'QUOTA_MODIFICATION_ERROR'
    Should Be Equal    '${json["ret_code"]}'    '0'
    Log    'ret_code测试正常！'
    [Return]    ${get_state}

Test_instance_state
    ${headers}=    Create Dictionary    Content-Type    application/json
    Create Session    Cloudin    https://cloudin.cn    headers=${headers}
    ${data}=    Create dictionary    owner    usr-b6fhsw3c    zone    yz    action
    ...    DescribeInstances
    ${resp}=    MyRequestsKeywords.Post    Cloudin    /api/    data=${data}
    ${json}    To Json    ${resp.content}
    Log    "下面对instance_state进行测试，并返回测试结果："
    ${instance_state}=    set variable If    '${json['ret_set'][0]['instance_state']}'=='active'    ${TRUE}    ${FALSE}
    Log    'instance_state测试正常！'
