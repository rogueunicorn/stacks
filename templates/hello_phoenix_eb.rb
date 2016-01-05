SparkleFormation.new(:hello_phoenix_eb) do
  description 'Elastic Beanstalk Template'

  resources.eb_application do
    type 'AWS::ElasticBeanstalk::Application'
    properties do
      ApplicationName ref!(:application_name)
    end
  end

  # resources.eb_environment do
  #   type 'AWS::ElasticBeanstalk::Environment'
  #   properties do
  #     ApplicationName   ref!(:application_name)
  #     CNAMEPrefix       ref!(:cname_prefix)
  #     EnvironmentName   ref!(:environment_name)
  #     SolutionStackName ref!(:solution_stack_name)
  #     VersionLabel      '0.0.0'
  #     Tags              []
  #   end
  # end

  outputs do

  end

  parameters.vpc_id do
    description 'VPC ID'
    type        'AWS::EC2::VPC::Id'
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

end
