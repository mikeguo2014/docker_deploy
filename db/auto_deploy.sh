#!/bin/bash

# set -x

cur_dir=$(
    cd "$(dirname "$0")"
    pwd
)

# 数据库目录结构
# ${cur_dir}/
#       ├── mysql5/ 
#           ├── conf
#           ├── data
#       ├── mysql8/
#           ├── conf
#           ├── data
#       ├── neo4j/
#           ├── conf
#           ├── data
#       ├── mongo3/
#           ├── conf
#           ├── data
#       ├── mongo4/
#           ├── conf
#           ├── data
#       ├── mongo4_auth/
#           ├── conf
#           ├── data
#       └── redis/
#           ├── conf
#           └── data
#       └── gbase8a/
#           ├── conf
#           └── data
#       └── redis/
#           ├── conf
#           └── data
#       └── opengauss_5432/
#           ├── conf
#           └── data

# 初始化设置
# mysql5配置
mysql5_docker_image=nexus.ahi.internal:5000/mysql:5.6
mysql5_container_name=ahi_mysql5_3306
mysql5_port_in_docker=3306
mysql5_port=3306
mysql5_conf_path=${cur_dir}/mysql5/conf
mysql5_data_path=${cur_dir}/mysql5/data
mysql5_init_password=AHIbackend_2019

function deploy_mysql5() {

    if [ -d ${mysql5_data_path} ]; then
        echo "[INFO] mysql5 数据目录已存在 ${mysql5_data_path}"
    else
        echo "[INFO] mysql5 数据目录不存在, 新建数据目录 ${mysql5_data_path}"
        mkdir -p ${mysql5_data_path}
    fi

    echo "[INFO] 启动 ${mysql5_container_name} ..."

    docker run \
        -d \
        --name ${mysql5_container_name} \
        -p ${mysql5_port}:${mysql5_port_in_docker} \
        -e MYSQL_ROOT_PASSWORD=${mysql5_init_password} \
        -e MYSQL_DATABASE=ahi_ml_platform \
        -v ${mysql5_data_path}:/var/lib/mysql \
        ${mysql5_docker_image}

    echo "[INFO] 启动 ${mysql5_container_name} 成功 !"
}

# mysql5.7配置
mysql57_docker_image=nexus.ahi.internal:5000/mysql:5.7
mysql57_container_name=ahi_mysql57_3307
mysql57_port_in_docker=3306
mysql57_port=3307
mysql57_conf_path=${cur_dir}/mysql57/conf
mysql57_data_path=${cur_dir}/mysql57/data
mysql57_init_password=AHIbackend_2019

function deploy_mysql57() {

    if [ -d ${mysql57_data_path} ]; then
        echo "[INFO] mysql57 数据目录已存在 ${mysql57_data_path}"
    else
        echo "[INFO] mysql57 数据目录不存在, 新建数据目录 ${mysql57_data_path}"
        mkdir -p ${mysql57_data_path}
    fi

    echo "[INFO] 启动 ${mysql57_container_name} ..."

    docker run \
        -d \
        --name ${mysql57_container_name} \
        -p ${mysql57_port}:${mysql57_port_in_docker} \
        -e MYSQL_ROOT_PASSWORD=${mysql57_init_password} \
        -e MYSQL_DATABASE=ahi_ml_platform \
        -v ${mysql57_data_path}:/var/lib/mysql \
        ${mysql57_docker_image}

    echo "[INFO] 启动 ${mysql57_container_name} 成功 !"
}

# mysql8配置
mysql8_docker_image=mysql:8
mysql8_container_name=ahi_mysql8_3308
mysql8_port_in_docker=3306
mysql8_port=3308
mysql8_conf_path=${cur_dir}/mysql8/conf
mysql8_data_path=${cur_dir}/mysql8/data
mysql8_init_password=AHIbackend_2019

# mysql8 初始化
# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'AHIbackend_2019';
# grant all PRIVILEGES on *.* to root@'%' WITH GRANT OPTION;	
# flush privileges;

