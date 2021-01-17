#!groovy
import groovy.json.JsonSlurperClassic
node
{
   def SF_CONSUMER_KEY='3MVG9SemV5D80oBcnvp.8CVjFSZsYXFOO5ZSxZPo_eIgsVFAeW.GKAW60IElPX92EBcyuZmSILsQp3WRsdMCc'
    def SF_USERNAME='absidhartha-sgkg@force.com'
    def SERVER_KEY_CREDENTIALS_ID='F59458678AAA4B5DA0E427E11A68D4F042ECB6147C83AD2FD695EB6AC1E913E7'
    def DEPLOYDIR='src'
    def TEST_LEVEL='RunLocalTests'
    def SF_INSTANCE_URL = "https://login.salesforce.com"
    def toolbelt = tool 'sfdx'


    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
    }
    
    
    // -------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce
    // JWT key credentials.
    // -------------------------------------------------------------------------

    stage('Push To Test Org') {
        rc = bat returnStatus: true, script: "\"${toolbelt}\" sfdx force:src:push --all --username ${SF_USERNAME} -y debug"
        //rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
        if (rc != 0) {
            error 'push all failed'
        }
    }
    
}