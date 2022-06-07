# Bitnami Containers

Bitnami is currently working on unifying all container sources repositories into a single location. In the meantime, it will be synchronized in a daily manner to receive all the updates from the other repositories.

> NOTE: We use the latest commit to know the missing ones to sync. Do not edit this repository manually or the sync will be broken.
>       If you edit this repo please run the sync workflow manually providing:
>        - how many commits you added into the `shift` parameter.
>        - the container you affected into the `container` parameter.

> If the latest commit has been done directly in this repository and not all the containers have that commit, the sync will fail because the commit won't be found in upstream and the shift won't be the same for all the containers
