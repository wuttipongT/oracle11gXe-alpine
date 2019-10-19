FROM cosmomill/alpine-glibc as install

# add bash to make sure our scripts will run smoothly
RUN apk --update add --no-cache bash

# install bsdtar
RUN apk --update add --no-cache libarchive-tools

ENV ORACLE_BASE /u01/app/oracle
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID XE
ENV PATH $PATH:$ORACLE_HOME/bin

ONBUILD ARG ORACLE_RPM

# install Oracle XE prerequisites
RUN apk --update add --no-cache libaio bc net-tools

ONBUILD ADD $ORACLE_RPM /tmp/
ONBUILD RUN bsdtar -C /tmp -xf /tmp/*.zip && bsdtar -C / -xf /tmp/Disk1/*.rpm \
	&& cp /tmp/Disk1/response/xe.rsp /tmp/ \
	&& rm -rf /tmp/Disk1 \
	&& rm -f /tmp/*.zip

# add Oracle user and group
ONBUILD RUN addgroup dba && adduser -D -G dba -h /u01/app/oracle -s /bin/false oracle

# fix postScripts.sql
ONBUILD RUN sed -i "s|%ORACLE_HOME%|/u01/app/oracle/product/11.2.0/xe|" $ORACLE_HOME/config/scripts/postScripts.sql \
	\
# fix permissions
	    && chown -R oracle:dba /u01 \
	    && chmod 755 /etc/init.d/oracle-xe \
	    && find $ORACLE_HOME/config/scripts -type f -exec chmod 644 {} \; \
 	    && find $ORACLE_HOME/config/scripts -name *.sh -type f -exec chmod 755 {} \; \
	    && find $ORACLE_HOME/bin -type f -exec chmod 755 {} \; \
	\
# set sticky bit to oracle executable
	    && chmod 6751 $ORACLE_HOME/bin/oracle \
	\
# create missing log directory
	    && install -d -o oracle -g dba $ORACLE_HOME/config/log \
	\
# create sysconfig directory
	    && install -d /etc/sysconfig \
	\
# fix paths in init script
	    && sed -i "s|/bin/awk|/usr/bin/awk|" /etc/init.d/oracle-xe \
	    && sed -i "s|/var/lock/subsys|/var/run|" /etc/init.d/oracle-xe \
	\
# add oracle environment variables
 	    && ln -s $ORACLE_HOME/bin/oracle_env.sh /etc/profile.d/oracle_env.sh


FROM install

MAINTAINER Wuttipong Thongmon <bed.wuttipong@gmail.com>

ENV PROCESSES 500
ENV SESSIONS 555
ENV TRANSACTIONS 610

COPY entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
WORKDIR ${ORACLE_HOME}
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 1521 8080
