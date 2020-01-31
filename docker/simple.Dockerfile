### BASE STAGE ###

# Build from ros dev box
FROM jgkawell/ros:base AS base

# Install catkin tools and make sure MoveIt! is installed
RUN apt -y update && apt -y install python-catkin-tools ros-kinetic-moveit

# Create catkin workspace
RUN mkdir -p ~/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd ~/catkin_ws/; catkin build'
RUN cd ~/catkin_ws && wstool init src

# Setup Intera SDK (https://sdk.rethinkrobotics.com/intera/Workstation_Setup)
RUN apt -y update && apt -y install git-core python-argparse python-vcstools python-rosdep ros-kinetic-control-msgs ros-kinetic-joystick-drivers ros-kinetic-xacro ros-kinetic-tf2-ros ros-kinetic-rviz ros-kinetic-cv-bridge ros-kinetic-actionlib ros-kinetic-actionlib-msgs ros-kinetic-dynamic-reconfigure ros-kinetic-trajectory-msgs ros-kinetic-rospy-message-converter
RUN cd ~/catkin_ws/src \
        && git clone https://github.com/RethinkRobotics/sawyer_robot.git \
        && wstool merge sawyer_robot/sawyer_robot.rosinstall \
        && wstool update

# Move and edit setup script for local sims
RUN cd ~/catkin_ws \
        && cp src/intera_sdk/intera.sh . \
        && sed -i "s|your_ip=\"192.168.XXX.XXX\"|\#your_ip= \"192.168.XXX.XXX\"|g" ./intera.sh \
        && sed -i "s|\#your_hostname=\"my_computer.local\"|your_hostname=\"localhost\"|g" ./intera.sh \
        && sed -i "s|ros_version=\"indigo\"|ros_version=\"kinetic\"|g" ./intera.sh

# Setup Sawyer simulator (https://sdk.rethinkrobotics.com/intera/Gazebo_Tutorial)
RUN apt -y update && apt -y install gazebo7 ros-kinetic-qt-build ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-ros-control ros-kinetic-control-toolbox ros-kinetic-realtime-tools ros-kinetic-ros-controllers ros-kinetic-xacro python-wstool ros-kinetic-tf-conversions ros-kinetic-kdl-parser ros-kinetic-sns-ik-lib
RUN cd ~/catkin_ws/src \
        && git clone https://github.com/RethinkRobotics/sawyer_simulator.git \
        && wstool merge sawyer_simulator/sawyer_simulator.rosinstall \
        && wstool update

# Install Sawyer MoveIt!
RUN cd ~/catkin_ws/src \
        && git clone https://github.com/RethinkRobotics/sawyer_moveit.git \
        && wstool merge sawyer_moveit/sawyer_moveit.rosinstall \
        && wstool update

# Finally build the workspace
RUN cd ~/catkin_ws && catkin build

# Copy over config files
COPY ./config/sawyer_moveit.rviz /root/catkin_ws/config/sawyer_moveit.rviz

# Added alias for Intera to .bashrc
RUN echo 'alias sim="cd ~/catkin_ws && clear && ./intera.sh sim"' >> ~/.bashrc

# Clean up apt
RUN rm -rf /var/lib/apt/lists/*


### NVIDIA STAGE ###

# Extra needed setup for Nvidia-based graphics
FROM base AS nvidia

# Copy over needed OpenGL files from Nvidia's image
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 /usr/local /usr/local
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 /etc/ld.so.conf.d/glvnd.conf /etc/ld.so.conf.d/glvnd.conf
