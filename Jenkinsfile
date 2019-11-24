zdef applicationName = "spring-boot-demo";
def applicationNameST = "${applicationName}-st";

pipeline{
    agent {
        label 'maven'
    }

    stages{
            stage('build') {
                steps{
                    sh script: "cd ${applicationName} && mvn -DskipTests clean package"   
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
                            def build = openshift.selector("bc", applicationName);
                            def startedBuild = build.startBuild("--from-file=\"./${applicationName}/target/*.jar\"");
                            startedBuild.logs('-f');
                            echo "${applicationName} build status: ${startedBuild.object().status}";                            
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