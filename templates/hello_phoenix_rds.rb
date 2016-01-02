require 'securerandom'
SparkleFormation.new(:hello_phoenix_rds) do
  description 'RDS Template'

  parameters.db_name do
    description 'DB Name'
    type        'String'
    default     'Postgres01'
  end

  parameters.db_engine do
    description 'DB Engine'
    type        'String'
    default     'PostgresSQL'
  end

  parameters.db_is_multi_az do
    description     'Specifies if MultiAZ DB. Default is false'
    type            'String'
    default         'false'
    allowed_values  %w{true false}
  end

  parameters.db_instance_class do
    description     'DB instance type. Default is db.m1.small.'
    type            'String'
    default         'db.m1.small'
  end

  parameters.db_user do
    description     'DB MasterUsername.'
    type            'String'
    default         'postgres'
  end

  parameters.db_password do
    description     'DB MasterUserPassword.'
    type            'String'
    default         SecureRandom.hex
    no_echo         'true'
  end

  parameters.db_storage do
    description     'DB AllocatedStorage.'
    type            'Number'
    default         5
  end

  resources.db_instance do
    type 'AWS::RDS::DBInstance'
    properties do
      db_name               ref!(:db_name)
      db_engine             ref!(:db_engine)
      multi_az              ref!(:db_is_multi_az)
      master_username       ref!(:db_user)
      master_user_password  ref!(:db_password)
      db_instance_class     ref!(:db_instance_class)
      allocated_storage     ref!(:db_storage)
    end
  end


end
