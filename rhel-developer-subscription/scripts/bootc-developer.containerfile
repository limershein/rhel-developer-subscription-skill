# Containerfile for RHEL Developer bootc image
#
# This demonstrates how to build a bootc (image mode) RHEL system
# with developer tools pre-installed using a Developer subscription
#
# Build with:
#   podman build -f bootc-developer.containerfile \
#     --build-arg ORG_ID=1234567 \
#     --build-arg ACTIVATION_KEY=my-key \
#     -t rhel-developer-bootc:latest .
#
# Deploy:
#   sudo podman run --rm --privileged \
#     -v /var/lib/containers:/var/lib/containers \
#     rhel-developer-bootc:latest \
#     bootc install to-disk /dev/vda

FROM registry.redhat.io/rhel10/rhel-bootc:latest

# Build arguments for subscription
ARG ORG_ID
ARG ACTIVATION_KEY

# Labels
LABEL name="rhel-developer-bootc"
LABEL version="1.0"
LABEL description="RHEL Developer bootc image with development tools"

# Register, install packages, then unregister
# Note: For production, consider embedding repository configurations
# instead of credentials
RUN if [ -n "${ORG_ID}" ] && [ -n "${ACTIVATION_KEY}" ]; then \
      subscription-manager register \
        --org="${ORG_ID}" \
        --activationkey="${ACTIVATION_KEY}" && \
      subscription-manager repos \
        --enable rhel-10-for-x86_64-baseos-beta-rpms \
        --enable rhel-10-for-x86_64-appstream-beta-rpms; \
    fi && \
    dnf install -y \
      # Core development tools
      gcc \
      gcc-c++ \
      make \
      autoconf \
      automake \
      libtool \
      # Version control
      git \
      git-lfs \
      # Scripting languages
      python3 \
      python3-pip \
      # Container tools
      podman \
      buildah \
      skopeo \
      # Infrastructure as code
      ansible-core \
      # Editors
      vim-enhanced \
      nano \
      # Utilities
      tmux \
      tree \
      jq \
      curl \
      wget \
      # Debugging tools
      gdb \
      strace \
      ltrace \
      # System tools
      systemd \
      NetworkManager \
      # Documentation
      man-db \
      man-pages && \
    dnf clean all && \
    if [ -n "${ORG_ID}" ] && [ -n "${ACTIVATION_KEY}" ]; then \
      subscription-manager unregister || true; \
    fi

# Configure bootc-compatible systemd
RUN systemctl enable NetworkManager && \
    systemctl enable sshd

# Create developer user
RUN useradd -m -G wheel developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer

# Set up development directories
RUN mkdir -p /opt/projects && \
    chown developer:developer /opt/projects

# Configure git (system-wide defaults)
RUN git config --system init.defaultBranch main && \
    git config --system pull.rebase false

# Add useful aliases
RUN echo 'alias ll="ls -lah"' >> /etc/bashrc && \
    echo 'alias k="kubectl"' >> /etc/bashrc && \
    echo 'alias d="podman"' >> /etc/bashrc

# Configure prompt
RUN echo 'PS1="[\u@\h \W]\\$ "' >> /etc/bashrc

# Set timezone (customize as needed)
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Final cleanup
RUN rm -rf /var/cache/dnf/* /tmp/*

# Metadata for bootc
RUN echo "Built: $(date)" > /etc/image-build-info
