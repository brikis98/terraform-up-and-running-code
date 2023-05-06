#  Terraform: Create a Compartment

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