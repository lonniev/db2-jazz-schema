# db2-jazz-schema Cookbook

Drops known, existing Jazz DB2 databases on the specified DB2 server and then creates new DB2
databases in the indicated DB2 instance on the specified DB2 server. It then configures those
databases according to IBM's recommendations.

The resulting DB2 Jazz Schema is ready for administration by the chosen Unix user to create the
suitable tables within each Jazz DB2 database.

## Requirements

### Platforms

- Ubuntu Linux 64-bit

### Chef

- Chef 12.0 or later

### Cookbooks

- `db2-express-community` - db2-express-community isn't a dependency but can be used
to assure that a proper DB2 installation is available.

## Attributes

### db2-jazz-schema::default

```json
{
  'db2inst1UserName' => 'db2inst1',
  'vagrantAdmin' => 'vagrant',
  'db2AdminGroup' => 'db2admin'
}
```

## Usage

### db2-jazz-schema::default

Just include `db2-jazz-schema` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[db2-jazz-schema]"
  ]
}
```

## License and Authors

Authors: Lonnie VanZandt
