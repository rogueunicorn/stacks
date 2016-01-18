# https://s3-us-west-2.amazonaws.com/elasticbeanstalk-us-west-2-hello-phoenix/docker-singlecontainer-v1.zip
SparkleFormation.new(:hello_phoenix_eb) do
  description 'Elastic Beanstalk Template'

  multi_container_policy = {
    Version: '2012-10-17',
    Statement: [
      {
        Effect: 'Allow',
        Action: [
          'ecs:StartTask',
          'ecs:StopTask',
          'ecs:RegisterContainerInstance',
          'ecs:DeregisterContainerInstance',
          'ecs:DescribeContainerInstances',
          'ecs:DiscoverPollEndpoint',
          'ecs:Submit*',
          'ecs:Poll'
          ],
        Resource: '[\'*\']'
      },
      {
        Effect: 'Allow',
        Action: 's3:PutObject',
        Resource: 'arn:aws:s3:::elasticbeanstalk-*/resources/environments/logs/*'
      }
    ]
  }

  policy = {
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: "s3:GetObject",
        Resource: ref!(:s3_bucket_arn)
      }
    ]
  }

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

  parameters.s3_bucket_arn do
    description 'Environment Name'
    type        'String'
  end

  parameters.instance_type do
    description 'InstanceType'
    type        'String'
    default     't2.nano'
  end

  resources.eb_policy do
    type 'AWS::IAM::ManagedPolicy'
    properties do
      Description     'ElasticBeanstalk S3 Policy'
      Path            '/'
      PolicyDocument  policy
      Roles           ['aws-elasticbeanstalk-ec2-role', 'aws-elasticbeanstalk-service-role']
    end
  end

  resources.eb_application do
    type 'AWS::ElasticBeanstalk::Application'
    properties do
      ApplicationName ref!(:application_name)
    end
  end

  resources.eb_environment do
    type 'AWS::ElasticBeanstalk::Environment'
    depends_on ['EbApplication','EbConfigTemplate']
    properties do
      ApplicationName   ref!(:application_name)
      CNAMEPrefix       ref!(:cname_prefix)
      EnvironmentName   ref!(:environment_name)
      TemplateName      ref!(:eb_config_template)
      # Tags            [{ Key: 'Name', Value: 'DBSubnetGroup' }]
    end
  end

  resources.eb_config_template do
    type 'AWS::ElasticBeanstalk::ConfigurationTemplate'
    depends_on 'EbApplication'
    properties do
      ApplicationName   ref!(:application_name)
      SolutionStackName ref!(:solution_stack_name)
      OptionSettings    [
        {
          Namespace:  'aws:autoscaling:launchconfiguration',
          OptionName: 'InstanceType',
          Value:      ref!(:instance_type)
        },
        {
          Namespace:  'aws:autoscaling:launchconfiguration',
          OptionName: 'IamInstanceProfile',
          Value:      'aws-elasticbeanstalk-ec2-role'
        },
        {
          Namespace:  'aws:autoscaling:asg',
          OptionName: 'MinSize',
          Value:      2
        },
        {
          Namespace:  'aws:autoscaling:asg',
          OptionName: 'MaxSize',
          Value:      4
        },
        {
          Namespace:    'aws:ec2:vpc',
          OptionName:  'VPCId',
          Value:        ref!(:vpc_id)
        },
        {
          Namespace:   'aws:ec2:vpc',
          OptionName:  'Subnets',
          Value:        join!(ref!(:public_subnet_az_1), ref!(:public_subnet_az_2), ref!(:public_subnet_az_3), {options: {delimiter: ','}})
        },
        {
          Namespace:   'aws:ec2:vpc',
          OptionName:  'ELBSubnets',
          Value:        join!(ref!(:public_subnet_az_1), ref!(:public_subnet_az_2), ref!(:public_subnet_az_3), {options: {delimiter: ','}})
        },
        {
          Namespace:   'aws:ec2:vpc',
          OptionName:  'AssociatePublicIpAddress',
          Value:       'true'
        }
      ]
    end
  end

  outputs do

  end


end
