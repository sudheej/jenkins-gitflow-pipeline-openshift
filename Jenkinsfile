def applicationName = "spring-boot-demo";
def applicationNameST = "${applicationName}-st";

pipeline{
    agent {
        label 'maven'
    }

    stages{
            stage('build') {
                steps{
                    git branch: 'master', url: 'https://github.com/sudheej/jenkins-gitflow-pipeline-openshift.git'
                    sh script: "cd ${applicationName} && mvn -DskipTests clean package && pwd && ls -ltR"   
                }
            }   
            stage('unit tests') {
                steps{
                    sh script: "cd ${applicationName} && mvn test"   
                }
            }    
            stage('s2i build'){
                steps{
                script{
                    openshift.withCluster(){
                        openshift.withProject(){
                            openshift.selector("bc", "spring-boot-demo-pipeline").startBuild("--from-file=${applicationName}/target/demo-0.0.1-SNAPSHOT.jar", "--wait=true")                       
                        }
                    }
                }
            }            
            }
            stage('wait until available'){
                steps{
                    script{
                        openshift.withCluster() {
                            openshift.withProject() {
                                def dc = openshift.selector('dc',applicationName )
                                dc.rollout().status()
                            }
                        }                
                    }
                }
            }
        }    
    }               