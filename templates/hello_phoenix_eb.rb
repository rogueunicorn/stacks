SparkleFormation.new(:hello_phoenix_eb) do
  description 'Elastic Beanstalk Template'

  policy = {
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

  parameters.source_bundle_bucket do
    description 'Source Bundle S3 Bucket'
    type        'String'
  end

  parameters.source_bundle_key do
    description 'Source Bundle S3 Key'
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

  # resources.eb_role do
  #   type 'Type": "AWS::IAM::Role'
  #   properties do
  #
  #   end
  # end

  # resources.eb_policy do
  #   type 'Type": "AWS::IAM::Policy'
  #   properties do
  #     PolicyName 'ElasticBeanstalkPolicy'
  #     PolicyDocument policy
  #     Roles ref!(:eb_role)
  #   end
  # end

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
          Value:        join!(ref!(:private_subnet_az_1), ref!(:private_subnet_az_2), ref!(:private_subnet_az_3), {options: {delimiter: ','} })
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
      Tags              []
    end
  end

  resources.eb_application_version do
    type 'AWS::ElasticBeanstalk::ApplicationVersion'
    depends_on 'EbEnvironment'
    properties do
      ApplicationName ref!(:application_name)
      SourceBundle do
        S3Bucket  ref!(:source_bundle_bucket)
        S3Key     ref!(:source_bundle_bucket)
      end
    end
  end

  outputs do

  end


end
