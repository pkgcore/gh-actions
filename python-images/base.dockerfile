FROM docker.io/gentoo/stage3
ARG PYTHON_VERSION
ARG PYTHON_UNMASK
# use webrsync for speed reasons, and since we don't care about "latest from today"
RUN [ -n "${PYTHON_VERSION}" ] || { echo "--build-arg PYTHON_VERSION must be passed"; exit 1; }
RUN \
  atom="<dev-lang/python-${PYTHON_VERSION}.99:${PYTHON_VERSION}" && \
  mkdir -p /etc/portage/package.{accept_keywords,unmask} && \
  echo "${atom} $([ -n "${PYTHON_UNMASK}" ] && echo '**')" >> /etc/portage/package.accept_keywords/python && \
  [ -z "$PYTHON_UNMASK" ] || echo "${atom}" > /etc/portage/package.unmask/python
RUN \
  emerge-webrsync && \
  emerge -u dev-lang/python && \
  rm -rf /var/cache/distfiles /var/db/repos/gentoo
