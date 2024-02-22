// Inspired by https://github.com/jenkinsci/jenkins/blob/e1beed03962bbc3777a49a041109b8752d98d2ed/core/src/main/java/jenkins/install/SetupWizard.java

import jenkins.security.s2m.AdminWhitelistRule;
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.*;
import jenkins.install.*;
import hudson.security.*;
import hudson.model.*;

// Set Hudson Security
def jenkins = Jenkins.getInstance()
def securityRealm = new HudsonPrivateSecurityRealm(false, false, null)
jenkins.setSecurityRealm(securityRealm)

// Create new admin account
println " [bitnami/groovy-init-jenkins] Creating admin user"
def adminUsername = '{{JENKINS_USERNAME}}'
def adminPassword = '{{JENKINS_PASSWORD}}'
securityRealm.createAccount(adminUsername, adminPassword)
println " [bitnami/groovy-init-jenkins] Admin user created: {{JENKINS_USERNAME}}:*******"
if (adminUsername != 'admin') {
    // Delete the existing by default admin account
    User u = User.get('admin')
    u.delete()
}

// Set Authorization strategy
println " [bitnami/groovy-init-jenkins] Setting Authorization Strategy"
def authStrategy = new FullControlOnceLoggedInAuthorizationStrategy();
authStrategy.setAllowAnonymousRead(false);
jenkins.setAuthorizationStrategy(authStrategy);
println " [bitnami/groovy-init-jenkins] Authorization Strategy set"

// Disable jnlp by default, but honor system properties
println " [bitnami/groovy-init-jenkins] Disabling JNLP"
jenkins.setSlaveAgentPort(-1);
println " [bitnami/groovy-init-jenkins] JNLP disabled"

// require a crumb issuer
println " [bitnami/groovy-init-jenkins] Enabling CSRF Protection"
jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true));
println " [bitnami/groovy-init-jenkins] CSRF Protection enabled"

// Set master-slave security
println " [bitnami/groovy-init-jenkins] Setting master-slave security"
jenkins.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false);
println " [bitnami/groovy-init-jenkins] master-slave security set"

jenkins.save()

// Complete wizard
println " [bitnami/groovy-init-jenkins] Passing wizard"
def wizard = new SetupWizard()
wizard.init(true)
wizard.completeSetup()
println " [bitnami/groovy-init-jenkins] Wizard passed"
