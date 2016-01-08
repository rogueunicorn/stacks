SparkleFormation.new(:hello_phoenix_vpc) do
  description 'VPC Template'

  PORT_80 = {
    IpProtocol: 'tcp',
    FromPort:   '80',
    ToPort:     '80',
    CidrIp:     '0.0.0.0/0'
  }

  PORT_443 = {
    IpProtocol: 'tcp',
    FromPort:   '443',
    ToPort:     '443',
    CidrIp:     '0.0.0.0/0'
  }

  resources.vpc do
    type 'AWS::EC2::VPC'
    properties do
      CidrBlock ref!(:vpc_cidr)
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
      VpcId              ref!(:vpc)
      internet_gateway_id ref!(:internet_gateway)
    end
  end

  resources.public_route_table do
    type 'AWS::EC2::RouteTable'
    properties do
      VpcId   ref!(:vpc)
      Tags    [{ Key: 'Name', Value: 'PublicRouteTable' }]
    end
  end

  resources.public_route do
    type 'AWS::EC2::Route'
    depends_on 'InternetGateway'
    properties do
      RouteTableId          ref!(:public_route_table)
      GatewayId             ref!(:internet_gateway)
      DestinationCidrBlock  "0.0.0.0/0"
    end
  end

  resources.public_route_table do
    type 'AWS::EC2::RouteTable'
    properties do
      VpcId   ref!(:vpc)
      Tags    [{ Key: 'Name', Value: 'PublicRouteTable' }]
    end
  end

  resources.subnet_route_table_association_1 do
    type 'AWS::EC2::SubnetRouteTableAssociation'
    properties do
      RouteTableId ref!(:public_route_table)
      SubnetId ref!(:public_subnet_az_1)
    end
  end

  resources.subnet_route_table_association_2 do
    type 'AWS::EC2::SubnetRouteTableAssociation'
    properties do
      RouteTableId ref!(:public_route_table)
      SubnetId ref!(:public_subnet_az_2)
    end
  end

  resources.subnet_route_table_association_3 do
    type 'AWS::EC2::SubnetRouteTableAssociation'
    properties do
      RouteTableId ref!(:public_route_table)
      SubnetId ref!(:public_subnet_az_3)
    end
  end

  resources.public_subnet_az_1 do
    type 'AWS::EC2::Subnet'
    properties do
      VpcId            ref!(:vpc)
      CidrBlock        ref!(:az_1_public_cidr)
      AvailabilityZone ref!(:vpc_az_1)
      Tags _array(
        { Key: 'Name', Value: 'Public Subnet AZ 1' },
        { Key: 'Network', Value: 'public' }
      )
    end
  end

  resources.public_subnet_az_2 do
    type 'AWS::EC2::Subnet'
    properties do
      VpcId            ref!(:vpc)
      CidrBlock        ref!(:az_2_public_cidr)
      AvailabilityZone ref!(:vpc_az_2)
      Tags _array(
        { Key: 'Name', Value: 'Public Subnet AZ 2' },
        { Key: 'Network', Value: 'public' }
      )
    end
  end

  resources.public_subnet_az_3 do
    type 'AWS::EC2::Subnet'
    properties do
      VpcId            ref!(:vpc)
      CidrBlock        ref!(:az3_public_cidr)
      AvailabilityZone ref!(:vpc_az_3)
      Tags [
        { Key: 'Name', Value: 'Public Subnet AZ 3' },
        { Key: 'Network', Value: 'Public' }
      ]
    end
  end

  resources.private_subnet_az_1 do
    type 'AWS::EC2::Subnet'
    properties do
      VpcId            ref!(:vpc)
      CidrBlock        ref!(:az_1_private_cidr)
      AvailabilityZone ref!(:vpc_az_1)
      Tags _array(
        { Key: 'Name', Value: 'Private Subnet AZ 1' },
        { Key: 'Network', Value: 'private' }
      )
    end
  end

  resources.private_subnet_az_2 do
    type 'AWS::EC2::Subnet'
    properties do
      VpcId            ref!(:vpc)
      CidrBlock        ref!(:az_2_private_cidr)
      AvailabilityZone ref!(:vpc_az_2)
      Tags _array(
        { Key: 'Name', Value: 'Private Subnet AZ 2' },
        { Key: 'Network', Value: 'private' }
      )
    end
  end

  resources.private_subnet_az_3 do
    type 'AWS::EC2::Subnet'
    properties do
      VpcId            ref!(:vpc)
      CidrBlock        ref!(:az_3_private_cidr)
      AvailabilityZone ref!(:vpc_az_3)
      Tags _array(
        { Key: 'Name', Value: 'Private Subnet AZ 3' },
        { Key: 'Network', Value: 'private' }
      )
    end
  end

  resources.app_server_security_group do
    type 'AWS::EC2::SecurityGroup'
    properties do
      VpcId                 ref!(:vpc)
      GroupDescription      'Allow http/s to client host'
      SecurityGroupIngress  [PORT_80, PORT_443]
      Tags                  [{ Key: 'Name', Value: 'AppServerSecurityGroup' }]
    end
  end

  outputs do
    VpcId do
      description 'VPC ID'
      value ref!(:vpc)
    end
    public_route_table do
      description 'Public RouteTable'
      value ref!(:public_route_table)
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
    private_subnet_az_1 do
      description 'Private Subnet AZ 1'
      value ref!(:private_subnet_az_1)
    end
    private_subnet_az_2 do
      description 'Private Subnet AZ 2'
      value ref!(:private_subnet_az_2)
    end
    private_subnet_az_3 do
      description 'Private Subnet AZ 3'
      value ref!(:private_subnet_az_3)
    end
    internet_gateway do
      description 'Internet Gateway'
      value ref!(:internet_gateway)
    end
    public_route_table do
      description 'Public Route Table'
      value ref!(:public_route_table)
    end
    app_server_security_group do
      description 'App Server SecurityGroup'
      value ref!(:app_server_security_group)
    end
  end

# private_subnet_az_1 do
#   description 'Private Subnet'
#   value ref!(:private_subnet_az_1)
# end

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

  # 10.0.0.0/16:
  #     10.0.0.0/18 - AZ A
  #         10.0.0.0/19 - Public
  #         10.0.32.0/19 - Private
  #     10.0.64.0/18 - AZ B
  #         10.0.64.0/19 - Public
  #         10.0.96.0/19 - Private
  #     10.0.128.0/18 - AZ C
  #         10.0.128.0/19 - Public
  #         10.0.160.0/19 - Private
  #     10.0.192.0/18 - Spare

  parameters.az_1_public_cidr do
    type 'String'
    default '10.0.0.0/19'
    description 'VPC Public CIDR Block, default is 10.0.0.0/19'
  end

  parameters.az1_private_cidr do
    type 'String'
    default '10.0.32.0/19'
    description 'VPC Private CIDR Block, default is 10.0.32.0/19'
  end

  parameters.az_2_public_cidr do
    type 'String'
    default '10.0.64.0/19'
    description 'VPC Public CIDR Block, default is 10.0.64.0/19'
  end

  parameters.az_2_private_cidr do
    type 'String'
    default '10.0.96.0/19'
    description 'VPC Public CIDR Block, default is 10.0.96.0/19'
  end

  parameters.az_3_public_cidr do
    type 'String'
    default '10.0.128.0/19'
    description 'VPC Public CIDR Block, default is 10.0.128.0/19'
  end

  parameters.az_3_private_cidr do
    type 'String'
    default '10.0.160.0/19'
    description 'VPC Public CIDR Block, default is 10.0.160.0/19'
  end

end
