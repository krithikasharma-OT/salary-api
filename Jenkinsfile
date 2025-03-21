pipeline {
    agent any

    tools{
        maven 'Maven3.9'
        jdk 'JDK17'
    }
    
    stages {
        stage('code checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krithikasharma-OT/salary-api.git'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'sudo apt update && sudo apt install -y make curl jq '
                sh '''
                    # Install migrate CLI
                    curl -L https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-amd64.tar.gz | tar xvz
                    
                    # Move migrate binary to a directory in PATH
                    sudo mv migrate /usr/local/bin/
                    
                    # Verify migrate installation
                    migrate -version
                    '''
            }
        }
        
        stage('Build Application') {
            steps {
                sh 'make build'
            }
        }
        
        stage('format') {
            steps {
                sh 'make fmt'
            }
        }
      
        
        stage('Run Tests') {
            steps {
                sh 'make test'
            }
        }
        
        
        stage('Docker Build') {
            steps {
                sh 'make docker-build'
            }
        }
        
        stage('Docker push') {
            steps {
                sh 'make docker-push'
            }
        }
        
        
        
        stage('Run Migrations') {
            steps {
                sh 'make run-migrations'
            }
        }
        
        stage(' deploy'){
            steps{
                sh 'make deploy'
            }
        }
    }
}