function deploy_mysql8() {

    docker rm -f ${mysql8_container_name}

    if [ -d ${mysql8_data_path} ]; then
        echo "[INFO] mysql8 数据目录已存在 ${mysql8_data_path}"
    else
        echo "[INFO] mysql8 数据目录不存在, 新建数据目录 ${mysql8_data_path}"
        mkdir -p ${mysql8_data_path}
    fi

    echo "[INFO] 启动 ${mysql8_container_name} ..."

    docker run \
        -d \
        --name ${mysql8_container_name} \
        -p ${mysql8_port}:${mysql8_port_in_docker} \
        -e MYSQL_ROOT_PASSWORD=${mysql8_init_password} \
        -v ${mysql8_data_path}:/var/lib/mysql \
        ${mysql8_docker_image}

    echo "[INFO] 启动 ${mysql8_container_name} 成功 !"
}

        #${mysql8_docker_image} --default-authentication-plugin=mysql_native_password

# neo4j配置
neo4j_docker_image=nexus.ahi.internal:5000/neo4j
neo4j_container_name=ahi_neo4j_7474
neo4j_port_in_docker=7474
neo4j_port=7474
neo4j_conf_path=${cur_dir}/neo4j/conf
neo4j_data_path=${cur_dir}/neo4j/data

function deploy_neo4j() {

    if [ -d ${neo4j_data_path} ]; then
        echo "[INFO] neo4j 数据目录已存在 ${neo4j_data_path}"
    else
        echo "[INFO] neo4j 数据目录不存在, 新建数据目录 ${neo4j_data_path}"
        mkdir -p ${neo4j_data_path}
    fi

    echo "[INFO] 启动 ${neo4j_container_name} ..."
    docker run \
        -d \
        --name ${neo4j_container_name} \
        -p ${neo4j_port}:${neo4j_port_in_docker} \
        -p 7687:7687 \
        --env=NEO4J_dbms_memory_pagecache_size=50G \
        --env=NEO4J_dbms_memory_heap_initial__size=16G \
        --env=NEO4J_dbms_memory_heap_max__size=16G \
        --env=NEO4J_AUTH=neo4j/ahi2017 \
        -v ${neo4j_data_path}:/data \
	-v ${performance_neo4j_import_path}:/var/lib/neo4j/import \
        ${neo4j_docker_image}

    echo "[INFO] 启动 ${neo4j_container_name} 成功 !"
}


# 性能neo4j配置
performance_neo4j_docker_image=nexus.ahi.internal:5000/neo4j
performance_neo4j_container_name=ahi_performance_neo4j_7475
performance_neo4j_port_in_docker=7474
performance_neo4j_port=7475
performance_neo4j_conf_path=${cur_dir}/neo4j/conf
performance_neo4j_data_path=${cur_dir}/neo4j/performance_data
performance_neo4j_import_path=${cur_dir}/neo4j/import_csv

function deploy_performance_neo4j() {

    if [ -d ${performance_neo4j_data_path} ]; then
        echo "[INFO] neo4j 数据目录已存在 ${performance_neo4j_data_path}"
    else
        echo "[INFO] neo4j 数据目录不存在, 新建数据目录 ${performance_neo4j_data_path}"
        mkdir -p ${performance_neo4j_data_path}
    fi

    echo "[INFO] 启动 ${performance_neo4j_container_name} ..."
    docker run \
        -d \
        --name ${performance_neo4j_container_name} \
        -p ${performance_neo4j_port}:${performance_neo4j_port_in_docker} \
        -p 7688:7687 \
        --env=NEO4J_dbms_memory_pagecache_size=32G \
        --env=NEO4J_dbms_memory_heap_initial__size=16G \
        --env=NEO4J_dbms_memory_heap_max__size=16G \
        --env=NEO4J_AUTH=neo4j/ahi2017 \
        -v ${performance_neo4j_data_path}:/data \
	-v ${performance_neo4j_import_path}:/var/lib/neo4j/import \
        ${performance_neo4j_docker_image}

    echo "[INFO] 启动 ${performance_neo4j_container_name} 成功 !"
}

# mongo3配置
mongo3_docker_image=nexus.ahi.internal:5000/mongo:3
mongo3_container_name=ahi_mongo_27017
mongo3_port_in_docker=27017
mongo3_port=27017
mongo3_conf_path=${cur_dir}/mongo3/conf
mongo3_data_path=${cur_dir}/mongo3/data

function deploy_mongo3() {

    if [ -d ${mongo3_data_path} ]; then
        echo "[INFO] mongo3 数据目录已存在 ${mongo3_data_path}"
    else
        echo "[INFO] mongo3 数据目录不存在, 新建数据目录 ${mongo3_data_path}"
        mkdir -p ${mongo3_data_path}
    fi

    echo "[INFO] 启动 ${mongo3_container_name} ..."


    docker run \
        -d \
        --name ${mongo3_container_name} \
        -m 4096M \
        --memory-swap=4096M \
        -p ${mongo3_port}:${mongo3_port_in_docker} \
        -v ${mongo3_data_path}:/data/db \
        ${mongo3_docker_image} \
        mongod --bind_ip 0.0.0.0

    echo "[INFO] 启动 ${mongo3_container_name} 成功 !"
}

