// Inspired by https://github.com/jenkinsci/jenkins/blob/e1beed03962bbc3777a49a041109b8752d98d2ed/core/src/main/java/jenkins/install/SetupWizard.java

import jenkins.security.s2m.AdminWhitelistRule;
import hudson.security.csrf.DefaultCrumbIssuer;
import jenkins.security.QueueItemAuthenticatorConfiguration;
import org.jenkinsci.plugins.authorizeproject.*;
import org.jenkinsci.plugins.authorizeproject.strategy.*;
import org.jenkinsci.plugins.matrixauth.*;
import jenkins.model.*;
import jenkins.install.*;
import hudson.security.*;
import hudson.model.*;

// Set Hudson Security
def jenkins = Jenkins.getInstance()
def securityRealm = new HudsonPrivateSecurityRealm(false, false, null)
jenkins.setSecurityRealm(securityRealm)

// Create new admin account
println " [bitnami/groovy-init-jenkins-with-slaves] Creating Jenkins users"
def adminUsername = '{{JENKINS_USERNAME}}'
def adminPassword = '{{JENKINS_PASSWORD}}'
securityRealm.createAccount(adminUsername, adminPassword)
println " [bitnami/groovy-init-jenkins-with-slaves] Admin user created: {{JENKINS_USERNAME}}:*******"
if (adminUsername != 'admin') {
    // Delete the existing by default admin account
    User u = User.get('admin')
    u.delete()
}
// Create slave account
def slaveUsername = '{{JENKINS_SWARM_USERNAME}}'
def slavePassword = '{{JENKINS_SWARM_PASSWORD}}'
securityRealm.createAccount(slaveUsername, slavePassword)
println " [bitnami/groovy-init-jenkins-with-slaves] Slave user created: {{JENKINS_SWARM_USERNAME}}:*******"
// Create system account. Same password than admin account
def systemUsername = 'system_user'
def systemPassword = '{{JENKINS_PASSWORD}}'
securityRealm.createAccount(systemUsername, systemPassword)
println " [bitnami/groovy-init-jenkins-with-slaves] System user created: system_user:*******"

// Set Authorization strategy
// Roles based on https://wiki.jenkins-ci.org/display/JENKINS/Matrix-based+security
println " [bitnami/groovy-init-jenkins-with-slaves] Setting Authorization Strategy"
def strategy = new GlobalMatrixAuthorizationStrategy()
// Setting Slave Permissions
// Slave Permissions
strategy.add(hudson.model.Computer.BUILD, new PermissionEntry(AuthorizationType.USER, slaveUsername))
strategy.add(hudson.model.Computer.CONFIGURE, new PermissionEntry(AuthorizationType.USER, slaveUsername))
strategy.add(hudson.model.Computer.CONNECT, new PermissionEntry(AuthorizationType.USER, slaveUsername))
strategy.add(hudson.model.Computer.CREATE, new PermissionEntry(AuthorizationType.USER, slaveUsername))
strategy.add(hudson.model.Computer.DELETE, new PermissionEntry(AuthorizationType.USER, slaveUsername))
strategy.add(hudson.model.Computer.DISCONNECT, new PermissionEntry(AuthorizationType.USER, slaveUsername))
// Overall Permissions
strategy.add(hudson.model.Hudson.READ, new PermissionEntry(AuthorizationType.USER, slaveUsername))
// Setting System Permissions
// System Permissions
strategy.add(hudson.model.Computer.BUILD, new PermissionEntry(AuthorizationType.USER, systemUsername))
strategy.add(hudson.model.Computer.CONFIGURE, new PermissionEntry(AuthorizationType.USER, systemUsername))
strategy.add(hudson.model.Computer.CONNECT, new PermissionEntry(AuthorizationType.USER, systemUsername))
strategy.add(hudson.model.Computer.CREATE, new PermissionEntry(AuthorizationType.USER, systemUsername))
strategy.add(hudson.model.Computer.DELETE, new PermissionEntry(AuthorizationType.USER, systemUsername))
strategy.add(hudson.model.Computer.DISCONNECT, new PermissionEntry(AuthorizationType.USER, systemUsername))
// Overall Permissions
strategy.add(hudson.model.Hudson.READ, new PermissionEntry(AuthorizationType.USER, systemUsername))
// Setting Admin Permissions
// Admin Permissions
strategy.add(hudson.model.Computer.BUILD, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Computer.CONFIGURE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Computer.CONNECT, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Computer.CREATE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Computer.DELETE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Computer.DISCONNECT, new PermissionEntry(AuthorizationType.USER, adminUsername))
//  Overall Permissions
strategy.add(hudson.model.Hudson.ADMINISTER, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.PluginManager.CONFIGURE_UPDATECENTER, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Hudson.READ, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Hudson.RUN_SCRIPTS, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.PluginManager.UPLOAD_PLUGINS, new PermissionEntry(AuthorizationType.USER, adminUsername))
//  Job Permissions
strategy.add(hudson.model.Item.BUILD, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.CANCEL, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.CONFIGURE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.CREATE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.DELETE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.DISCOVER, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.READ, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Item.WORKSPACE, new PermissionEntry(AuthorizationType.USER, adminUsername))
//  Run Permissions
strategy.add(hudson.model.Run.DELETE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.Run.UPDATE, new PermissionEntry(AuthorizationType.USER, adminUsername))
//  View Permissions
strategy.add(hudson.model.View.CONFIGURE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.View.CREATE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.View.DELETE, new PermissionEntry(AuthorizationType.USER, adminUsername))
strategy.add(hudson.model.View.READ, new PermissionEntry(AuthorizationType.USER, adminUsername))
jenkins.setAuthorizationStrategy(strategy);
println " [bitnami/groovy-init-jenkins-with-slaves] Authorization Strategy set"

