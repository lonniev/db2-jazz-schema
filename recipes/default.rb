#
# Cookbook Name:: db2-jazz-schema
# Recipe:: default
#
# "Creative Commons BY" Predictable Response Consulting
# "Creative Commons BY" Sodius

db2inst1UserName = node['db2-jazz-schema']['db2inst1UserName']
vagrantAdmin = node['db2-jazz-schema']['vagrantAdmin']
db2AdminGroup = node['db2-jazz-schema']['db2AdminGroup']

bash "DB2 update SYSADM_GROUP #{db2AdminGroup}" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 update dbm cfg using SYSADM_GROUP #{db2AdminGroup}

SCRIPT
EOH

end

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

numDatabases = databases.size

# first try to erase each
databases.each { |spec|

  db = spec[:db]

  bash "Drop DB2 Database #{db} - if it exists" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 connect to #{db}

        db2 quiesce database immediate force connections

        db2 unquiesce database

        db2 force application all

        db2stop force
        db2start

        db2 drop database #{db}

        true
SCRIPT
EOH
  end
}

databases.each { |spec|

  db = spec[:db]
  size = spec[:size]

  bash "Create DB2 Database for #{db}" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 create database #{db} using codeset UTF-8 territory en PAGESIZE #{size}

        db2 connect to #{db}
        db2 grant dbadm on database to user #{vagrantAdmin}
        db2 grant dbadm on database to user #{db2inst1UserName}
        db2 disconnect #{db}
SCRIPT
EOH
  end
}

bash "Update DB2 CFG for #{numDatabases} Databases" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 update dbm cfg using numdb #{numDatabases}

        db2stop
        db2start

SCRIPT
EOH

end

# some tuning just for DW
# See http://www.ibm.com/support/knowledgecenter/SSYMRC_6.0.2/com.ibm.jazz.install.doc/topics/roadmap_form.html
bash "Update DB2 CFG for the DW Database" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 update db cfg for DW using maxappls 300

        db2 update db cfg for DW using locklist 20000

        db2 update db cfg for DW using logfilsiz 20000

        db2 update db cfg for DW using logprimary 50

        db2 update db cfg for DW using logsecond 200
SCRIPT
EOH

end

databases.each { |spec|

  db = spec[:db]
  size = spec[:size]

  bash "db2 activate #{db}" do

    only_if 'service db2fmcd status'

    code <<-EOH

      su - #{db2inst1UserName} <<-SCRIPT

        . sqllib/db2profile

        db2 activate database #{db}
SCRIPT
EOH
  end
}