# mongo3_auth配置
mongo3_auth_docker_image=nexus.ahi.internal:5000/mongo:3
mongo3_auth_container_name=ahi_mongo_27018
mongo3_auth_port_in_docker=27017
mongo3_auth_port=27018
mongo3_auth_conf_path=${cur_dir}/mongo3_auth/conf
mongo3_auth_data_path=${cur_dir}/mongo3_auth/data

function deploy_mongo3_auth() {

    if [ -d ${mongo3_auth_data_path} ]; then
        echo "[INFO] mongo3_auth 数据目录已存在 ${mongo3_auth_data_path}"
    else
        echo "[INFO] mongo3_auth 数据目录不存在, 新建数据目录 ${mongo3_auth_data_path}"
        mkdir -p ${mongo3_auth_data_path}
    fi

    echo "[INFO] 启动 ${mongo3_auth_container_name} ..."


    docker run \
        -d \
        --name ${mongo3_auth_container_name} \
        -m 4096M \
        --memory-swap=4096M \
        -p ${mongo3_auth_port}:${mongo3_auth_port_in_docker} \
        -v ${mongo3_auth_data_path}:/data/db \
        -e MONGO_INITDB_ROOT_USERNAME=root \
        -e MONGO_INITDB_ROOT_PASSWORD=ahi2017 \
        ${mongo3_auth_docker_image} \
        mongod --bind_ip 0.0.0.0 \
        --auth

    echo "[INFO] 启动 ${mongo3_auth_container_name} 成功 !"
}

# mongo4配置
mongo4_docker_image=mongo:4.0.22
mongo4_container_name=ahi_mongo4_27019
mongo4_port_in_docker=27017
mongo4_port=27019
mongo4_conf_path=${cur_dir}/mongo4/conf
mongo4_data_path=${cur_dir}/mongo4/data

function deploy_mongo4() {

    if [ -d ${mongo4_data_path} ]; then
        echo "[INFO] mongo4 数据目录已存在 ${mongo4_data_path}"
    else
        echo "[INFO] mongo4 数据目录不存在, 新建数据目录 ${mongo4_data_path}"
        mkdir -p ${mongo4_data_path}
    fi

    echo "[INFO] 启动 ${mongo4_container_name} ..."


    docker run \
        -d \
        --name ${mongo4_container_name} \
        -m 4096M \
        --memory-swap=4096M \
        -p ${mongo4_port}:${mongo4_port_in_docker} \
        -v ${mongo4_data_path}:/data/db \
        ${mongo4_docker_image} \
        mongod --bind_ip 0.0.0.0

    echo "[INFO] 启动 ${mongo4_container_name} 成功 !"
}

# mongo4_auth配置
mongo4_auth_docker_image=mongo:4.0.22
mongo4_auth_container_name=ahi_mongo4_27020
mongo4_auth_port_in_docker=27017
mongo4_auth_port=27020
mongo4_auth_conf_path=${cur_dir}/mongo4_auth/conf
mongo4_auth_data_path=${cur_dir}/mongo4_auth/data
mongo4_initdb_root_username=mongo_admin
mongo4_initdb_root_password=AHIbackend_2017

function deploy_mongo4_auth() {

    # docker rm -f ${mongo4_auth_container_name}

    if [ -d ${mongo4_auth_data_path} ]; then
        echo "[INFO] mongo4_auth 数据目录已存在 ${mongo4_auth_data_path}"
    else
        echo "[INFO] mongo4_auth 数据目录不存在, 新建数据目录 ${mongo4_auth_data_path}"
        mkdir -p ${mongo4_auth_data_path}
    fi

    echo "[INFO] 启动 ${mongo4_auth_container_name} ..."


    docker run \
        -d \
        --name ${mongo4_auth_container_name} \
        -m 4096M \
        --memory-swap=4096M \
        -p ${mongo4_auth_port}:${mongo4_auth_port_in_docker} \
        -v ${mongo4_auth_data_path}:/data/db \
        -e MONGO_INITDB_ROOT_USERNAME=${mongo4_initdb_root_username} \
        -e MONGO_INITDB_ROOT_PASSWORD=${mongo4_initdb_root_password} \
        ${mongo4_auth_docker_image} \
        mongod \
        --auth

    echo "[INFO] 启动 ${mongo4_auth_container_name} 成功 !"
}