// Configure Authorize Project Plugin
// Proper rules are needed to increase the security settings of the jobs and to avoid warning messages
println " [bitnami/groovy-init-jenkins-with-slaves] Configuring 'Authorize Project' plugin"
def configureGlobalAuthenticator = true
def configureProjectAuthenticator = true
def authenticators = QueueItemAuthenticatorConfiguration.get().getAuthenticators()
for (authenticator in authenticators) {
  if (authenticator instanceof GlobalQueueItemAuthenticator) {
    println " [bitnami/groovy-init-jenkins-with-slaves]     Skipping global build authenticator, it exists"
    configureGlobalAuthenticator = false
  } else if (authenticator instanceof ProjectQueueItemAuthenticator) {
    println " [bitnami/groovy-init-jenkins-with-slaves]     Skipping per-project build authenticator, it exists"
    configureProjectAuthenticator = false
  }
}
if (configureGlobalAuthenticator) {
  def globalStrategy = new SpecificUsersAuthorizationStrategy(systemUsername)
  def globalStrategyName = globalStrategy.getDescriptor().getDisplayName()
  println " [bitnami/groovy-init-jenkins-with-slaves]     Configuring global build authenticator with '${globalStrategyName}' strategy"
  authenticators.add(new GlobalQueueItemAuthenticator(globalStrategy))
}
if (configureProjectAuthenticator) {
  def anonymousAuthorizationStrategyDescriptor = jenkins.getDescriptor(AnonymousAuthorizationStrategy.class)
  def triggeringUsersAuthorizationStrategyDescriptor = jenkins.getDescriptor(TriggeringUsersAuthorizationStrategy.class)
  def specificUsersAuthorizationStrategyDescriptor = jenkins.getDescriptor(SpecificUsersAuthorizationStrategy.class)
  def systemAuthorizationStrategyDescriptor = jenkins.getDescriptor(SystemAuthorizationStrategy.class)
  def projectStrategy = [
    (anonymousAuthorizationStrategyDescriptor.getId()): true,
    (triggeringUsersAuthorizationStrategyDescriptor.getId()): true,
    (specificUsersAuthorizationStrategyDescriptor.getId()): true,
    (systemAuthorizationStrategyDescriptor.getId()): false
  ]
  println " [bitnami/groovy-init-jenkins-with-slaves]     Configuring per-project build authenticator"
  println " [bitnami/groovy-init-jenkins-with-slaves]         Allowing '${anonymousAuthorizationStrategyDescriptor.getDisplayName()}' strategy"
  println " [bitnami/groovy-init-jenkins-with-slaves]         Allowing '${triggeringUsersAuthorizationStrategyDescriptor.getDisplayName()}' strategy"
  println " [bitnami/groovy-init-jenkins-with-slaves]         Allowing '${specificUsersAuthorizationStrategyDescriptor.getDisplayName()}' strategy"
  authenticators.add(new ProjectQueueItemAuthenticator(projectStrategy))
}
println " [bitnami/groovy-init-jenkins-with-slaves] 'Authorize Project' plugin configuration finished"

// Configure JNLP port
println " [bitnami/groovy-init-jenkins-with-slaves] Configuring JNLP port"
jenkins.setSlaveAgentPort({{jnlp_port}})
println " [bitnami/groovy-init-jenkins-with-slaves] JNLP port is set to '{{jnlp_port}}'"

// require a crumb issuer
println " [bitnami/groovy-init-jenkins] Enabling CSRF Protection"
jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true));
println " [bitnami/groovy-init-jenkins] CSRF Protection enabled"

// Set master-slave security
println " [bitnami/groovy-init-jenkins] Setting master-slave security"
jenkins.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false);
println " [bitnami/groovy-init-jenkins] master-slave set"

// Set master executors
println " [bitnami/groovy-init-jenkins] Setting master executors to 0"
jenkins.setNumExecutors(0);
println " [bitnami/groovy-init-jenkins] master executors set"

jenkins.save()

// Complete wizard
println " [bitnami/groovy-init-jenkins-with-slaves] Passing wizard"
def wizard = new SetupWizard()
wizard.init(true)
wizard.completeSetup()
println " [bitnami/groovy-init-jenkins-with-slaves] Wizard passed"
