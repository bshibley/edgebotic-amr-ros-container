FROM bshibley/rover_isaac_ros-aarch64:1705013869

WORKDIR "/workspace"

COPY workspace/src src

# Install dependencies
RUN source /workspace/install/setup.bash && apt-get update && \
    rosdep install --from-paths src --ignore-src --rosdistro humble -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Populate and build workspace
RUN source /workspace/install/setup.bash && \
    colcon build --cmake-args=-DCMAKE_BUILD_TYPE=Release --parallel-workers $(nproc) && \
    rm -r build src