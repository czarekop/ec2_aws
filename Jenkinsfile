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
                     // Dodaj ścieżkę do Terraforma do PATH
                    def terraformHome = tool name: 'terraform', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
                    env.PATH = "${terraformHome}/bin:${env.PATH}"
                    sh "which terraform"
                    sh """
                        terraform init ${env.WORKSPACE}/ec2_aws
                        terraform plan -out tfplan ${env.WORKSPACE}/ec2_aws
                        terraform show -no-color tfplan > ${env.WORKSPACE}/ec2_aws/tfplan.txt
                    """
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
                sh "pwd;cd Terraform/ ; Terraform apply -input=false tfplan"
            }
        }
    }

  }