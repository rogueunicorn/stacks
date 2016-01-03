SparkleFormation.new(:hello_phoenix_vpc) do
  description 'VPC Template'

  resources.vpc do
    type 'AWS::EC2::VPC'
    properties do
      cidr_block ref!(:vpc_cidr)
    end
  end

  resources.internet_gateway do
    type 'AWS::EC2::InternetGateway'
    properties do
    end
  end

  resources.internet_gateway_attachment do
    type 'AWS::EC2::VPCGatewayAttachment'
    properties do
      vpc_id              ref!(:vpc)
      internet_gateway_id ref!(:internet_gateway)
    end
  end

  resources.public_subnet_az_1 do
    type 'AWS::EC2::Subnet'
    properties do
      vpc_id            ref!(:vpc)
      cidr_block        ref!(:az_1_public_cidr)
      availability_zone ref!(:vpc_az_1)
      tags _array(
        { Key: 'Name', Value: 'PublicSubnet' },
        { Key: 'network', Value: 'public' }
      )
    end
  end

  resources.public_subnet_az_2 do
    type 'AWS::EC2::Subnet'
    properties do
      vpc_id            ref!(:vpc)
      cidr_block        ref!(:az_2_public_cidr)
      availability_zone ref!(:vpc_az_2)
      tags _array(
        { Key: 'Name', Value: 'PublicSubnet' },
        { Key: 'network', Value: 'public' }
      )
    end
  end

  resources.public_subnet_az_3 do
    type 'AWS::EC2::Subnet'
    properties do
      vpc_id            ref!(:vpc)
      cidr_block        ref!(:az3_public_cidr)
_      availability_zone ref!(:vpc_az_3)
      tags _array(
        { Key: 'Name', Value: 'PublicSubnet' },
        { Key: 'network', Value: 'public' }
      )
    end
  end

  # resources.private_subnet_az_1 do
  #   type 'AWS::EC2::Subnet'
  #   properties do
  #     vpc_id            ref!(:vpc)
  #     cidr_block        ref!(:az1_private_cidr)
  #     availability_zone ref!(:vpc_az_1)
  #     tags _array(
  #       { Key: 'Name', Value: 'PrivateSubnet' },
  #       { Key: 'network', Value: 'private' }
  #     )
  #   end
  # end

# {
#    "Type" : "AWS::EC2::RouteTable",
#    "Properties" : {
#       "VpcId" : String,
#       "Tags" : [ Resource Tag, ... ]
#    }
# }

  outputs do
    vpc_id do
      description 'VPC ID'
      value ref!(:vpc)
    end
    public_subnet_az_1 do
      description 'Public Subnet AZ 1'
      value ref!(:public_subnet_az_1)
    end
    public_subnet_az_2 do
      description 'Public Subnet AZ 2'
      value ref!(:public_subnet_az_2)
    end
    public_subnet_az_3 do
      description 'Public Subnet AZ 3'
      value ref!(:public_subnet_az_3)
    end
    # private_subnet_az_1 do
    #   description 'Private Subnet'
    #   value ref!(:private_subnet_az_1)
    # end
    internet_gateway do
      description 'Internet Gateway'
      value ref!(:internet_gateway)
    end
  end

  parameters.vpc_az_1 do
    type 'AWS::EC2::AvailabilityZone::Name'
    description 'VPC AZ 1'
  end

  parameters.vpc_az_2 do
    type 'AWS::EC2::AvailabilityZone::Name'
    description 'VPC AZ 2'
  end

  parameters.vpc_az_3 do
    type 'AWS::EC2::AvailabilityZone::Name'
    description 'VPC AZ 3'
  end

  parameters.vpc_cidr do
    type 'String'
    default '10.0.0.0/16'
    description 'VPC CIDR Block, default is 10.0.0.0/16'
  end

  # 10.0.0.0/18 — AZ A
  #   10.0.0.0/19 — Private
  #   10.0.32.0/19 - Public
  # 10.0.64.0/18 — AZ B
  # 10.0.128.0/18 — AZ C
  # 10.0.192.0/18 — Spare

  parameters.az_1_public_cidr do
    type 'String'
    default '10.0.1.0/24'
    description 'VPC Public CIDR Block, default is 10.0.1.0/24'
  end

  parameters.az_2_public_cidr do
    type 'String'
    default '10.0.2.0/24'
    description 'VPC Public CIDR Block, default is 10.0.2.0/24'
  end

  parameters.az_3_public_cidr do
    type 'String'
    default '10.0.3.0/24'
    description 'VPC Public CIDR Block, default is 10.0.3.0/24'
  end

  parameters.az1_private_cidr do
    type 'String'
    default '10.0.32.0/19'
    description 'VPC Private CIDR Block, default is 10.0.32.0/19'
  end

  parameters.az2_private_cidr do
    type 'String'
    default '10.0.96.0/19'
    description 'VPC Private CIDR Block, default is 10.0.96.0/19'
  end

  parameters.az3_private_cidr do
    type 'String'
    default '10.0.160.0/19'
    description 'VPC Private CIDR Block, default is 10.0.160.0/19'
  end

end
