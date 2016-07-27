#!/bin/bash -ex

KEYSTONE_ADDRESS=${1}
KEYSTONE_ADMIN_PORT=${2}

export OS_USERNAME=${3}
export OS_PASSWORD=${4}
export OS_PROJECT_NAME=${5}
export OS_DOMAIN_NAME=${6}

HEAT_USER=${7}
HEAT_PASSWORD=${8}
HEAT_API_PORT=${9}

export OS_AUTH_URL=http://${KEYSTONE_ADDRESS}:${KEYSTONE_ADMIN_PORT}/v3
export OS_IDENTITY_API_VERSION=3

openstack user create --domain default --password ${HEAT_PASSWORD} ${HEAT_USER}
openstack role add --project ${OS_PROJECT_NAME} --user ${HEAT_USER} admin
openstack service create --name heat --description "OpenStack orchestration service" orchestration
openstack endpoint create --region RegionOne orchestration public http://heat-api:${HEAT_API_PORT}/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration internal http://heat-api:${HEAT_API_PORT}/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration admin http://heat-api:${HEAT_API_PORT}/v1/%\(tenant_id\)s
