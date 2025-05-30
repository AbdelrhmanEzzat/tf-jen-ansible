pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['Apply', 'Destroy'], description: 'Select the action to perform')
  }

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
  }

  stages {
    stage('Checkout Repo') {
      steps {
        git branch: 'main', url: 'https://github.com/AbdelrhmanEzzat/ITI-Final-Project.git'
      }
    }

    stage('Terraform Action') {
      steps {
        dir('terraform') {
          sh 'terraform init -input=false'

          script {
            if (params.ACTION == 'Destroy') {
              sh """
                terraform destroy \
                  -var="aws_access_key=${AWS_ACCESS_KEY_ID}" \
                  -var="aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
                  -var-file=tf-dev.tfvars -auto-approve
              """
            } else {
              sh """
                terraform apply \
                  -var="aws_access_key=${AWS_ACCESS_KEY_ID}" \
                  -var="aws_secret_key=${AWS_SECRET_ACCESS_KEY}" \
                  -var-file=tf-dev.tfvars -auto-approve
              """
              build job: 'final-iti-project-deploy'
            }
          }
        }
      }
    }

    // stage('Ansible Playbook') {
    //   when {
    //     expression { params.ACTION == 'Apply' }
    //   }
    //   steps {
    //     sshagent(['ec2-ssh']) {
    //       script {
    //         def public_ip = sh(
    //           script: 'terraform -chdir=Terraform output -raw public_ip',
    //           returnStdout: true
    //         ).trim()

    //         writeFile file: 'ansible/inventory.ini', text: """
    //           [ec2]
    //           ${public_ip} ansible_user=ubuntu
    //         """

    //         dir('ansible') {
    //           sh 'ansible-playbook -i inventory.ini playbook.yml'
    //         }
    //       }
    //     }
    //   }
    // }
  }

  post {
    success {
      echo '✅ Terraform operation completed successfully!'
    }
    failure {
      echo '❌ Terraform operation failed!'
    }
  }
}
