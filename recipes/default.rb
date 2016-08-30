#
# Cookbook Name:: db2-jazz-schema
# Recipe:: default
#
# "Creative Commons BY" Predictable Response Consulting
# "Creative Commons BY" Sodius

db2inst1UserName = node['db2-jazz-schema']['db2inst1UserName']
vagrantAdmin = node['db2-jazz-schema']['vagrantAdmin']

bash "create Jazz DB2 Schema" do

  only_if 'service db2fmcd status'

  code <<-EOH

    su - #{db2inst1UserName} <<-SCRIPT

      . sqllib/db2profile

      db2 create database JTS using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database CCM using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database QM using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database RM using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database LQE using codeset UTF-8 territory en PAGESIZE 32768
      db2 create database LDX using codeset UTF-8 territory en PAGESIZE 32768
      db2 create database DCC using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database GC using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database RELM using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database DM using codeset UTF-8 territory en PAGESIZE 16384
      db2 create database DW using codeset UTF-8 territory en PAGESIZE 16384

      db2 connect to JTS
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect JTS

      db2 connect to CCM
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect CCM

      db2 connect to QM
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect QM

      db2 connect to RM
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect RM

      db2 connect to LQE
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect LQE

      db2 connect to LDX
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect LDX

      db2 connect to DCC
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect DCC

      db2 connect to GC
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect GC

      db2 connect to RELM
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect RELM

      db2 connect to DM
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect DM

      db2 connect to DW
      db2 grant dbadm on database to user #{vagrantAdmin}
      db2 disconnect DW

      db2 update dbm cfg using numdb 11

      db2stop

      db2start
SCRIPT
EOH

end
