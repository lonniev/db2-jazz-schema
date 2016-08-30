#
# Cookbook Name:: db2-jazz-schema
# Recipe:: default
#
# "Creative Commons BY" Predictable Response Consulting
# "Creative Commons BY" Sodius

db2inst1UserName = node['db2-jazz-schema']['db2inst1UserName']
vagrantAdmin = node['db2-jazz-schema']['vagrantAdmin']

databases = [
  { :db => 'JTS', :size => '16384' },
  { :db => 'CCM', :size => '16384' },
  { :db => 'QM', :size => '16384' },
  { :db => 'RM', :size => '16384' },
  { :db => 'LQE', :size => '32768' },
  { :db => 'LDX', :size => '32768' },
  { :db => 'DCC', :size => '16384' },
  { :db => 'GC', :size => '16384' },
  { :db => 'RELM', :size => '16384' },
  { :db => 'DM', :size => '16384' },
  { :db => 'DW', :size => '16384' }
]

databases.each { |spec|

  db = spec[:db]
  size = spec[:size]
  
  bash "create Jazz DB2 Schema for #{db}" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 create database #{db} using codeset UTF-8 territory en PAGESIZE #{size}

        db2 connect to #{db}
        db2 grant dbadm on database to user #{vagrantAdmin}
        db2 disconnect #{db}
SCRIPT
EOH
  end
}

bash "Update DB2 CFG for #{databases.size} Databases" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

    db2 update dbm cfg using numdb 11

    db2stop
    db2start

SCRIPT
EOH

end
