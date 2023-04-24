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

            - Compartment Name: <your-compartment-name>

                - Find your compartment name from the Create a Compartment tutorial you performed in the Before you Begin section.

            - Collect the following information from the Oracle Cloud Infrastructure Console.

                - Compartment ID: <compartment-ocid>

                    - In the Console search bar, enter <your-compartment-name>.

                    - Click <your-compartment-name> in the search results.

                    - Copy the OCID.

                - Subnet ID: <subnet-ocid>

                    - Open the navigation menu and click Networking, and then click Virtual Cloud Networks.

                    - Click <your-vcn-name> from section 2.

                    - Click the public subnet and copy OCID.

            - Find the source id for the image of the compute instance.

                - Source ID: <source-ocid>

                    - In the Console's top navigation bar, find your region.

                    - Go to Image Release Notes.

                    - Click Ubuntu 20.04 and click the latest image: Canonical-Ubuntu-20.04-<date>.

                    - Find the image for your region and copy OCID.

                    - Note

                        - Ensure that you select a commercial OCID without gov in its OCID.

            - Choose the shape for the compute instance.

                - Shape: VM.Standard2.1

                    - To choose a different shape, go to VM Standard Shapes.

            - Collect the following information from your environment.

                - SSH Authorized Key (public key path): <ssh-public-key-path>

                    - From section 1, get the path to the SSH public key on your environment.

                    - You use this path when you set up the compute instance.

                - Private SSH Key Path: <ssh-private-key-path>

                - From the Create SSH Encryption Keys section, get the path to the SSH private key.

                - You use this private key to connect to your compute instance.







    - Collect the following information from the Oracle Cloud Infrastructure Console and copy it into your notepad.

    - Tenancy OCID: (tenancy-ocid)
    From your user avatar, go to Tenancy: (your-tenancy) and copy OCID.

* Add Compartment Policy

    - If your username is in the Administrators group, then skip this section. Otherwise, have your administrator add the following policy to your tenancy

    - Steps to Add the Policy

        - In the top navigation bar, open the Profile menu.
        - Click your username.
        - In the left pane, click Groups.
        - In a notepad, copy the Group Name that your username belongs.
        - Open the navigation menu and click Identity & Security. Under Identity, click Policies.
        - Select your compartment from the Compartment drop-down.
        - Click Create Policy.
        - Fill in the following information:
            - Name: manage-compartments
            - Description: Allow the group <the-group-your-username-belongs> to list, create, update, delete and recover compartments in the tenancy.
            - Compartment: <your-tenancy>(root)
        - For Policy Builder, click Show manual editor.
        - Paste in the following policy:
        ```
        allow group <the-group-your-username-belongs> to manage compartments in tenancy
        ```
        - Click Create.

## Create Scripts

* Create three scripts: one for authentication, one to create a compartment, and one to print outputs.

    - compartment.tf
    - output.tf
    - provider.tf

## Create a Compartment

* Initialize
    - Initialize a working directory in the current directory.
        ```
        terraform init
        ```

    - Confirm that Terraform has been successfully initialized!.

        Example output:
        ```
        Initializing the backend...

        Initializing provider plugins...
        - Finding latest version of hashicorp/oci...
        - Installing hashicorp/oci vx.x.x...
        - Installed hashicorp/oci vx.x.x (signed by HashiCorp)

        Terraform has been successfully initialized!
        ```
* Plan

    - Create an execution plan to check whether the changes shown in the execution plan match your expectations, without changing the real resources.
        ```
        terraform plan
        ```
    - Confirm that you have Plan: 0 to add, 0 to change, 0 to destroy.
        
        Example output:

        ```
        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
        the following symbols:
        + create

        Terraform will perform the following actions:

        # oci_identity_compartment.tf-compartment will be created
        + resource "oci_identity_compartment" "tf-compartment" {
            + compartment_id = "ocid1.tenancy.xxx"
            + defined_tags   = (known after apply)
            + description    = "Compartment for Terraform resources."
            + freeform_tags  = (known after apply)
            + id             = (known after apply)
            + inactive_state = (known after apply)
            + is_accessible  = (known after apply)
            + name           = "<your-compartment-name>"
            + state          = (known after apply)
            + time_created   = (known after apply)
            }

        Plan: 1 to add, 0 to change, 0 to destroy.

        Changes to Outputs:
        + compartment-OCID = (known after apply)
        + compartment-name = "<your-compartment-name>"
        ```

* Apply

    - Create your compartment with Terraform:

        ```
        terraform apply
        ```
    - When prompted for confirmation, enter yes, for your resource to be created.

    - (Optional) Watch the creation from the Console:

        - Open the navigation menu and click Identity & Security. Under Identity, click Compartments.

        - Refresh the page, until you see the compartment name.

        - Click the compartment name to see its details such as its OCID.
    
    - In the output terminal, review your defined outputs.

        Example output:
        ```
        oci_identity_compartment.tf-compartment: Creating...
        oci_identity_compartment.tf-compartment: Creation complete after 9s [id=xxx]

        Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

        Outputs:

        compartment-OCID = ocid1.compartment.xxx
        compartment-name = <your-compartment-name>
        ```

Congratulations! You have successfully logged in and created a compartment in your tenancy, using the Oracle Cloud Infrastructure Terraform provider.