SparkleFormation.new(:hello_phoenix_eb) do
  description 'Elastic Beanstalk Template'

  parameters.vpc_id do
    description 'VPC ID'
    type        'AWS::EC2::VPC::Id'
  end

  parameters.public_subnet_az_1 do
    description 'Public Subnet AZ 1'
    type 'String'
  end

  parameters.public_subnet_az_2 do
    description 'Public Subnet AZ 2'
    type 'String'
  end

  parameters.public_subnet_az_3 do
    description 'Public Subnet AZ 3'
    type 'String'
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

  parameters.application_name do
    description 'Application Name'
    type        'String'
  end

  parameters.cname_prefix do
    description 'CName Prefix'
    type        'String'
  end

  parameters.solution_stack_name do
    description 'Solution Stack Name'
    type        'String'
  end

  parameters.environment_name do
    description 'Environment Name'
    type        'String'
  end


  resources.eb_application do
    type 'AWS::ElasticBeanstalk::Application'
    properties do
      ApplicationName ref!(:application_name)
    end
  end

  resources.eb_environment do
    type 'AWS::ElasticBeanstalk::Environment'
    depends_on 'EbApplication'
    properties do
      ApplicationName   ref!(:application_name)
      CNAMEPrefix       ref!(:cname_prefix)
      EnvironmentName   ref!(:environment_name)
      SolutionStackName ref!(:solution_stack_name)
      OptionSettings    [
        {
          Namespace:    'aws:ec2:vpc',
          OptionName:  'VPCId',
          Value:        ref!(:vpc_id)
        },
        {
          Namespace:   'aws:ec2:vpc',
          OptionName:  'Subnets',
          Value:        join!(ref!(:public_subnet_az_1), ref!(:public_subnet_az_1), ref!(:public_subnet_az_1), {options: {delimiter: ','} })
        },
        {
          Namespace:   'aws:ec2:vpc',
          OptionName:  'ELBSubnets',
          Value:        join!(ref!(:public_subnet_az_1), ref!(:public_subnet_az_2), ref!(:public_subnet_az_3), {options: {delimiter: ','}})
        },
      ]
      Tags              []
    end
  end

  outputs do

  end


end
