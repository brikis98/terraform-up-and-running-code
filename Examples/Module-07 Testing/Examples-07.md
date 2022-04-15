 
# Examples for Module 7 - Testing

The two examples provided illustrate a basic unit test and a basic integration test using only terraform HCL code. These examples are intended to only show test thinking when it comes to terraform and not establish a methodology for doing testing.

The code is very simplistic since it is intended to demonstrate some testing ideas, and using overly complex code would distract from the underlying teaching points.

One point to make is that we don't actually need sophisticated testing tools to write basic automated tests -- we can even use terraform HCL to write tests

## Example One - Unit Testing a Module

The unit being tested in example one is a module that takes a string as input and creates a bucket with that name. However, the module does not create a bucket with the correct name since there is some development code that uses a local name for the bucket instead. This code was inadvertently not removed after development.

In this case, the error is obvious and would be found with even a cursory inspection, but again, this is a very simplistic example.

### Step one

1. Run the code in the step one directory
2. Look in terraform.tfvars file to show the expected bucket name
3. The code runs without any errors or warnings, but fails to produce the right bucket

The takwaway is that in a more complicated deployment, this sort of error may not be noticed until things start failing, and then we have to start what might be a massive bug hunt.

### Step two

1. The first thing to be done is to make the Bucket module testable. There is no way to reference the created bucket to check any of its attributes
2. An output variable is created that returns the id of the created bucket
3. A test is added using an output that compares the id of the bucket with the value provided to the module

### Step three

1. The incorrect code is removed, and the test passes

---

## Example Two - Integration Testing

In this example, we have two modules, one creating an EC2 instance web server, and the other creating a security group. We can begin with the assumption that both modules work perfectly.

Integration testing is essentially ensuring we are connecting the parts of our infrastructure together correctly.

In this example, the problem will be omitted code. There will be nothing to connect the security group to the EC2 server

### Step One

1. Create the infrastructure and note that while there are no errors or warning, the resulting webserver does not work.
2. The problem is an integration error. The security group module works correctly, the EC2 module works correctly, but the error is that we connect the wrong security group to the EC2 instance.
3. There is a reference to the default security group in our code derived from a data block. This may be left over from some development work, but we connect to this instead of the actual security group we created for the application

### Step Two

1. Add the integration test to ensure that the security group we created is in fact the security group that the web server is using (this is the integration part)

2. Run the test and see the test fail

3. Add in the missing code and the test passes and the