# Use an official Jupyter Notebook base image
FROM jupyter/base-notebook

# Switch to root to install packages
USER root

# Copy environment file and install Mamba for faster dependency solving
COPY environment.yml /tmp/environment.yml
RUN conda install -n base -c conda-forge mamba -y && \
    mamba env update -n base -f /tmp/environment.yml && \
    conda clean --all -y

# Set matplotlib config and conda cache dir permissions
RUN mkdir -p /home/jovyan/.config/matplotlib && \
    mkdir -p /home/jovyan/.cache/conda/notices && \
    chown -R jovyan:users /home/jovyan/.config /home/jovyan/.cache

# Switch back to jovyan user
USER jovyan

# Set the working directory inside the container
WORKDIR /home/jovyan/work

# Copy the project files into the container
COPY --chown=jovyan:users . .

# Expose the default Jupyter Notebook port
EXPOSE 8888

# Start Jupyter Notebook without token or password
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]
