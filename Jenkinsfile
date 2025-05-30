pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy infrastructure')
  }

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-access-key')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
  }

  stages {
    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        dir('terraform') {
          sh 'terraform apply -auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"'
        }
      }
    }

    stage('Ansible Playbook') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        script {
          def public_ip = sh(script: 'terraform -chdir=terraform output -raw public_ip', returnStdout: true).trim()

          writeFile file: 'ansible/inventory.ini', text: "[ec2]\n${public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem"

          dir('ansible') {
            sh 'ansible-playbook -i inventory.ini playbook.yml'
          }
        }
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { params.ACTION == 'destroy' }
      }
      steps {
        dir('terraform') {
          sh 'terraform destroy -auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"'
        }
      }
    }
  }
}
