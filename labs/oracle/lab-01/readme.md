# Terraform: Set Up OCI Terraform

## Prepare

* Get Tenancy Information

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

* Create three scripts: one for authentication, one to fetch data from your account, and one to print outputs.

    - availability-domains.tf
    - output.tf+
    - provider.tf

## Run Script

* Initialize
    - Initialize a working directory in the current directory.
        ```
        terraform init
        ```

    - Check the contents of the working directory.
        ```
        ls -a
        ```
        You now have a folder called .terraform that includes the plugins for the oci provider.

* Plan

    - Create an execution plan to check whether the changes shown in the execution plan match your expectations, without changing the real resources.
        ```
        terraform plan
        ```
    - Confirm that you have Plan: 0 to add, 0 to change, 0 to destroy.
        
        Example output:

        ```
        Changes to Outputs:
        + all-availability-domains-in-your-tenancy = [
            + {
                + compartment_id = "ocid1.tenancy.oc1..xxx"
                + id             = "ocid1.availabilitydomain.xxx"
                + name           = "QnsC:US-ASHBURN-AD-1"
                },
            + {
                + compartment_id = "ocid1.tenancy.oc1..xxx"
                + id             = "ocid1.availabilitydomain.xxx"
                + name           = "QnsC:US-ASHBURN-AD-2"
                },
            + {
                + compartment_id = "ocid1.tenancy.oc1..xxx"
                + id             = "ocid1.availabilitydomain.xxx"
                + name           = "QnsC:US-ASHBURN-AD-3"
                },
            ]

        You can apply this plan to save these new output values to the Terraform state, without changing any real
        infrastructure.
        ```
    - Note
    
        You are fetching data, so the plan shows that you are only adding outputs. You are not adding, changing, or destroying any resources.

* Apply

    - Run your Terraform scripts and get your outputs:

        ```
        terraform apply
        ```
    - When prompted for confirmation, enter yes, for your resource to be created.
    
        After you run the apply command, the output is displayed in the terminal.

        Example output:
        ```
        Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

        Outputs:

        all-availability-domains-in-your-tenancy = tolist([
        {
            "compartment_id" = "ocid1.tenancy.xxx"
            "id" = "ocid1.availabilitydomain.xxx"
            "name" = "QnsC:US-ASHBURN-AD-1"
        },
        {
            "compartment_id" = "ocid1.tenancy.xxx"
            "id" = "ocid1.availabilitydomain.xxx"
            "name" = "QnsC:US-ASHBURN-AD-2"
        },
        {
            "compartment_id" = "ocid1.tenancy.xxx"
            "id" = "ocid1.availabilitydomain.xxx"
            "name" = "QnsC:US-ASHBURN-AD-3"
        },
        ])
        ```

Congratulations! Your Oracle Cloud Infrastructure account can now authenticate your Oracle Cloud Infrastructure Terraform provider scripts.
