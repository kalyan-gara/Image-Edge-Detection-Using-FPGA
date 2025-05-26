# Image-Edge-Detection-Using-FPGA

This project implements edge detection on a pre-processed grayscale image using a **3x3 Median Filter** followed by a **Sobel Operator**, entirely designed in **Verilog** and deployed on a **Nexys A7 FPGA**.

## 🧩 Design Flow & Key Features

### 🧠 Preprocessing (MATLAB)
- Converted RGB images to **grayscale**
- Exported pixel data as **hex values** to be read by the FPGA

### 🔧 Median Filtering
- Designed a **3x3 median filter** to eliminate salt-and-pepper noise
- Implemented with a **pipelined architecture** for optimized hardware performance

### 🌀 Sobel Edge Detection
- Applied **3x3 Sobel kernels** (horizontal and vertical)
- Enhanced edge contrast using **absolute magnitude** calculation

### 💾 Memory Architecture
- Utilized **Block RAM (BRAM)** to store input/output image data
- Enabled **single-cycle read/write** operations for high throughput

### 🖥️ FPGA Implementation
- Simulated and synthesized using **Xilinx Vivado**
- Targeted hardware: **Nexys A7 FPGA**
- Functional verification done via **testbenches and waveform analysis**

### 📁 **Repository Structure**

```
Image-Edge-Detection-Using-FPGA/
├── README.md
├── LICENSE
├── .gitignore
├── src/                # Verilog source files
│   ├── sobel_operator.v
│   ├── median_filter.v
│   ├── top_module.v
│   └── vga_controller.v
├── sim/                # Simulation testbenches
│   └── tb_top_module.v
├── images/             # Image data and outputs
│   ├── input/
│   ├── median_output/
│   ├── sobel_output/
│   └── vga_output/
```



## 🚀 Future Work

Although input data was preloaded and not captured in real time, this project showcases how low-latency FPGA-based systems can efficiently perform image processing. This paves the way for:
- Real-time image capture and processing
- Edge-based feature extraction for computer vision
- Fully pipelined video processing pipelines

## 👨‍💻 Author

Gara Kalyan — FPGA & Image Processing Enthusiast


