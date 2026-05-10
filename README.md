# Llama Server Docker with GPU Support

This project provides a reproducible Docker setup for running llama-server with CUDA GPU acceleration on Artix Linux. based on https://www.youtube.com/watch?v=8F_5pdcD3HY

## Features

- **Artix Linux Base**: Reproducible build environment
- **CUDA GPU Support**: Full GPU acceleration with TurboQuant
- **GCC 13 Compatibility**: Uses local gcc13 packages for CUDA compatibility
- **TurboQuant**: Optimized quantization for better performance
- **Reproducible**: All dependencies and configuration version controlled

## Quick Start

```bash
# 1. Install Git LFS (if not already installed)
# Ubuntu/Debian: sudo apt-get install git-lfs
# Arch/Artix: sudo pacman -S git-lfs
# macOS: brew install git-lfs
# Or download from: https://git-lfs.github.com/

# 2. Initialize Git LFS globally (one-time setup)
git lfs install

# 3. Clone the repository
git clone https://github.com/denkijin/llama_pg.git
cd llama_pg

# 4. Download large files via Git LFS
git lfs pull

# 5. Verify GCC packages are present
ls -la *.pkg.tar.zst

# 6. Build and run
docker compose up --build
```

## Configuration

### Environment Variables
The container supports several environment variables for customization:

```bash
# Model Configuration
MODEL_FILE=Qwen3.6-35B-A3B-UD-Q4_K_M.gguf    # Model filename
MODEL_URL=                                      # Model download URL (optional)
MODEL_DIR=/root/models                          # Model directory

# Performance Settings
N_CTX=256000                                    # Context size
N_GPU_LAYERS=99                                 # GPU layers (-1 for all)
N_THREADS=6                                      # CPU threads
```

### Docker Compose
- **Port**: 8080
- **GPU**: NVIDIA CUDA with full acceleration
- **Model**: Configurable via MODEL_FILE environment variable
- **Volume**: Mounted from local cache

### Build Configuration
- **Base**: artixlinux/artixlinux:base
- **Compiler**: nvcc with GCC 13 host compiler
- **GPU Architecture**: sm_89 (RTX 4080)
- **Optimization**: Release build with parallel compilation


## Requirements

- Docker with NVIDIA Container Toolkit
- NVIDIA GPU with CUDA support
- Git LFS (for GCC package downloads)
- Local gcc13 packages (included in repository via Git LFS)



## BeeLLama Integration

This project includes support for BeeLLama.cpp, an advanced fork with speculative decoding capabilities.

### BeeLLama Configuration Files
- **Dockerfile.bee**: Build configuration for BeeLLama.cpp
- **docker-compose.beellama.yml**: Service orchestration with speculative decoding

### Key Differences/Upgrades
- **Speculative Decoding**: DFlash algorithm with draft model support
- **Advanced Caching**: additional TurboQuant TCQ cache types


## License

This project follows the same license as llama.cpp and TurboQuant.
