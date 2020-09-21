####################################
## Dockerfile to run Anisble Lint ##
####################################
FROM jwfuller/ansible-lint:latest

#########################################
# Label the instance and set maintainer #
#########################################
LABEL com.github.actions.name="Ansible Lint" \
    com.github.actions.description="Lint your code base with Ansible Lint" \
    com.github.actions.icon="code" \
    com.github.actions.color="red" \
    maintainer="CU Boulder"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
