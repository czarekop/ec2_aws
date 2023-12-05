pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("ec2_aws")
                        {
                            git "https://github.com/czarekop/ec2_aws.git"
                        }
                    }
                }
            }

       stage('Plan') {
          steps {
              script {
                  // Add Terraform to the PATH
                  def terraformHome = tool name: 'terraform', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
                  env.PATH = "${terraformHome}/bin:${env.PATH}"
                  // Change working directory and run terraform commands
                 dir("${env.WORKSPACE}/ec2_aws") {
                     sh """
                         terraform init
                         terraform plan -out tfplan
                         terraform show -no-color tfplan > tfplan.txt
                     """
                 }
              }
        }
}
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'Terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                script {
                    echo "Current directory: ${env.WORKSPACE}/ec2_aws"
                    // Change working directory and run terraform apply
                    dir("${env.WORKSPACE}/ec2_aws") {
                        echo "Running terraform apply command"
                        sh "terraform apply -input=false tfplan"
                    }
                }
            }
         }