# redis配置
redis_docker_image=redis
redis_container_name=ahi_redis_6379
redis_port_in_docker=6379
redis_port=6379
redis_conf_path=${cur_dir}/redis/conf
redis_data_path=${cur_dir}/redis/data
redis_auth=ahi2017

function deploy_redis() {

    if [ -d ${redis_data_path} ]; then
        echo "[INFO] redis 数据目录已存在 ${redis_data_path}"
    else
        echo "[INFO] redis 数据目录不存在, 新建数据目录 ${redis_data_path}"
        mkdir -p ${redis_data_path}
    fi

    echo "[INFO] 启动 ${redis_container_name} ..."
    docker run \
        -d \
        --name ${redis_container_name} \
        -p ${redis_port}:${redis_port_in_docker} \
        -v ${redis_data_path}:/data \
        ${redis_docker_image} \
        --requirepass ${redis_auth} \
        --appendonly yes

    echo "[INFO] 启动 ${redis_container_name} 成功 !"
}

# gbase8a配置
gbase8a_docker_image=shihd/gbase8a:1.0
gbase8a_container_name=ahi_gbase8a_5258
gbase8a_port_in_docker=5258
gbase8a_port=5258
#gbase8a_conf_path=${cur_dir}/gbase8a/conf
gbase8a_data_path=${cur_dir}/gbase8a
        #-v ${gbase_data_path}:/home/gbase/GBase/userdata/gbase8a/gbase/ \
#gbase8a_user=root
#gbase8a_password=root
#gbase8a_db=gbase8a

function deploy_gbase8a() {

    if [ -d ${gbase8a_data_path} ]; then
        echo "[INFO] gbase8a 数据目录已存在 ${gbase8a_data_path}"
    else
        echo "[INFO] gbase8a 数据目录不存在, 新建数据目录 ${gbase8a_data_path}"
        mkdir -p ${gbase8a_data_path}
    fi

    echo "[INFO] 启动 ${gbase8a_container_name} ..."
    docker run \
        --name ${gbase8a_container_name} \
        -d \
        -e GS_PASSWORD=${gbase8a_password} \
        -p ${gbase8a_port}:${gbase8a_port_in_docker} \
        ${gbase8a_docker_image}

    echo "[INFO] 启动 ${gbase8a_container_name} 成功 !"
}

# opengauss101配置
opengauss101_docker_image=enmotech/opengauss:latest
opengauss101_container_name=ahi_opengauss101_15432
opengauss101_port_in_docker=5432
opengauss101_port=15432
#opengauss101_conf_path=${cur_dir}/opengauss101/conf
opengauss101_data_path=${cur_dir}/opengauss101
opengauss_password=ahi2017@Gauss

function deploy_opengauss101() {

    if [ -d ${opengauss101_data_path} ]; then
        echo "[INFO] opengauss101 数据目录已存在 ${opengauss101_data_path}"
    else
        echo "[INFO] opengauss101 数据目录不存在, 新建数据目录 ${opengauss101_data_path}"
        mkdir -p ${opengauss101_data_path}
    fi

    echo "[INFO] 启动 ${opengauss101_container_name} ..."
    # docker run --name opengauss --privileged=true -d -e GS_PASSWORD=ahi2017@Gauss -v /data/AHI/AutoDeploy/database/opengauss101:/var/lib/opengauss -p 15432:5432 enmotech/opengauss:latest
    docker run \
        --name ${opengauss101_container_name} \
        --privileged=true \
        -d \
        -e GS_PASSWORD=${opengauss_password} \
        -v ${opengauss101_data_path}:/var/lib/opengauss \
        -p ${opengauss101_port}:${opengauss101_port_in_docker} \
        ${opengauss101_docker_image} 

    echo "[INFO] 启动 ${opengauss101_container_name} 成功 !"
}

#deploy_mysql5
#deploy_mysql57
#deploy_mysql8
#deploy_neo4j
#deploy_performance_neo4j
#deploy_mongo3
#deploy_mongo3_auth
#deploy_mongo4
#deploy_mongo4_auth
deploy_redis
#deploy_gbase8a
#deploy_opengauss101
#deploy_mongo4_auth

echo [INFO] 脚本执行完成
exit 0

