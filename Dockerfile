FROM mambaorg/micromamba:2

# Install dependencies into the base environment
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml
RUN micromamba install -y -n base -f /tmp/environment.yml && \
    micromamba clean --all --yes

# Install svensemble itself (non-editable, no dependency resolution)
COPY --chown=$MAMBA_USER:$MAMBA_USER pyproject.toml README.md LICENSE.md /tmp/src/
COPY --chown=$MAMBA_USER:$MAMBA_USER svensemble /tmp/src/svensemble
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN pip install --no-deps /tmp/src && rm -rf /tmp/src

# Put the environment on PATH for non-entrypoint use (docker run --entrypoint, apptainer exec)
ENV PATH=/opt/conda/bin:$PATH

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh", "svensemble"]
CMD ["--help"]
