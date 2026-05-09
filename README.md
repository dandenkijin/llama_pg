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

### Docker Compose
- **Port**: 8080
- **GPU**: NVIDIA CUDA with full acceleration
- **Model**: Qwen3.6-35B-A3B-Q4_K_M.gguf (mounted from local cache)

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


## Version Control

This project uses Git for version control with the following strategy:
- **Main branch**: `main` (stable releases)
- **Feature branches**: `feature/<name>` (experimental changes)
- **Tags**: `v<major>.<minor>.<patch>` (semantic versioning)

## Development

### Building from Source
```bash
# Make changes to Dockerfile or docker-compose.yml
docker compose down
docker compose up --build
```

### Testing GPU Support
```bash
# Test endpoint
curl -X POST http://localhost:8080/completion \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Hello, how are you?", "n_predict": 10}'
```

## Architecture

```
├── Dockerfile              # Main build configuration
├── docker-compose.yml     # Service orchestration
├── .gitignore           # Version control exclusions
├── README.md             # This file
├── gcc13-*.pkg.tar.zst  # Local GCC 13 packages
|-- gcc14-*.pkg.tar.zst  # Local GCC 14 packages
└── .pi/                 # Agent configurations
```


### GPU Detection Issues
- Ensure NVIDIA Container Toolkit is installed
- Check GPU architecture matches your hardware
- Verify CUDA drivers are up to date

### Build Issues
- Clear Docker cache: `docker system prune -a`
- Check gcc13 package versions
- Verify all dependencies are installed
- Ensure GCC packages are properly downloaded via Git LFS

## License

This project follows the same license as llama.cpp and TurboQuant.
