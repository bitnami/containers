# Testing information

At Bitnami, we are committed to ensure the quality of the apps we deliver, and as such, tests play a fundamental role in the `bitnami/containers` repository. Bear in mind that every contribution to our containers is ultimately published to our container repositories, where it is made available for the rest of the community to benefit from. Before this happens, different checks are required to succeed. More precisely, tests are run when:

1. A new contribution (regardless of its author) is made through a GitHub Pull Request.
2. Accepted changes are merged to the `main` branch, prior to their release.

This strategy ensures that a set of changes must have succeeded twice before a new version is sent out to the public.

In this section, we will discuss:

* [Where to find the tests](#where-to-find-the-tests)
* [VMware Image Builder (VIB)](#vmware-image-builder-vib)
* [VIB pipeline files](#vib-pipeline-files)
  * [vib-verify.json vs vib-publish.json](#vib-verifyjson-vs-vib-publishjson)
* [Testing strategy](#testing-strategy)
  * [Defining the scope](#defining-the-scope)
  * [Implementing the strategy](#implementing-the-strategy)
  * [Runtime parameters](#runtime-parameters)
* [Test types and tools](#test-types-and-tools)
* [Generic acceptance criteria](#generic-acceptance-criteria)
* [GOSS](#goss)
  * [Run GOSS locally](#run-goss-locally)
  * [Useful GOSS information](#useful-goss-information)
  * [Specific GOSS acceptance criteria](#specific-goss-acceptance-criteria)

## Where to find the tests

All the apps have an associated folder inside [/.vib](https://github.com/bitnami/containers/tree/main/.vib) with their custom tests implementation (the `goss` subfolder) and files containing their test plans (`vib-verify.json` and `vib-publish.json`).

## VMware Image Builder (VIB)

The service that powers the verification of the thousands of monthly tests performed in the repository is VMware Image Builder. VMware Image Builder (VIB) is a platform-agnostic, API-first modular service that allows large enterprises and independent software vendors to automate the packaging, **verification**, and publishing processes of software artifacts on any platform and cloud.

For more information about VIB, you can refer to [its official page](https://tanzu.vmware.com/image-builder).

## VIB pipeline files

The CI/CD pipelines in the repository are configured to trigger VIB when an app needs to be verified. But as every application is different, VIB needs to be supplied with a definition of the set of actions and configurations that precisely describe the verification process to perform in each case. This is the role of the aforementioned `vib-verify.json` and `vib-publish.json` files, which every app defines and can be found alongside its tests inside the `/.vib` folder.

Let's take a look at an example and try to understand it!

```json
{
  "context": {
    "resources": {
      "url": "{SHA_ARCHIVE}",
      "path": "{VIB_ENV_PATH}"
    },
    "runtime_parameters": "Y29tbWFuZDogWyJ0YWlsIiwgIi1mIiwgIi9kZXYvbnVsbCJd"
  },
  ...
  "phases": {
    ...
    "verify": {
      "actions": [
        {
          "action_id": "goss",
          "params": {
            "resources": {
              "path": "/.vib"
            },
            "tests_file": "wordpress/goss/goss.yaml",
            "vars_file": "wordpress/goss/vars.yaml",
            "remote": {
              "pod": {
                "workload": "deploy-wordpress"
              }
            }
          }
        },
        {
          "action_id": "trivy",
          "params": {
            "threshold": "CRITICAL",
            "vuln_type": [
              "OS"
            ]
          }
        },
        ...
      ]
    }
  }
}
```

This guide will focus in the `verify` phase section, of which there are some things to remark:

* For the testing of containers, VIB will take the built container in the previous `package` phase and include it in a basic Helm chart template composed of a deployment and service template. Be aware VIB will only be taking into account the docker image `ENTRYPOINT/CMD` command of the image. Consecuently, this both simplifies and limits the configuration of the template chart and container image tested underneath.

* A container's testing phase will usually include a single `goss` testing action, followed by additional security-related actions.

### vib-verify.json vs vib-publish.json

Going back to what we explained in the introduction, there are two different events that will trigger the test's execution. The following two files are associated to those two events respectively:

- The `vib-verify.json` pipeline definition file will be used to verify the changes proposed in a PR.
- The `vib-publish.json` file will instead define the pipeline launched when the proposed changes are merged to `main`.

Both files define what VIB should do when they are triggered and thus tweaking the files allows to define different action policies depending on the event that was fired. Nevertheless, it was decided that the verification process should be identical in both cases. Therefore, the `verify` section in `vib-verify.json` and `vib-verify.json` files must coincide.

> NOTE: Some containers with per-branch ARM support use separate `vib-publish.json` pipelines for the said branches. Remember to also include the testing-related changes on those pipelines.

## Testing strategy

### Defining the scope

As a starting point for this strategy, containers are to be considered as a middle artifact to be used by its corresponding chart and not as a final deliverable. This is a distinction that will affect the nature of the container tests. Essentially, we are assuming that most apps’ integration and functional tests are performed in the related chart’s test suite and should not be duplicated for the containers catalog.

This strategy has to be understood together with the testing limitations for containers mentioned above. These restraints prevent us from setiing up complex multi-container testing scenarios, which is a necessity for most of our containers to be initialized properly. To work around this, we'll only test up to the postunpack phase of the container (where the initial filesystem changes are done). As a consecuence, we will concentrate on the verification of the app’s compilation and the container’s filesystem itself.

Some examples on the suitability of tests for the `bitnami/wordpress` container:

* ✅ Checking apache config added in Wordpress' postunpack stage
* ❌ Manually finishing the container initialization to run functional tests
* ✅ Checking the image filesystem (created dirs existence, changed permissions, etc) related to the compilation/postunpack stages
* ❌ Verifying bash logic performed at `libwordpress.sh`, as we'll run Goss before that logic is executed.
* ✅ Testing binaries' existance and usability

Something of note is the equality on scope for the whole container catalog. Though some apps do not require additional containers to run and can be fully initialised as they are, we will be using the same testing setup for every container.

### Implementing the strategy

* Check Dockerfile
  * Included nami modules contain binaries -> use `check-binaries.yaml` Goss template
  * Check whether the ca-certificates pakage is downloaded -> Use `check-ca-certificates.yaml` template
* Check compilation logic
  * Check whether files or directories are created and/or with permission changes -> Use `check-directories.yaml` and/or `check-files.yaml` templates.
  * Check whether there are additional files/dirs modifications -> Use custom filesystem tests
  * Add tests for any compilation options or flags used
  * No distro-specific tests are included
* Check postunpack script
  * Check whether there are files or directories created w/o permission changes -> Add `check-directories.yaml` and/or `check-files.yaml` templates.
  * Check whether there are additional files/dirs modifications -> Add custom filesystem tests
* Check asset version -> Test version with `check-app-version.yaml` if $APP_VERSION` follows semver version
* Check asset-dependant tests
  * If the app is a runtime, test the runtime is able to run a compatible file
  * If the app requires yet-to-run initialization logic:
    * No complex configuration nor testing environment is created manually
    * If possible, test the asset's basic features
  * If the app is just a part of a bigger setup (exporter, multi-container assets, etc.):
    * No testing environment is created manually
    * If possible, test the asset's basic features
  * If the app uses subcomponents (java/php, apache, etc.)
    * If possible, test a subcomponent when there is custom config added to them
    * Check whether the subcomponent is capable of running the asset
* Final checks
  * When possible, NO per-branch tests are used
  * Every Goss template is included in `goss.yaml` and the needed vars are in place

#### Runtime parameters

/dev/null

Depending on the tool used, additional acceptance criteria may apply. Please, refer to the corresponding section for further info.

## GOSS

[GOSS](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md) is the framework used to implement integration tests. It is the reference tool to use when tests require interaction with a specific pod, with its tests being executed from within the pod.

In order for VIB to execute GOSS tests, the following block of code needs to be defined in the corresponding [VIB pipeline files](#vib-pipeline-files) (`/.vib/app/vib-{verify,publish}.json`).

> Values denoted withing dollar signs (`$$VALUE$$`) should be treated as placeholders

```json
        {
          "action_id": "goss",
          "params": {
            "resources": {
              "path": "/.vib"
            },
            "tests_file": "$$app$$/goss/goss.yaml",
            "vars_file": "$$app$$/goss/vars.yaml",
            "remote": {
              "pod": {
                "workload": "deploy-$$app$$" // As explained previously, the used template is always a deployment
              }
            }
          }
        }
```

Related files should be located under `/.vib/app/goss`.

### Run GOSS locally

Sometimes it is of interest to run the tests locally, for example during development. Though there may be different approaches, you may follow the steps below to execute the tests locally:

1. Download the [GOSS binary for Linux AMD64](https://github.com/goss-org/goss/releases/)

2. Add the binary and test files to the tested container as volumes

    ```bash
    $ docker run -d -it bitnami/app_name bash -c "tail -f /dev/null"
    e696196fba

    $ docker cp /local/path/to/binary/goss-linux-amd64 e6961:/usr/local/bin/gossctl
    $ docker cp /local/path/to/repo/containers/.vib e6961:/goss
    ```

3. Grant execution permissions to the binary and launch the tests

    ```bash
    $ docker exec e6961 chmod +x /usr/local/bin/gossctl
    $ docker exec e6961 gossctl --gossfile /goss/app_name/goss/goss.yaml --vars /goss/app_name/goss/vars.yaml validate
    .........

    Total Duration: 1.203s
    Count: 11, Failed: 0, Skipped: 0
    ```

## Generic acceptance criteria

In order for your test code PR to be accepted the following criteria must be fulfilled:

* [ ] Test scope needs to be focused on **installation** of the app and not testing the app
* [ ] Key features of the app should be covered, when possible
* [ ] Tests need to contain assertions
* [ ] Tests need to be stateless
* [ ] Tests need to be independent
* [ ] Tests need to be retry-able
* [ ] Tests need to be executable in any order
* [ ] Test code needs to be peer-reviewed
* [ ] Tests need to be as minimalistic as possible
* [ ] Tests should run properly for future versions without major changes
* [ ] Avoid hardcoded values
* [ ] Include only necessary files
* [ ] Test code needs to be [maintainable](https://testautomationpatterns.org/wiki/index.php/MAINTAINABLE_TESTWARE)
* [ ] Test names should be descriptive
* [ ] Test data should be generated dynamically

### Specific GOSS acceptance criteria

* [ ] Main test file name should be `goss.yaml`
* [ ] Tests should not rely on system packages (e.g. `curl`). Favor built-in GOSS primitives instead
* [ ] Prefer checking the exit status of a command rather than looking for a specific output. This will avoid most of the potential flakiness

### Useful GOSS information

As our Charts implement some standardized properties, there are a number of test cases that have been found recurrently throughout the catalog:

* Correct user ID and Group of the running container
* Reachability of the different ports exposed through services
* Existence of mounted volumes
* Correct configuration was applied to a config file or enviroment variable
* Existence of a created Service Account
* Restricted capabilities are applied to a running container
* Valuable CLI checks (when available)

[Kong](https://github.com/bitnami/charts/blob/main/.vib/kong/goss/goss.yaml) or [MetalLB](https://github.com/bitnami/charts/blob/main/.vib/metallb/goss/goss.yaml) are two good examples of tests implementing some of the above.


