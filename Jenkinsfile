def applicationName = "spring-boot-demo";
def applicationNameST = "${applicationName}-st";

pipeline{
    agent {
        label 'maven'
    }

    stages{
            stage('build') {
                steps{
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
                            def build = openshift.selector("bc", "spring-boot-demo-pipeline");
                            def startedBuild = build.startBuild("--from-file=\"./${applicationName}/target/demo-0.0.1-SNAPSHOT.jar\"");                          
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