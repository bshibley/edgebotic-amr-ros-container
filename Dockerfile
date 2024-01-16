FROM bshibley/rover_isaac_ros-aarch64:1705013869

WORKDIR "/workspace"

COPY workspace/src src

# Install dependencies
RUN source /workspace/install/setup.bash && apt-get update && \
    rosdep install --from-paths src --ignore-src --rosdistro humble -y && \
    apt-get install ros-humble-teleop-twist-keyboard picocom -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Populate and build workspace
RUN source /workspace/install/setup.bash && \
    export CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -fPIC" && \
    colcon build --cmake-args=-DCMAKE_BUILD_TYPE=Release --parallel-workers $(nproc) && \
    rm -r build src