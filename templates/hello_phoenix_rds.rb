SparkleFormation.new(:hello_phoenix_rds) do
  description 'RDS Template'

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
      # VPCSecurityGroups   ref!(:db_security_group)
    end
  end

  parameters.db_name do
    description 'DB Name'
    type        'String'
    default     'Postgres01'
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
