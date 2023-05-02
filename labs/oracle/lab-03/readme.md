#  Terraform: Create a Compute Instance

## Prepare

* Create SSH Encryption Keys
    - Create ssh encryption keys to connect to your compute instance.

        - Open a terminal window:
        
            - MacOS or Linux: Open a terminal window in the directory where you want to store your keys.

            - Windows: Right-click on the directory where you want to store your keys and select Git Bash Here.

        - Issue the following OpenSSH command:
            ```
            ssh-keygen -t rsa -N "" -b 2048 -C <your-ssh-key-name> -f <your-ssh-key-name>
            ```
        
            - The command generates some random text art used to generate the keys. When complete, you have two files:

                - The private key file: <your-ssh-key-name>

                - The public key file: <your-ssh-key-name>.pub

            - You use these files to connect to your compute instance.

        - You have generated the required encryption keys.

    - Create a Virtual Cloud Network (VCN)

        - Set up a VCN to connect your Linux instance to the internet. You configure all the components needed to create your virtual network.

            - Click the Oracle Cloud icon to go to the main landing page.

                - Scroll down to Launch Resources.

                - Select Set up a network with a wizard.

            - In the Start VCN Wizard workflow, select VCN with Internet Connectivity and then click Start VCN Wizard .

            - Fill in basic information:

                - VCN Name: <your-vcn-name>

                - Compartment: <your-compartment-name>

            - In the Configure VCN and Subnets section, keep the default values for the CIDR blocks:

                - VCN CIDR BLOCK: 10.0.0.0/16

                - PUBLIC SUBNET CIDR BLOCK: 10.0.0.0/24

                - PRIVATE SUBNET CIDR BLOCK: 10.0.1.0/24

                - Note
                    - Notice the public and private subnets have different network addresses.

            - For DNS Resolution, uncheck Use DNS hostnames in this VCN.

            - Click Next.

                - The Create a VCN with Internet Connectivity configuration dialog is displayed (not shown here) confirming all the values you just entered.

            - Click Create to create your VCN.

                - The Creating Resources dialog is displayed (not shown here) showing all VCN components being created.

            - Click View Virtual Cloud Network to view your new VCN.

        - You have successfully created a VCN to host your compute instance.

    - Gather Required Information

        - Prepare the information you need and copy them into your notepad.

            - Compartment Name: (your-compartment-name)

                - Find your compartment name from the Create a Compartment tutorial you performed in the Before you Begin section.

            - Collect the following information from the Oracle Cloud Infrastructure Console.

                - Compartment ID: (compartment-ocid)

                    - In the Console search bar, enter (your-compartment-name).

                    - Click (your-compartment-name) in the search results.

                    - Copy the OCID.

                - Subnet ID: (subnet-ocid)

                    - Open the navigation menu and click Networking, and then click Virtual Cloud Networks.

                    - Click (your-vcn-name) from section 2.

                    - Click the public subnet and copy OCID.

            - Find the source id for the image of the compute instance.

                - Source ID: (source-ocid)

                    - In the Console's top navigation bar, find your region.

                    - Go to https://docs.oracle.com/en-us/iaas/images/  

                    - Click Ubuntu 20.04 and click the latest image: Canonical-Ubuntu-20.04-(date).

                    - Find the image for your region and copy OCID.

                    - Note

                        - Ensure that you select a commercial OCID without gov in its OCID.

            - Choose the shape for the compute instance.

                - Shape: VM.Standard2.1

                    - To choose a different shape, go to VM Standard Shapes.

            - Collect the following information from your environment.

                - SSH Authorized Key (public key path): (ssh-public-key-path)

                    - From section 1, get the path to the SSH public key on your environment.

                    - You use this path when you set up the compute instance.

                - Private SSH Key Path: (ssh-private-key-path)

                - From the Create SSH Encryption Keys section, get the path to the SSH private key.

                - You use this private key to connect to your compute instance. 

    - Add Resource Policy

        - If your username is in the Administrators group, then skip this section. Otherwise, have your administrator add the following policy to your tenancy:

        ```
            allow group <the-group-your-username-belongs> to manage all-resources in compartment <your-compartment-name>
        ``` 

        - With this privilege, you can manage all resources in your compartment, essentially giving you administrative rights in that compartment.

            - Steps to Add the Policy
                
                - Open the navigation menu and click Identity & Security. Under Identity, click Policies.

                - Select your compartment from the Compartment drop-down.

                - Click Create Policy.

                - Fill in the following information:

                    - Name: manage-(your-compartment-name)-resources

                    - Description: Allow users to list, create, update, and delete resources in (your-compartment-name).

                    - Compartment: (your-tenancy)(root)

                - For Policy Builder, select the following choices:

                    - Policy use cases: Compartment Management

                    - Common policy templates: Let compartment admins manage the compartment

                    - Groups: (the-group-your-username-belongs)

                    - Location: (your-tenancy)(root)

                - Click Create.

## Create Scripts

* Create four scripts: one for authentication, one to fetch data, one to create a compute instance, and one to print outputs.

    - availablity-domains.tf
    - compute.tf
    - output.tf
    - provider.tf

## Run Scripts

```
terraform init
```

```
terraform plan
```

```
terraform apply
```