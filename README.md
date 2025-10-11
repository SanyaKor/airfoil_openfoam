# 🌀 NACA Airfoil CFD Simulation — OpenFOAM + Python + ParaView

## 📘 Project Overview

This project provides a fully automated **computational pipeline** for simulating and analyzing the aerodynamic performance of a **NACA airfoil** using **OpenFOAM**, **C++**, **Python**, and **ParaView**.

It automates:
- Running multiple simulations for different angles of attack (AoA);
- Extracting aerodynamic coefficients (Cl, Cd);
- Visualizing and analyzing results in Python and ParaView.

The project is designed for CFD students, engineers, and researchers who need a modular and reproducible system for NACA airfoil simulations.


## 🧩 Components Description

### 🧱 1. `unit_tests.sh`
This **bash script** automates simulation runs for a range of angles of attack (from 1° up to N°, where N ≤ 30).

**Usage:**
```bash
./unit_tests.sh 10
```
This command creates a folder named `TESTS10_YYYY-MM-DD/`, runs 10 simulations (AoA = 1°–10°), and saves `.dat` files and `angles.txt`.

**Parameters:**
- The first argument (`N`) defines the number of tests (default = 30).
- Each run automatically generates a new directory with the current date.

---

### 🧮 2. `unit_testing.ipynb`

A **Jupyter Notebook** that includes two main cells:

**Cell 1 — Generate angle data:**
- Creates a `data.txt` file listing all angles of attack for testing.
- Used when `data.txt` is missing or needs to be regenerated.

**Cell 2 — Analyze forceCoeffs data:**
- Reads `.dat` files from the `AIRFOIL_TESTS` directory.
- Extracts `Cl` and `Cd` coefficients.
- Plots aerodynamic polars:
  - `Cl(α)` — lift vs. angle of attack
  - `Cd(α)` — drag vs. angle of attack
- Outputs summary tables and plots.

**Python requirements:**
```bash
pip install numpy pandas matplotlib
```

---

### 🧹 3. `cleaner.sh`
A simple script to clean up all temporary and simulation files — similar to OpenFOAM’s `./Allclean`.

**Usage:**
```bash
./cleaner.sh
```

Removes old case directories, temporary `.foam` files, and cached data.

---

### 📂 4. `AIRFOIL_TESTS/`
Folder that stores the results of each simulation batch.  
Each folder follows the naming format `TESTS<N>_<date>` and contains:

- `.dat` files with `forceCoeffs` data for each AoA;
- `angles.txt` — list of angles used for that simulation series;
- Optional intermediate OpenFOAM case directories (`0/`, `constant/`, `system/`).

---

### 🧱 5. `blockMeshGen/`
Contains a Jupyter notebook `blockMeshGen.ipynb` that generates a custom **blockMeshDict**.

> ⚠️ Note:  
> Some unstable meshes produced unrealistic `Cl` values (up to 10⁷⁵).  
> Therefore, a stable and validated `blockMeshDict` is provided and used by default.

---

## 🚀 Running the Pipeline

If `data.txt` does not exist, run the complete workflow in this order:

### 1️⃣ Generate angle data
```bash
# In Jupyter Notebook
# Execute the first cell of unit_testing.ipynb
```

### 2️⃣ Run simulations
```bash
./unit_tests.sh 10
```

### 3️⃣ Analyze results
```bash
# In Jupyter Notebook
# Execute the second cell of unit_testing.ipynb
```

### 4️⃣ Clean up (optional)
```bash
./cleaner.sh
```

---

## 📈 Example of `forceCoeffs` Results

| Angle of Attack (°) | Cl    | Cd    |
|----------------------|-------|-------|
| 1                    | 0.18  | 0.012 |
| 5                    | 0.53  | 0.016 |
| 10                   | 1.12  | 0.023 |
| 15                   | 1.38  | 0.056 |

---

## 🧰 Tools and Technologies

| Component         | Purpose |
|-------------------|----------|
| **OpenFOAM**      | CFD solver for steady-state flow |
| **Python / Jupyter** | Data analysis and plotting |
| **C++**            | Core solver utilities and NACA geometry generation |
| **ParaView**       | Post-processing and visualization |
| **Bash**           | Automation for batch simulations |

---

## 🔍 Features

- Automated **batch testing** for angles of attack up to 30°
- **Cl/Cd extraction** from OpenFOAM forceCoeffs output
- **Polar curves plotting** (Cl(α), Cd(α))
- Integration with **ParaView** for visual field analysis
- Customizable **blockMesh** generation via `blockMeshGen.ipynb`
- Lightweight and reproducible simulation workflow

---

## 🧠 Notes

- Compatible with **OpenFOAM v10–v11**
- Uses the **forceCoeffs** functionObject for aerodynamic coefficient extraction
- Recommended for 2D airfoil steady-state validation studies

