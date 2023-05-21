FROM container-registry.oracle.com/database/enterprise:21.3.0.0

CMD echo 'DISABLE_OOB=ON' >> /opt/oracle/oradata/dbconfig/ORCLCDB/sqlnet.ora

ENTRYPOINT /opt/oracle/runOracle.sh
