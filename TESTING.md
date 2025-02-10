# Testing information

At Bitnami, we are committed to ensuring the quality of the apps we deliver, and as such, tests play a fundamental role in the `bitnami/containers` repository. Bear in mind that every contribution to our containers is ultimately published to our container registries, where it is made available for the rest of the community to benefit from. Before this happens, different checks are required to succeed. More precisely, tests are run when a new contribution (regardless of its author) is made through a GitHub Pull Request.

In this section, we will discuss:

* [Where to find the tests](#where-to-find-the-tests)
* [VMware Image Builder (VIB)](#vmware-image-builder-vib)
* [VIB pipeline definition file](#vib-pipeline-definition-file)
* [Testing strategy](#testing-strategy)
  * [Defining the scope](#defining-the-scope)
  * [Runtime parameters](#runtime-parameters)
* [Generic acceptance criteria](#generic-acceptance-criteria)
* [GOSS](#goss)
  * [Test suite](#test-suite)
    * [GOSS Templates](#goss-templates)
    * [Composition](#composition)
  * [Run GOSS locally](#run-goss-locally)
  * [Specific GOSS acceptance criteria](#specific-goss-acceptance-criteria)

## Where to find the tests

All the apps have an associated folder inside [/.vib](https://github.com/bitnami/containers/tree/main/.vib) with their custom tests implementation (the `goss` subfolder) and the file containing their test plan (`vib-verify.json`).

## VMware Image Builder (VIB)

The service that powers the verification of the thousands of monthly tests performed in the repository is VMware Image Builder. [VMware Image Builder](https://tanzu.vmware.com/content/blog/how-bitnami-uses-vmware-image-builder-to-deploy-apps) (VIB) is a platform-agnostic, API-first modular service that allows large enterprises and independent software vendors to automate the packaging, **verification**, and publishing processes of software artifacts on any platform and cloud.

## VIB pipeline definition file

The CI pipeline in this repository will be used to verify the changes proposed in a PR and triggered by any new commits once said PR is ready to be verified. But as every application is different, VIB needs to be supplied with a definition of the set of actions and configurations that precisely describe the verification process to perform in each case. This is the role of the aforementioned `vib-verify.json` file, which every app defines and can be found alongside its tests inside the `/.vib` folder. Keeping it simple, the `vib-verify.json` file defines what VIB should do.

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
            "threshold": "LOW",
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

This guide will focus on the `verify` phase section, of which there are some things to remark on:

* For the testing of containers, VIB will take the container built in the previous `package` phase and include it in a basic Helm chart template composed of a deployment and service template.

* VIB does only allow to modify the `ENTRYPOINT/CMD` of the image (through `runtime_parameters`). Consequently, this both simplifies and limits the configurability of the template chart and container image tested underneath.

* A container's testing phase will usually include a single `goss` testing action, followed by additional security-related actions.

> [!NOTE]
> Some containers with per-branch ARM support use separate per-branch `vib-verify.json` pipelines. Remember to replicate changes performed on the main pipeline definition file to those pipelines.

## Testing strategy

### Defining the scope

This strategy has to be understood together with the VIB limitations for the containers mentioned above. These restraints prevent us from setting up complex multi-container testing scenarios, which is a necessity for most of our containers to be initialized properly. To work around this, we will only test up to the postunpack phase of the container (where the initial filesystem changes are done). Essentially, we are assuming that most apps’ integration and functional tests are performed in the related chart’s test suite and thus are not required to be duplicated for the containers catalog. As a consequence, we will concentrate on the verification of the app’s compilation logic and the container’s filesystem itself.

Some examples of the suitability of tests for the `bitnami/wordpress` container:

* ✅ Checking Apache config added in Wordpress' postunpack stage
* ❌ Manually finishing the container initialization to run functional tests
* ✅ Checking the image filesystem (created dirs existence, changed permissions, etc) related to the compilation/postunpack stages
* ❌ Verifying bash logic performed at `libwordpress.sh`, as we'll run Goss before that logic is executed
* ✅ Testing binaries' existence and usability

Something of note is the equality of scope for the whole container catalog. Though some apps do not require additional containers to run and can be fully initialised as they are, we will be using the same testing setup for every container.

### Runtime parameters

As of now, and linking with the scope definition we saw previously, the `runtime_parameters` field is only used to "stop" a container's initialization logic after its `postunpack` has been executed. The `runtime_parameters` value is a base64 encoded string going by `command: ["tail", "-f", "/dev/null"]` and is the same for every VIB pipeline defined in `bitnami/containers`.

## Generic acceptance criteria

For your test code PR to be accepted the following criteria must be fulfilled:

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

## GOSS

[GOSS](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md) is the framework used to implement integration tests and the only testing tool presently used in our VIB pipelines. It is the reference tool to use when tests require interaction with a specific pod, with its tests being executed from within the pod.

For VIB to execute GOSS tests, the following block of code needs to be defined in the corresponding [VIB pipeline definition file](#vib-pipeline-definition-file) (`/.vib/app/vib-verify.json`).

> [!NOTE]
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

### Test suite

A GOSS test suite for a given application can be divided in two. One half contains the tests specifically manufactured to verify different aspects of the application and the other half is intended to verify that the container complies with Bitnami's best practices. As some of these tests are oftentimes almost identical between different apps, we have compiled some of them in a series of GOSS templates to unify and simplify their usage.

#### GOSS Templates

At their core, GOSS templates are just tests of similar nature put together on a `.yaml` file under the `.vib/common/goss/templates` folder.

Every template is composed of:

* A brief description of the tests' nature
* Any needed vars it may use to run its tests
* One or more tests

To better understand them, let's see one of these templates:

```yaml
########################
# Checks binaries are added to the $PATH
# Needed vars:
#   - .Vars.binaries (Array)
########################
command:
  {{ range $binary := .Vars.binaries }}
  check-{{ $binary }}-binary:
    exec: which {{ $binary }}
    exit-status: 0
  {{ end }}
```

In the example above, we can see the template will execute a `which` command for every binary included in the `.Vars.binaries` array. These variables may be optional or required and must be defined in the `/.vib/app/goss/vars.yaml` file.

There are many different templates, some of them focusing on verifying specific types of apps (those that use PHP, NGINX, etc.) or a particular best practice. In the same vein, new templates can be added if a particular group of tests is going to be used by several apps.

#### Composition

There are instances where it is not needed to create custom tests for a given app, where using the templates will suffice. There will also be suites that may require the use of testing files to properly verify the app. Generally, a test suite can be composed of the following files:

```bash
.vib/java/goss
├── goss.yaml
├── java.yaml
├── testfiles
│   └── HelloTest.jar
└── vars.yaml
```

* [ ] The optional `app.yaml` file is where custom tests created just for the related app verification are included.
* [ ] The `goss.yaml` file should include the list of used GOSS templates as well as the `app.yaml` file (if necessary).
* [ ] The `vars.yaml` file should include every variable used in the templates.
* [ ] The `testfiles` folder should include any external files used in the `app.yaml` tests.

Not every suite will be composed of the same tests, as it will depend on the type of application, its Dockerfile, and the used compilation/configuration logic. The list below details each pillar that should be checked when creating a test suite as well as when to use some of the most common templates:

* Dockerfile check:
  * Does it include bitnami components which contain binaries? If so, use the `check-binaries.yaml` GOSS template.
  * Does it include the `ca-certificates` package? If so, use the `check-ca-certificates.yaml` template.
* Compilation logic check:
  * Are there files or directories created and/or with permission changes? If so, use the `check-directories.yaml` and/or `check-files.yaml` templates.
  * Are there additional files/dirs modifications? If so, use custom filesystem tests.
  * Add tests for any compilation options or flags used.
* Check postunpack script:
  * Are there files or directories created and/or with permission changes? If so, use the `check-directories.yaml` and/or `check-files.yaml` templates.
  * Are there additional files/dirs modifications? If so, use custom filesystem tests.
* Check apps version:
  * If `$APP_VERSION` follows semver version, use the `check-app-version.yaml` template.
* Check apps-dependant tests:
  * If the app is a runtime, test if the runtime can run a compatible file.
  * If the app requires yet-to-run initialization logic:
    * No complex configuration nor testing environment is created manually.
    * If possible, test the app's basic features.
  * If the app is just a part of a bigger setup (exporter, multi-container apps, etc.):
    * No testing environment is created manually.
    * If possible, test the app's basic features.
  * If the app uses subcomponents (java/php, apache, etc.):
    * If possible, test a subcomponent when there is a custom config added to them.
    * Verify whether the subcomponent is capable of running the app.
* Must-have templates to be added to every suite:
  * `check-linked.libraries.yaml`
  * `check-broken-symlinks.yaml`
  * `check-sed-in-place.yaml`
  * `check-spdx.yaml`
* Final checks:
  * When possible, NO per-branch tests are used.
  * Every GOSS template is included in `goss.yaml` and the needed vars are in place.

### Specific GOSS acceptance criteria

* [ ] No distro-specific tests are included.
* [ ] Prioritise using the tests included in the templates over creating custom tests.
* [ ] Due to GOSS limitations, there can't be two tests with the same name or checking the same file/directory. In those cases, only one of them will be run.
* [ ] For clarity purposes, the vars needed for the GOSS templates shouldn't be used in the custom tests at `app.yaml`.
* [ ] Tests should not rely on system packages (e.g. `curl`). Favor built-in GOSS primitives instead.
* [ ] Prefer checking the exit status of a command rather than looking for a specific output. This will avoid most of the potential flakiness.

### Run GOSS locally

Sometimes it is of interest to run the tests locally, for example during development. Though there may be different approaches, you may follow the steps below to execute the tests locally:

1. Download the [GOSS binary for Linux](https://github.com/goss-org/goss/releases/)
2. Launch the container using some command that ensures it will not exit immediately.

    Using a "bash" container, you can use the Docker Compose file below:

    ```yaml
    services:
      main:
        image: bitnami/app_name
        entrypoint:
        - bash
        command:
        - -c
        - "tail -f /dev/null"
        volumes:
        - /local/path/to/repo/containers/.vib:/shared
    ```

    Using a scratch container, you can use the Docker Compose file below:

    ```yaml
    services:
      copy-busybox:
        image: us-east1-docker.pkg.dev/bitnami-labs/bitnami-labs/minideb-busybox:latest
        entrypoint:
        - bash
        command:
        - -ec
        - |
          echo "Copying busybox to /tools/busybox"
          cp /usr/bin/busybox /tools/busybox
          sync
          echo "Sleeping for 10 seconds to ensure health check passes"
          sleep 10
          echo "Done"
        healthcheck:
          test: ["CMD", "test", "-f", "/tools/busybox"]
          interval: 2s
          timeout: 1s
          retries: 10
        volumes:
        - shared_tools:/tools
      main:
        image: bitnami/app_name
        entrypoint:
        - /tools/busybox
        command:
        - sleep
        - "600"
        volumes:
        - shared_tools:/tools
        - /local/path/to/repo/containers/.vib:/shared
        depends_on:
          copy-busybox:
            condition: service_healthy

    volumes:
      shared_tools:
        driver: local
    ```

3. Add the Goss binary:

    ```bash
    chmod +x /local/path/to/binary/goss-linux-amd64
    docker compose cp /local/path/to/binary/goss-linux-amd64 main:/goss
    ```

4. Launch the tests

    ```console
    $ docker compose exec --workdir /shared main /goss --gossfile /shared/app_name/goss/goss.yaml --vars /shared/app_name/goss/vars.yaml validate
    .........
    Total Duration: 1.203s
    Count: 11, Failed: 0, Skipped: 0
    ```
