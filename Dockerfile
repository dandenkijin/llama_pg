# Build stage for gcc13-libs
FROM artixlinux/artixlinux:base AS builder

# Set optimization environment variables
ENV MAKEFLAGS="-j$(($(nproc)-4))"
ENV RUSTFLAGS="-C target-cpu=native"
ENV CARGO_BUILD_JOBS=$(($(nproc)-4))

# Install build dependencies
RUN pacman -Sy --noconfirm \
    base-devel \
    git \
    cmake \
    ninja \
    python \
    clang \
    && \
    rm -rf /var/cache/pacman/pkg/*

# Create build user for AUR packages
RUN useradd -m builduser && \
    echo "builduser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo 'MAKEFLAGS="-j$(($(nproc)-4))"' >> /etc/makepkg.conf && \
    echo 'RUSTFLAGS="-C target-cpu=native"' >> /etc/makepkg.conf && \
    echo 'CARGO_BUILD_JOBS=$(($(nproc)-4))' >> /etc/makepkg.conf

# Mount local gcc13 package (eliminates AUR build time)
VOLUME ["/usr/lib/gcc/x86_64-pc-linux-gnu/13.4.1:/usr/lib/gcc13"]

# Final stage
FROM artixlinux/artixlinux:base

# Install runtime dependencies
RUN pacman -Sy --noconfirm \
    base-devel \
    git \
    cmake \
    ninja \
    python \
    cuda \
    nvidia-utils \
    clang \
    vulkan-headers \
    vulkan-icd-loader \
    vulkan-validation-layers \
    && \
    rm -rf /var/cache/pacman/pkg/*

# Copy and install local gcc13 packages
COPY ./gcc13-libs-13.4.1+r80+gd6ebfe4-1-x86_64.pkg.tar.zst ./gcc13-13.4.1+r80+gd6ebfe4-1-x86_64.pkg.tar.zst /tmp/
RUN cd /tmp && \
    pacman -U --noconfirm gcc13-13.4.1+r80+gd6ebfe4-1-x86_64.pkg.tar.zst gcc13-libs-13.4.1+r80+gd6ebfe4-1-x86_64.pkg.tar.zst && \
    rm -f gcc13-13.4.1+r80+gd6ebfe4-1-x86_64.pkg.tar.zst gcc13-libs-13.4.1+r80+gd6ebfe4-1-x86_64.pkg.tar.zst

# Essential Environment Variables for NVIDIA Container Toolkit
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV PATH="/opt/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/cuda/lib64"

# Set GCC 13 as host compiler for nvcc
ENV CC=/usr/bin/gcc-13
ENV CXX=/usr/bin/g++-13

# Clone TurboQuant repository
RUN git clone https://github.com/TheTom/llama-cpp-turboquant.git /root/llama-cpp-turboquant

WORKDIR /root/llama-cpp-turboquant

# Build with CUDA using nvcc and GCC 13 host compiler
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release -DGGML_CUDA=ON \
      -DCMAKE_CXX_COMPILER=/usr/bin/g++-13 \
      -DCMAKE_CUDA_COMPILER=/opt/cuda/bin/nvcc \
      -DCMAKE_CUDA_HOST_COMPILER=/usr/bin/g++-13 \
      -DCMAKE_CUDA_ARCHITECTURES=89 \
      -DCMAKE_CUDA_FLAGS="-arch=sm_89" \
    && cmake --build build --config Release -t llama-server

