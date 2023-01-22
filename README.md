# GitLab_CICD_Pipeline_using_Terraform
Integrates GitLab and Terraform for automated infrastructure deployment

Whenever there is a change to our Terraform repository, infrastructure deployment can be automated

gitlab-ci.yml defines a set of jobs to be executed as part of the pipeline.
Image : Specify the docker image that the job runs in.
Variables : Define CICD variables that are passed to jobs.
before_script : Specify initialization commands to run before jobs.
Stages : Define when to run the jobs. It is executed in the order we define
Specify the scripts and dependencies required for each stage
Apply and destroy stages get executed after manual approval




