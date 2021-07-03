FROM centos:8 AS bse_build_image

RUN dnf update -y && \
    dnf clean all && \
    rm -rf /var/cache/yum

FROM jboss/keycloak:10.0.2
