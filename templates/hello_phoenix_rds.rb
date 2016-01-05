SparkleFormation.new(:hello_phoenix_rds) do
  description 'RDS Template'

  PORT_3306 = {
    IpProtocol: 'tcp',
    FromPort:   '3306',
    ToPort:     '3306',
    SourceSecurityGroupId: ref!(:app_server_security_group)
  }

  PORT_5432 = {
    IpProtocol: 'tcp',
    FromPort:   '5432',
    ToPort:     '5432',
    SourceSecurityGroupId: ref!(:app_server_security_group)
  }

  resources.db_instance do
    type 'AWS::RDS::DBInstance'
    properties do
      DB_name             ref!(:db_name)
      DBInstanceClass     ref!(:db_instance_class)
      Engine              ref!(:db_engine)
      MultiAZ             ref!(:db_is_multi_az)
      MasterUsername      ref!(:db_user)
      MasterUserPassword  ref!(:db_password)
      AllocatedStorage    ref!(:db_storage)
      VPCSecurityGroups   [ref!(:db_security_group)]
      DBSubnetGroupName   ref!(:db_subnet_group)
      # Tags                [{ Key: 'Name', Value: 'PublicRouteTable' }]
    end
  end

  resources.db_subnet_group do
    type 'AWS::RDS::DBSubnetGroup'
    properties do
      DBSubnetGroupDescription  'MultiAZ DB Subnet Group'
      SubnetIds                 [ref!(:private_subnet_az_1), ref!(:private_subnet_az_2), ref!(:private_subnet_az_3)]
      Tags                      [{ Key: 'Name', Value: 'DBSubnetGroup' }]
    end
  end

  resources.db_security_group do
    type 'AWS::EC2::SecurityGroup'
    properties do
      VpcId                   ref!(:vpc_id)
      Tags                    [{ Key: 'Name', Value: 'DBSecurityGroup' }]
      GroupDescription      'Security Group for RDS DB Instances'
      # SecurityGroupIngress    [PORT_3306, PORT_5432]
    end
  end

  outputs do
    db_security_group do
      description 'DB Security Group'
      value ref!(:db_security_group)
    end
    db_subnet_group do
      description 'DB Subnet Group'
      value ref!(:db_subnet_group)
    end
  end

  parameters.vpc_id do
    description 'VPC ID'
    type        'AWS::EC2::VPC::Id'
  end

  parameters.private_subnet_az_1 do
    description 'Private Subnet AZ 1'
    type 'String'
  end

  parameters.private_subnet_az_2 do
    description 'Private Subnet AZ 2'
    type 'String'
  end

  parameters.private_subnet_az_3 do
    description 'Private Subnet AZ 3'
    type 'String'
  end

  parameters.app_server_security_group do
    description 'App Server SecurityGroup'
    type 'String'
  end

  parameters.db_name do
    description     'DB Name'
    type            'String'
    default         'Postgres01'
    min_length      '1'
    max_length      '64'
    allowed_pattern '[a-zA-Z][a-zA-Z0-9]*'
  end

  parameters.db_engine do
    description 'DB Engine'
    type        'String'
    default     'postgres'
  end

  parameters.db_is_multi_az do
    description     'Specifies if MultiAZ DB. Default is false'
    type            'String'
    default         'false'
    allowed_values  %w{true false}
  end

  parameters.db_instance_class do
    description     'DB instance type, default is db.m1.micro'
    type            'String'
    default         'db.t1.micro' # db.t1.micro | db.m1.small | db.m1.medium | db.m1.large | db.m1.xlarge | db.m2.xlarge |db.m2.2xlarge | db.m2.4xlarge | db.m3.medium | db.m3.large | db.m3.xlarge | db.m3.2xlarge | db.m4.large | db.m4.xlarge | db.m4.2xlarge | db.m4.4xlarge | db.m4.10xlarge | db.r3.large | db.r3.xlarge | db.r3.2xlarge | db.r3.4xlarge | db.r3.8xlarge | db.t2.micro | db.t2.small | db.t2.medium | db.t2.large
  end

  parameters.db_user do
    description     'DB MasterUsername'
    type            'String'
    default         'postgres'
  end

  parameters.db_password do
    description     'DB MasterUserPassword'
    type            'String'
    no_echo         'true'
  end

  parameters.db_storage do
    description     'DB AllocatedStorage'
    type            'Number'
    default         5
  end

end
